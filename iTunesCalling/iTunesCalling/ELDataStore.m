//
//  ELDataStore.m
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 6/26/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "ELDataStore.h"

@interface ELDataStore ()

@end


@implementation ELDataStore

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


# pragma mark - Singleton


+ (ELDataStore *)sharedELDataStore {
    static ELDataStore *_sharedELDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedELDataStore = [[ELDataStore alloc] init];
    });
    
    return _sharedELDataStore;
}

# pragma mark - AppEntry Methods

- (NSArray *)appEntryArray  {
    
    if (!_appEntryArray)
    {
        _appEntryArray = [NSMutableArray new];
    }
    return _appEntryArray;
    
}

//- (void)addAppEntry:(AppEntry *)appEntry {
//    NSLog(@"app entryryryry: %@", appEntry);
//    [self.appEntryArray addObject:appEntry];
//}
//
//
//- (NSInteger)numberOfAppEntries {
//    
//    return [self.appEntryArray count];
//}
//
//
//- (AppEntry *)getAppEntryAtIndex:(NSInteger)index {
//    AppEntry *appEntry = [self.appEntryArray objectAtIndex:index];
//    NSLog(@"Getting app Entry: %@",appEntry.name);
//    return [self.appEntryArray objectAtIndex:index];
//}


#pragma mark - Favorite App Methods

- (NSArray *)favoriteAppArray {
    
    if (!_favoriteAppArray)
    {
        _favoriteAppArray = [NSMutableArray new];
    }
    return _favoriteAppArray;
    
}

- (NSArray *)fetchFavorites {
    
    NSFetchRequest *favoritesFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FavoriteApp"];
    
    NSArray *favorites = [[NSArray alloc] init];
    
    NSError *error;
    
    favorites = [self.managedObjectContext executeFetchRequest:favoritesFetchRequest error:&error];
    if (error)
    {
        NSLog(@"%@",error);
    }
    
    return favorites;
}


//- (NSFetchedResultsController *) fetchedFavoriteResultsController
//{
//    if (!_fetchedFavoriteResultsController)
//    {
//        NSFetchRequest *favoriteFetch = [[NSFetchRequest alloc] initWithEntityName:@"FavoriteApp"];
//        favoriteFetch.fetchBatchSize = 26;
//        
//        //   NSPredicate *toDoPredicate = [NSPredicate predicateWithFormat:@"list == %@" , self.listInQuestion];
//        // toDosFetch.predicate = toDoPredicate;
//        
//        NSSortDescriptor *alphabetical = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
//        favoriteFetch.sortDescriptors = @[alphabetical];
//        
//        _fetchedFavoriteResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:favoriteFetch managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"fetchFavoriteResultsCache"];
//        
//        [_fetchedFavoriteResultsController performFetch:nil];
//    }
//    
//    return _fetchedFavoriteResultsController;
//}

-(BOOL)previouslyFavorited:(NSNumber *)idNumber
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"FavoriteApp" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"(idNumber = %@)", idNumber];
    [request setPredicate:idPredicate];
    
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if ([results count] == 0) {
        return NO;
    } else {
        return YES;
    }
}



//- (void)addFavoriteApps:(FavoriteApp *)favoriteApp{
//    [self.favoriteAppArray addObject:favoriteApp];
//    NSLog(@"My favorite apps: %@", self.favoriteAppArray);
//}
//    favoriteApp =[NSEntityDescription insertNewObjectForEntityForName:@"FavoriteApp" inManagedObjectContext:self.managedObjectContext];
//
//    NSLog(@"My favorite apps: %@", favoriteApp);
//    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.favoriteApps];
//    NSLog(@"My self. favorite: %@", self.favoriteApps);
//    [tempArray addObject:favoriteApp];
//
//    NSLog(@"My favorite apps: %@", tempArray);
//
//    _favoriteApps = [[NSArray alloc] initWithArray:tempArray];
//
//    [self saveContext];
//


//



#pragma mark - Context

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iTunesCalling" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iTunesCalling.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end

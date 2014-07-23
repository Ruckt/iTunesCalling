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

#pragma mark - Favorite App Methods

- (NSArray *)favoriteAppArray {
    
    if (!_favoriteAppArray)
    {
        _favoriteAppArray = [NSMutableArray new];
    }
    return _favoriteAppArray;
    
}

- (NSArray *)fetchFavorites {
    
    [self unFavorApp:nil];
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



- (BOOL)previouslyFavorited:(NSNumber *)idNumber
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

- (void)unFavorApp:(NSNumber *)idNumber
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"FavoriteApp" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"(idNumber = %@)", idNumber];
    [request setPredicate:idPredicate];
    
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if ([results count] != 0) {
        for (NSManagedObject *savedApp in results) {
            [self.managedObjectContext deleteObject:savedApp];
        }
    }
}




#pragma mark - Context

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



#pragma mark - Core Data stack

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

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iTunesCalling" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iTunesCalling.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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

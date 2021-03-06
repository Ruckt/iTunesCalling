//
//  ELDataStore.h
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 6/26/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppEntry.h"

@class FavoriteApp;

@interface ELDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//@property (nonatomic, strong) NSFetchedResultsController *fetchedFavoriteResultsController;
@property (nonatomic, strong) NSMutableArray *appEntryArray;
@property (nonatomic, strong) NSMutableArray *favoriteAppArray;

+ (ELDataStore *)sharedELDataStore;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (NSArray *)fetchFavorites;
-(BOOL)previouslyFavorited:(NSNumber *)idNumber;
- (void)unFavorApp:(NSNumber *)idNumber;

@end

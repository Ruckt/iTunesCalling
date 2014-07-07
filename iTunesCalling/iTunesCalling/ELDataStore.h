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

@class AppEntry;

@interface ELDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (ELDataStore *)sharedELDataStore;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)addAppEntry:(AppEntry *)appEntry;
- (NSInteger)numberOfAppEntries;
- (AppEntry *)getAppEntryAtIndex:(NSInteger)index;



@end

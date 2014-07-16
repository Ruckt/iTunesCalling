//
//  ELiTunesDataProvider.m
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/5/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "ELiTunesDataProvider.h"
#import "AppEntry+Methods.h"
#import "ELDataStore.h"
#import <AFNetworking.h>

NSString* const ITunesURL = @"http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topgrossingapplications/sf=143441/limit=25/json";

@interface ELiTunesDataProvider ()

@property (strong, nonatomic) NSMutableArray *applicationListArray;
@property (nonatomic, strong) ELDataStore *dataStore;
@end

@implementation ELiTunesDataProvider


- (id)init {
    self.dataStore = [ELDataStore sharedELDataStore];
    
    
    return self;
}


- (void)postNotification //post notification method and logic
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchComplete" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - iTunes Fetching

- (void)startiTunesFetch
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:ITunesURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        //NSLog(@"dictionary: %@", responseDictionary);
        [self parseDictionary:responseDictionary];
        [self postNotification];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)parseDictionary:(NSDictionary *)responseDictionary
{
    
    NSDictionary *subDictionary = [responseDictionary objectForKey:@"feed"];
    NSDictionary *applicationDictionary = [subDictionary objectForKey:@"entry"];

    for (NSDictionary *eachAppInfo in applicationDictionary) {
        
        NSDictionary *appNameDictionary = [eachAppInfo objectForKey:@"im:name"];
        NSString *appName = [appNameDictionary objectForKey:@"label"];
        NSLog(@"Name: %@", appName);
        
        NSDictionary *appIdDictionary = [eachAppInfo objectForKey:@"id"];
        NSDictionary *subIdDictionary = [appIdDictionary objectForKey:@"attributes"];
        NSString *iTunesAppURL = [appIdDictionary objectForKey:@"label"];
        NSString *idNumberString = [subIdDictionary objectForKey:@"im:id"];
        NSNumber *idNumber = @([idNumberString integerValue]);
        //NSLog(@"App ID: %@", idNumber);

        NSDictionary *appArtistDictionary = [eachAppInfo objectForKey:@"im:artist"];
        NSString *appArtist = [appArtistDictionary objectForKey:@"label"];
        //NSLog(@"Artist: %@", appArtist);
        
        NSDictionary *appPriceDictionary = [eachAppInfo objectForKey:@"im:price"];
        NSString *appPrice = [appPriceDictionary objectForKey:@"label"];
        //NSLog(@"Price: %@", appPrice);
    
        
        NSDictionary *appSummaryDictionary = [eachAppInfo objectForKey:@"summary"];
        NSString *appSummary = [appSummaryDictionary objectForKey:@"label"];
        //NSLog(@"Summary: %@", appSummary);
        
        
        NSString *largePictureURL;
        NSString *smallPictueURL;
        NSDictionary *allPictureInfo = [eachAppInfo objectForKey:@"im:image"];
    
        for (NSDictionary *eachPictureInfo in allPictureInfo) {
            NSDictionary *subPictureDictionary = [eachPictureInfo objectForKey:@"attributes"];
            NSString *height = [subPictureDictionary objectForKey:@"height"];
            if ([height isEqualToString:@"100"]) {
                //NSLog(@"Large link %@", [eachPictureInfo objectForKey:@"label"]);
                largePictureURL = [eachPictureInfo objectForKey:@"label"];
            } else if ([height isEqualToString:@"53"]){
                //NSLog(@"Small link %@", [eachPictureInfo objectForKey:@"label"]);
                smallPictueURL = [eachPictureInfo objectForKey:@"label"];
            }
        }
        //NSLog(@"Url: %@", iTunesAppURL);

        AppEntry *appEntry = [AppEntry appEntryName:appName
                                           idNumber:idNumber
                                             artist:appArtist
                                            summary:appSummary
                                              price:appPrice
                                           sharLink:iTunesAppURL
                                    largePictureURL:largePictureURL
                                 andSmallPictureURL:smallPictueURL
                             inManagedObjectContext:self.dataStore.managedObjectContext];
        
        [self.dataStore addAppEntry:appEntry];

    }
    
    //NSLog(@"entries: %ld", (long)[self.dataStore numberOfAppEntries]);
    
}

@end

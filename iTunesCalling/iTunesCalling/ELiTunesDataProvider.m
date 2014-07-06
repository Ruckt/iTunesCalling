//
//  ELiTunesDataProvider.m
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/5/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "ELiTunesDataProvider.h"
#import "Application.h"
#import <AFNetworking.h>

NSString* const ITunesURL = @"http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topgrossingapplications/sf=143441/limit=25/json";

@interface ELiTunesDataProvider ()

@property (strong, nonatomic) NSMutableArray *applicationListArray;
@end

@implementation ELiTunesDataProvider


#pragma mark - iTunes Fetching

- (void)startiTunesFetch
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:ITunesURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        //NSLog(@"dictionary: %@", responseDictionary);
        [self parseDictionary:responseDictionary];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)parseDictionary:(NSDictionary *)responseDictionary
{
    
    NSDictionary *subDictionary = [responseDictionary objectForKey:@"feed"];
    NSDictionary *applicationDictionary = [subDictionary objectForKey:@"entry"];
    NSLog(@"App Only Dictionary: %@", applicationDictionary);
    
    for (NSDictionary *eachAppInfo in applicationDictionary) {
        
        NSDictionary *appNameDictionary = [eachAppInfo objectForKey:@"im:name"];
        NSString *appName = [appNameDictionary objectForKey:@"label"];
        NSLog(@"App Name: %@", appName);
//        NSDictionary *imageInfo = [eachPictureInfo objectForKey:@"images"];
//        NSDictionary *thumbnailInfo = [imageInfo objectForKey:@"thumbnail"];
//        NSString *thumbnailLink = [thumbnailInfo objectForKey:@"url"];

    }
    
}

@end

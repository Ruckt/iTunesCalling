//
//  AppEntry+Methods.m
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/6/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "AppEntry+Methods.h"

@implementation AppEntry (Methods)

+ (AppEntry *)appEntryName:(NSString *)name
                  idNumber:(NSNumber *)number
                    artist:(NSString *)artist
                   summary:(NSString *)summary
                     price:(NSString *)price
                  sharLink:(NSString *)shareLink
           largePictureURL:(NSString *)largePictureURL
        andSmallPictureURL:(NSString *)smallPictureURL
    inManagedObjectContext:(NSManagedObjectContext *)context {
    
    AppEntry *appEntry =  [NSEntityDescription insertNewObjectForEntityForName:@"AppEntry" inManagedObjectContext:context];
    
    appEntry.name = name;
    appEntry.idNumber = number;
    appEntry.artist = artist;
    appEntry.summary = summary;
    appEntry.price = price;
    appEntry.largePictureURL = largePictureURL;
    appEntry.smallPictureURl = smallPictureURL;
    appEntry.shareLink = shareLink;

    return appEntry;
}
@end

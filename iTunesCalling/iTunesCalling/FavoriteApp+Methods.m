//
//  FavoriteApp+Methods.m
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/20/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "FavoriteApp+Methods.h"

@implementation FavoriteApp (Methods)


+ (FavoriteApp *)appEntryName:(NSString *)name
                  idNumber:(NSNumber *)number
                    artist:(NSString *)artist
                   summary:(NSString *)summary
                     price:(NSString *)price
                  sharLink:(NSString *)shareLink
           largePictureURL:(NSString *)largePictureURL
        andSmallPictureURL:(NSString *)smallPictureURL
    inManagedObjectContext:(NSManagedObjectContext *)context {
    
    FavoriteApp *favApp =[NSEntityDescription insertNewObjectForEntityForName:@"FavoriteApp" inManagedObjectContext:context];
    
    favApp.name = name;
    favApp.idNumber = number;
    favApp.artist = artist;
    favApp.summary = summary;
    favApp.price = price;
    favApp.largePictureURL = largePictureURL;
    favApp.smallPictureURL = smallPictureURL;
    favApp.shareLink = shareLink;
    
    return favApp;
}

@end

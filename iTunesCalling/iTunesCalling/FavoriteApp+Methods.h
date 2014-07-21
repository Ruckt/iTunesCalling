//
//  FavoriteApp+Methods.h
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/20/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "FavoriteApp.h"

@interface FavoriteApp (Methods)

+ (FavoriteApp *)appEntryName:(NSString *)name
                  idNumber:(NSNumber *)number
                    artist:(NSString *)artist
                   summary:(NSString *)summary
                     price:(NSString *)price
                  sharLink:(NSString *)shareLink
           largePictureURL:(NSString *)largePictureURL
        andSmallPictureURL:(NSString *)smallPictureURL
    inManagedObjectContext:(NSManagedObjectContext *)context;


@end

//
//  AppEntry.m
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/20/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "AppEntry.h"


@implementation AppEntry


- (id)initWithName:(NSString *)name
            idNumber:(NSNumber *)number
              artist:(NSString *)artist
             summary:(NSString *)summary
               price:(NSString *)price
            sharLink:(NSString *)shareLink
     largePictureURL:(NSString *)largePictureURL
  andSmallPictureURL:(NSString *)smallPictureURL {
    
    self = [super init];
    if (self) {
        _name = name;
        _idNumber = number;
        _artist = artist;
        _summary = summary;
        _price = price;
        _shareLink = shareLink;
        _largePictureURL = largePictureURL;
        _smallPictureURL = smallPictureURL;
    }
    return self;
}



@end

//
//  AppEntry.h
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/20/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppEntry : NSObject

@property (strong, nonatomic) NSString * artist;
@property (strong, nonatomic) NSNumber * idNumber;
@property (strong, nonatomic) NSString * largePictureURL;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * price;
@property (strong, nonatomic) NSString * shareLink;
@property (strong, nonatomic) NSString * smallPictureURL;
@property (strong, nonatomic) NSString * summary;


- (id)initWithName:(NSString *)name
            idNumber:(NSNumber *)number
              artist:(NSString *)artist
             summary:(NSString *)summary
               price:(NSString *)price
            sharLink:(NSString *)shareLink
     largePictureURL:(NSString *)largePictureURL
  andSmallPictureURL:(NSString *)smallPictureURL;

@end



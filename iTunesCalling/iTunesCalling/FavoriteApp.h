//
//  FavoriteApp.h
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/20/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FavoriteApp : NSManagedObject

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSString * largePictureURL;
@property (nonatomic, retain) NSString * smallPictureURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * shareLink;
@property (nonatomic, retain) NSString * summary;

@end

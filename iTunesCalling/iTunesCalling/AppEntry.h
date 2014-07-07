//
//  AppEntry.h
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/6/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AppEntry : NSManagedObject

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSString * largePictureURL;
@property (nonatomic, retain) NSString * smallPictureURl;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * summary;

@end

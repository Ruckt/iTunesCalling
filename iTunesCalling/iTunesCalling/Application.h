//
//  Application.h
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/6/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Application : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSString * smallPictureURL;
@property (nonatomic, retain) NSString * largePictureURL;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * artist;

@end

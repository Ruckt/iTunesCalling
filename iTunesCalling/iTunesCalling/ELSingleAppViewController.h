//
//  ELSingleAppViewController.h
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/11/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AppEntry.h"
#import "FavoriteApp+Methods.h"

@interface ELSingleAppViewController : UIViewController

- (ELSingleAppViewController *)initWithAppEntry:(AppEntry *)appEntry;
- (ELSingleAppViewController *)initWithFavoriteApp:(FavoriteApp *)favoriteApp;

@property(nonatomic, strong) UIScrollView *appEntryView;

@end

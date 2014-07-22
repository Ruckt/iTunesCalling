//
//  ELAppCell.h
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/7/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppEntry.h"
#import "FavoriteApp+Methods.h"

@interface ELAppCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier appEntry:(AppEntry *)appEntry;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier favoriteApp:(FavoriteApp *)favoriteApp;

- (void)configureCellWithAppEntry:(AppEntry *)appEntry;
- (void)configureCellWithFavoriteApp:(FavoriteApp *)favoriteApp;

@property(nonatomic, strong) UIImageView *thumbnailImageView;

@end

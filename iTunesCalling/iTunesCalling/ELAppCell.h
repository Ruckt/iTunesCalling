//
//  ELAppCell.h
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/7/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppEntry.h"

@interface ELAppCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier appEntry:(AppEntry *)appEntry;
- (void)configureCellWithAppEntry:(AppEntry *)appEntry;
@property(nonatomic, strong) UIImageView *thumbnailImageView;

@end

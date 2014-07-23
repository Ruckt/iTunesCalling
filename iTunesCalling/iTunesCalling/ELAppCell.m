//
//  ELAppCell.m
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/7/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "ELAppCell.h"


static NSInteger const SPACE_BETWEEN = 10;
static NSInteger const TITLE_LABEL_WIDTH = 242;//337;
static NSInteger const THUMBNAIL_Y_COORDINATE = 15;
static NSInteger const THUMBNAIL_LENGTH = 53;
static NSInteger const NAME_LABEL_HEIGHT = 55;
static NSInteger const NAME_Y_COORDINATE = 5;
static NSInteger const ARTIST_LABEL_HEIGHT = 15;
static NSInteger const ARTIST_Y_COORDINATE = 60;

@interface ELAppCell()



@end

@implementation ELAppCell


#pragma mark - App Entry Cell Configuration

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier appEntry:(AppEntry *)appEntry
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self buildAppNameLabel:appEntry.name];
        [self buildThumbnailImageView];
        [self buildAppArtistLabel:appEntry.artist];
        
        [self addSubview:self.appNameLabel];
        [self addSubview:self.thumbnailImageView];
        [self addSubview:self.appArtistLabel];
    }
    return self;
}

- (void)configureCellWithAppEntry:(AppEntry *)appEntry {
    self.appNameLabel.text = appEntry.name;
    self.appArtistLabel.text = [NSString stringWithFormat:@"By %@", appEntry.artist];
}


#pragma mark - Favorite App Cell Configuration

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier favoriteApp:(FavoriteApp *)favoriteApp
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self buildAppNameLabel:favoriteApp.name];
        [self buildThumbnailImageView];
        [self buildAppArtistLabel:favoriteApp.artist];
        
        [self addSubview:self.appNameLabel];
        [self addSubview:self.thumbnailImageView];
        [self addSubview:self.appArtistLabel];
    }
    return self;
}


- (void)configureCellWithFavoriteApp:(FavoriteApp *)favoriteApp {
    self.appNameLabel.text = favoriteApp.name;
    self.appArtistLabel.text = [NSString stringWithFormat:@"By %@", favoriteApp.artist];
}



#pragma mark - Cell Construction

-(void)buildAppNameLabel: (NSString *)appName
{
    self.appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPACE_BETWEEN, NAME_Y_COORDINATE, TITLE_LABEL_WIDTH, NAME_LABEL_HEIGHT)];
    self.appNameLabel.text = appName;
    self.appNameLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:18];
    self.appNameLabel.numberOfLines = 2;
    [self.appNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
}

-(void)buildAppArtistLabel: (NSString *)artist
{
    CGFloat labelWidth = self.frame.size.width - 20;
    
    self.appArtistLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPACE_BETWEEN, ARTIST_Y_COORDINATE, labelWidth, ARTIST_LABEL_HEIGHT)];
    self.appArtistLabel.font = [UIFont fontWithName:@"Palatino" size:13];
    self.appArtistLabel.numberOfLines = 1;
    self.appArtistLabel.text = [NSString stringWithFormat:@"By %@", artist];
}

-(void)buildThumbnailImageView
{
    CGFloat imageX = self.frame.size.width - (THUMBNAIL_LENGTH + SPACE_BETWEEN);
    
    self.thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, THUMBNAIL_Y_COORDINATE, THUMBNAIL_LENGTH, THUMBNAIL_LENGTH)];
}


@end

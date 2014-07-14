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
static NSInteger const THUMBNAIL_LENGTH = 53;
static NSInteger const ARTIST_LABEL_HEIGHT = 15;
static NSInteger const ARTIST_Y_COORDINATE = 65;

@interface ELAppCell()

@property(nonatomic, strong) UILabel *appNameLabel;
@property(nonatomic, strong) UILabel *appArtistLabel;
@property(nonatomic, strong) UIImageView *thumbnailImageView;

@end

@implementation ELAppCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier appEntry:(AppEntry *)appEntry
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
        
        self.appNameLabel = [[UILabel alloc] init];
        self.thumbnailImageView = [[UIImageView alloc] init];
        
        self.appNameLabel = [self buildAppNameLabel:appEntry.name];
        self.thumbnailImageView = [self buildThumbnailImageView:appEntry.smallPictureURl];
        self.appArtistLabel = [self buildAppArtistLabel:appEntry.artist];
        
        [self.contentView addSubview:self.appNameLabel];
        [self.contentView addSubview:self.thumbnailImageView];
        [self.contentView addSubview:self.appArtistLabel];
    }
    return self;
}

- (void)configureCellWithAppEntry:(AppEntry *)appEntry{
    
    
    dispatch_queue_t fetchQ = dispatch_queue_create("ConfigureCell", NULL);
    dispatch_async(fetchQ, ^{
        
    
    
        NSURL *address = [NSURL URLWithString:appEntry.smallPictureURl];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:address]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //NSLog(@"Configuring cell: %@",appEntry.name);
            self.appNameLabel.text = appEntry.name;
            self.thumbnailImageView.image = image;
            self.appArtistLabel.text = [NSString stringWithFormat:@"By %@", appEntry.artist];
            
        });
    });
}



-(UILabel *)buildAppNameLabel: (NSString *)appName
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPACE_BETWEEN, SPACE_BETWEEN, TITLE_LABEL_WIDTH, 0)];
    nameLabel.text = appName;
    nameLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:18];
    nameLabel.numberOfLines = 2;
    [nameLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [nameLabel sizeToFit];
    
    return nameLabel;
}

-(UILabel *)buildAppArtistLabel: (NSString *)artist
{
    CGFloat labelWidth = self.frame.size.width - 20;
    
    UILabel *artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPACE_BETWEEN, ARTIST_Y_COORDINATE, labelWidth, ARTIST_LABEL_HEIGHT)];
    artistLabel.font = [UIFont fontWithName:@"Palatino" size:13];
    artistLabel.numberOfLines = 1;
    artistLabel.text = [NSString stringWithFormat:@"By %@", artist];
    
    
    return artistLabel;
}

-(UIImageView *)buildThumbnailImageView: (NSString *)imageUrl
{
    CGFloat imageX = self.frame.size.width - (THUMBNAIL_LENGTH + SPACE_BETWEEN);
    
    UIImageView *thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, SPACE_BETWEEN, THUMBNAIL_LENGTH, THUMBNAIL_LENGTH)];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("FetchImage", NULL);
    
    dispatch_async(fetchQ, ^{
        
        NSURL *address = [NSURL URLWithString:imageUrl];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:address]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            thumbnailImageView.image = image;
        });
    });
    
    return thumbnailImageView;
}





- (void)awakeFromNib
{
//    self.appName.text = @"waiting waiting";
//    NSLog(@"Cell cell");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  ELSingleAppViewController.m
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/11/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "ELSingleAppViewController.h"

static NSInteger const SPACE_BETWEEN = 15;
static NSInteger const X_COORDINATE = 10;
static NSInteger const WIDTH = 300;
static NSInteger const PICTURE_SIDE = 100;
static NSInteger const SECOND_COL_X = 140;
static NSInteger const SECOND_COL_WIDTH = 170;

@interface ELSingleAppViewController ()

@property(nonatomic, strong) AppEntry *appEntry;

@property(nonatomic, strong) UILabel *appArtistLabel;
@property(nonatomic, strong) UILabel *appNameLabel;
@property(nonatomic, strong) UILabel *appSummaryLabel;
@property(nonatomic, strong) UILabel *appPriceLabel;
@property(nonatomic, strong) UIImageView *appImageView;
@property(nonatomic, strong) UIBarButtonItem *shareButton;
@property(nonatomic, strong) UIActivityViewController *activityVC;


@end

@implementation ELSingleAppViewController



- (ELSingleAppViewController *)initWithAppEntry:(AppEntry *)appEntry {
    self = [super init];
    if (self) {
        self.appEntry = appEntry;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor: [UIColor whiteColor]];
    
    
    [self buildAppEntryView];
    [self buildShareButtonFunctionality];
}



-(void) buildAppEntryView
{
    self.appEntryView = [[UIScrollView alloc] initWithFrame:[self.view frame]];
    [self.appEntryView setScrollEnabled:YES];
    
    self.appNameLabel = [self buildAppNameLabel:self.appEntry.name atYCoordinate:SPACE_BETWEEN];
    
    CGFloat yImageCoordinate = 2*SPACE_BETWEEN + self.appNameLabel.frame.size.height;
    self.appImageView = [self buildImageView:self.appEntry.largePictureURL atYCoordinate:yImageCoordinate];
    
    //Summary Label
    CGFloat ySummaryCoordinate = 3*SPACE_BETWEEN +self.appNameLabel.frame.size.height + self.appImageView.frame.size.height;
    self.appSummaryLabel = [self buildSummaryLabel:self.appEntry.summary atYCoordinate:ySummaryCoordinate];
    
    //Calculating height size of view
    CGFloat viewHeight = 4*SPACE_BETWEEN + self.appNameLabel.frame.size.height + self.appImageView.frame.size.height + self.appSummaryLabel.frame.size.height;
    [self.appEntryView setContentSize:CGSizeMake(320, viewHeight)];

    //App artist
    CGFloat yArtistCoordinate = 2*SPACE_BETWEEN +5 + self.appNameLabel.frame.size.height;
    self.appArtistLabel = [self buildAppArtistLabel:self.appEntry.artist atYCoordinate:yArtistCoordinate];
    
    //App price
    CGFloat yPriceCoordinate = 3*SPACE_BETWEEN + self.appNameLabel.frame.size.height + self.appArtistLabel.frame.size.height;
    self.appPriceLabel = [self buildAppPriceLabel:self.appEntry.price atYCoordinate:yPriceCoordinate];
    
    
    
    [self.appEntryView addSubview:self.appNameLabel];
    [self.appEntryView addSubview:self.appImageView];
    [self.appEntryView addSubview:self.appSummaryLabel];
    [self.appEntryView addSubview:self.appArtistLabel];
    [self.appEntryView addSubview:self.appPriceLabel];
    [self.view addSubview:self.appEntryView];
    
}


#pragma mark - Layer by layer

-(UILabel *)buildAppNameLabel: (NSString *)appName atYCoordinate: (CGFloat)yCoordinate
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_COORDINATE, yCoordinate, WIDTH, 0)];
    nameLabel.text = appName;
    nameLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:28];
    nameLabel.numberOfLines = 0;
    [nameLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [nameLabel sizeToFit];
    
    return nameLabel;
}


-(UIImageView *)buildImageView: (NSString *)imageURL atYCoordinate: (CGFloat)yCoordinate
{
    
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(X_COORDINATE+10, yCoordinate, PICTURE_SIDE, PICTURE_SIDE)];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("FetchPicture", NULL);
    dispatch_async(fetchQ, ^{
        
        NSURL *address = [NSURL URLWithString:imageURL];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:address]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
        });
    });
    
    
    return imageView;
}

-(UILabel *)buildSummaryLabel: (NSString *)summary atYCoordinate: (CGFloat)yCoordinate
{
    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_COORDINATE, yCoordinate, WIDTH, 0)];
    summaryLabel.text = summary;
    summaryLabel.font = [UIFont fontWithName:@"Palatino" size:15];
    summaryLabel.numberOfLines = 0;
    [summaryLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [summaryLabel sizeToFit];
    
    return summaryLabel;
}

-(UILabel *)buildAppArtistLabel: (NSString *)appArtist atYCoordinate: (CGFloat)yCoordinate
{
    UILabel *artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(SECOND_COL_X, yCoordinate, SECOND_COL_WIDTH, 0)];
    artistLabel.text = [NSString stringWithFormat:@"By %@", appArtist];
    artistLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
    artistLabel.numberOfLines = 0;
    //[artistLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [artistLabel sizeToFit];
    
    return artistLabel;
}


-(UILabel *)buildAppPriceLabel: (NSString *)appPrice atYCoordinate: (CGFloat)yCoordinate
{
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SECOND_COL_X, yCoordinate, SECOND_COL_WIDTH, 0)];
    priceLabel.text = [NSString stringWithFormat:@"Price: %@",appPrice];
    priceLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:15];
    priceLabel.numberOfLines = 1;
    //[priceLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [priceLabel sizeToFit];
    
    return priceLabel;
}


#pragma mark - Share Button Functionatlity


- (void)buildShareButtonFunctionality
{
    self.shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareLink)];
    self.navigationItem.rightBarButtonItem = self.shareButton;
    
    
    NSString *textWithLink = @"Check out this cool new app!!";
    NSURL *appLink = [NSURL URLWithString:@"http://www.ruckt.com/"];
    
    NSArray *linkToShare = @[textWithLink, appLink];
    
    
    self.activityVC = [[UIActivityViewController alloc] initWithActivityItems:linkToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList];
    
    self.activityVC.excludedActivityTypes = excludeActivities;
    
}

- (void)shareLink
{
    [self presentViewController:self.activityVC animated:YES completion:nil];
}



@end

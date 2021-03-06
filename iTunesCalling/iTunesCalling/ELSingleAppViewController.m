//
//  ELSingleAppViewController.m
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/11/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "ELSingleAppViewController.h"
#import "ELDataStore.h"

static NSInteger const SPACE_BETWEEN = 15;
static NSInteger const X_COORDINATE = 10;
static NSInteger const WIDTH = 300;
static NSInteger const PICTURE_SIDE = 100;
static NSInteger const SECOND_COL_X = 140;
static NSInteger const SECOND_COL_WIDTH = 170;

@interface ELSingleAppViewController ()

@property(nonatomic, strong) AppEntry *appEntry;
@property(nonatomic, strong) FavoriteApp *favoriteApp;
@property(nonatomic, strong) ELDataStore *dataStore;

@property(nonatomic, strong) NSString *artist;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *summary;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) NSString *imageURL;
@property(nonatomic, strong) NSString *shareURL;
@property(nonatomic, strong) NSNumber *idNumber;

@property(nonatomic, strong) UILabel *appArtistLabel;
@property(nonatomic, strong) UILabel *appNameLabel;
@property(nonatomic, strong) UILabel *appSummaryLabel;
@property(nonatomic, strong) UILabel *appPriceLabel;
@property(nonatomic, strong) UIButton *addFavoritesButton;
@property(nonatomic, strong) UIImageView *appImageView;
@property(nonatomic, strong) UIBarButtonItem *shareButton;

@property BOOL aFavorite;

@end

@implementation ELSingleAppViewController



- (ELSingleAppViewController *)initWithAppEntry:(AppEntry *)appEntry
{
    self = [super init];
    if (self) {
        self.appEntry = appEntry;
        self.dataStore = [ELDataStore sharedELDataStore];
        self.artist = appEntry.artist;
        self.name = appEntry.name;
        self.summary = appEntry.summary;
        self.price = appEntry.price;
        self.imageURL = appEntry.largePictureURL;
        self.shareURL = appEntry.shareLink;
        self.idNumber = appEntry.idNumber;
        self.aFavorite = [self.dataStore previouslyFavorited:self.idNumber];
    }
    return self;
}

- (ELSingleAppViewController *)initWithFavoriteApp:(FavoriteApp *)favoriteApp
{
    self = [super init];
    if (self) {
        self.favoriteApp = favoriteApp;
        self.dataStore = [ELDataStore sharedELDataStore];
        self.artist = favoriteApp.artist;
        self.name = favoriteApp.name;
        self.summary = favoriteApp.summary;
        self.price = favoriteApp.price;
        self.imageURL = favoriteApp.largePictureURL;
        self.shareURL = favoriteApp.shareLink;
        self.idNumber = favoriteApp.idNumber;
        self.aFavorite = YES;
        
        self.appEntry = [[AppEntry alloc] initWithName:self.name
                                              idNumber:self.idNumber
                                                artist:self.artist
                                               summary:self.summary
                                                 price:self.price
                                              sharLink:self.shareURL
                                       largePictureURL:self.imageURL
                                    andSmallPictureURL:favoriteApp.smallPictureURL];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor: [UIColor whiteColor]];
    [self buildAppEntryView];
    [self buildShareButton];
}


-(void) buildAppEntryView
{
    self.appEntryView = [[UIScrollView alloc] initWithFrame:[self.view frame]];
    [self.appEntryView setScrollEnabled:YES];
    
    self.appNameLabel = [self buildAppNameLabel:self.name atYCoordinate:SPACE_BETWEEN];
    
    CGFloat yImageCoordinate = 2*SPACE_BETWEEN + self.appNameLabel.frame.size.height;
    self.appImageView = [self buildImageView:self.imageURL atYCoordinate:yImageCoordinate];
    
    CGFloat yButtonCoordinate = 3*SPACE_BETWEEN +self.appNameLabel.frame.size.height + self.appImageView.frame.size.height;
    self.addFavoritesButton = [self buildFavoritesButtonAtYCoordinate:yButtonCoordinate];

    //Summary Label
    CGFloat ySummaryCoordinate = 4*SPACE_BETWEEN + self.appNameLabel.frame.size.height + self.appImageView.frame.size.height + self.addFavoritesButton.frame.size.height;
    self.appSummaryLabel = [self buildSummaryLabel:self.summary atYCoordinate:ySummaryCoordinate];
    
    //Calculating height size of view
    CGFloat viewHeight = 4*SPACE_BETWEEN + self.appNameLabel.frame.size.height + self.appImageView.frame.size.height + self.appSummaryLabel.frame.size.height;
    [self.appEntryView setContentSize:CGSizeMake(320, viewHeight)];

    //App artist
    CGFloat yArtistCoordinate = 2*SPACE_BETWEEN +5 + self.appNameLabel.frame.size.height;
    self.appArtistLabel = [self buildAppArtistLabel:self.artist atYCoordinate:yArtistCoordinate];
    
    //App price
    CGFloat yPriceCoordinate = 3*SPACE_BETWEEN + self.appNameLabel.frame.size.height + self.appArtistLabel.frame.size.height;
    self.appPriceLabel = [self buildAppPriceLabel:self.price atYCoordinate:yPriceCoordinate];
    
    
    [self.appEntryView addSubview:self.appNameLabel];
    [self.appEntryView addSubview:self.appImageView];
    [self.appEntryView addSubview:self.addFavoritesButton];
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

-(UIButton *)buildFavoritesButtonAtYCoordinate: (CGFloat)yCoordinate
{
    UIButton *favoriteButton = [[UIButton alloc] initWithFrame:CGRectMake(X_COORDINATE, yCoordinate, 150, 30)];
    [favoriteButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];

    if (self.aFavorite) {
        [favoriteButton setTitle:@"Unfavor App" forState:UIControlStateNormal];
        favoriteButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:1];;
    } else {
        [favoriteButton setTitle:@"Favor This App!" forState:UIControlStateNormal];
        favoriteButton.backgroundColor = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1 ];
    }
    
    [favoriteButton addTarget:self action:@selector(favorThis) forControlEvents:UIControlEventTouchUpInside];
    
    return favoriteButton;
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

#pragma mark - Favorite Button

-(void)favorThis
{
    if ([self.dataStore previouslyFavorited:self.idNumber]) {
    
        [self.dataStore unFavorApp:self.idNumber];
        [self.dataStore saveContext];
        
        [self.addFavoritesButton setTitle:@"Favor This App!" forState:UIControlStateNormal];
        self.addFavoritesButton.backgroundColor = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1 ];
        

    }
    else
    {
        FavoriteApp *favoriteApp = [FavoriteApp appEntryName:self.appEntry.name
                                                    idNumber:self.appEntry.idNumber
                                                      artist:self.appEntry.artist
                                                     summary:self.appEntry.summary
                                                       price:self.appEntry.price
                                                    sharLink:self.appEntry.shareLink
                                             largePictureURL:self.appEntry.largePictureURL
                                          andSmallPictureURL:self.appEntry.smallPictureURL
                                      inManagedObjectContext:self.dataStore.managedObjectContext];
    
        [self.dataStore.favoriteAppArray addObject:favoriteApp];
        [self.dataStore saveContext];
        NSLog(@"Favorite Apps: %@", self.dataStore.favoriteAppArray);
        [self.addFavoritesButton setTitle:@"Unfavor App" forState:UIControlStateNormal];
        self.addFavoritesButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:1];
    }
    
    [self postNotification];
}


- (void)postNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnFavored" object:nil];
}



#pragma mark - Share Button Functionatlity


- (void)buildShareButton
{
    self.shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareLinkFunctionality)];
    self.navigationItem.rightBarButtonItem = self.shareButton;

}


- (void)shareLinkFunctionality
{
    NSString *textWithLink = @"Check out this cool new app!!";
    NSURL *appLink = [NSURL URLWithString:self.shareURL];
    
    NSArray *activityItems = [NSArray arrayWithObjects:textWithLink, appLink,nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList];
    

    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = excludeActivities;
    
    
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:activityViewController animated:YES completion:nil];
}



@end

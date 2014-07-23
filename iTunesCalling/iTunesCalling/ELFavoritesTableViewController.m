//
//  ELFavoritesTableViewController.m
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/20/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "ELFavoritesTableViewController.h"
#import "ELDataStore.h"
#import "ELAppCell.h"
#import "ELSingleAppViewController.h"
#import "FavoriteApp+Methods.h"
#import "AppEntry.h"

static NSString *CellIdentifier = @"favCell";
static NSInteger const CELL_HEIGHT = 85;

@interface ELFavoritesTableViewController ()

@property (strong, nonatomic) ELDataStore *dataStore;
@property (strong, nonatomic) NSArray *favoriteApps;

@end

@implementation ELFavoritesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEvent:) name:@"UnFavored" object:nil];

    self.dataStore = [ELDataStore sharedELDataStore];
    self.favoriteApps = [self.dataStore fetchFavorites];
    
    self.favoritesTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.favoritesTableView.delegate = self;
    self.favoritesTableView.dataSource = self;
    
    [self.view addSubview:self.favoritesTableView];

    [self setTitle:@"My Favorites"];

}

- (void)receiveEvent:(NSNotification *)notification {
    NSLog(@"Received unFavor notification");
    self.favoriteApps = [self.dataStore fetchFavorites];
    [self.favoritesTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.favoriteApps count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELAppCell *favoriteCell = (ELAppCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    FavoriteApp *favoriteApp = [self.favoriteApps objectAtIndex:indexPath.row];
    
    if (favoriteCell==nil) {
        favoriteCell = [[ELAppCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier favoriteApp:favoriteApp];
    }
    
    [favoriteCell configureCellWithFavoriteApp:favoriteApp];
    favoriteCell.thumbnailImageView.image = nil;
    
    dispatch_queue_t fetchQ = dispatch_queue_create("ConfigureCell", NULL);
    dispatch_async(fetchQ, ^{
        
        NSURL *address = [NSURL URLWithString:favoriteApp.smallPictureURL];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:address]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ELAppCell *updateCell = (ELAppCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (updateCell) { // if nil then cell is not visible hence no need to update
                updateCell.thumbnailImageView.image = image;
            }
        });
    });


    return favoriteCell;
}



 #pragma mark - Navigation


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteApp *selectedFavorite = [self.favoriteApps objectAtIndex:indexPath.row];
    
    ELSingleAppViewController *singleAppViewController = [[ELSingleAppViewController alloc] initWithFavoriteApp:selectedFavorite];
    [self.navigationController pushViewController:singleAppViewController animated:YES];
}


@end

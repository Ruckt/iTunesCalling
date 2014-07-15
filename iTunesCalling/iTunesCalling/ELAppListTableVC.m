//
//  ELAppListTableVC.m
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/6/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "ELAppListTableVC.h"
#import "ELDataStore.h"
#import "ELSingleAppViewController.h"
#import "AppEntry+Methods.h"

static NSString *CellIdentifier = @"appCell";
static NSInteger const CELL_HEIGHT = 85;

@interface ELAppListTableVC ()

@property (strong, nonatomic) ELDataStore *dataStore;
@property (strong, nonatomic) AppEntry *appEntryPlaceHolder;
@property (strong, nonatomic) NSArray *appEntries;
@property BOOL FetchComplete;

@end

@implementation ELAppListTableVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    
        [self setTitle:@"Happy iTunes"];
        self.dataStore = [ELDataStore sharedELDataStore];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEvent:) name:@"FetchComplete" object:nil];
        self.FetchComplete = NO;
        
        [self createAppEntryPlaceHolder];
        self.appEntries = [self buildDataArray];
        NSLog(@"self appEntres %@", self.appEntries);
        
        self.appListTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        self.appListTableView.delegate = self;
        self.appListTableView.dataSource = self;
        
 
        
        //    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
        
        [self.view addSubview:self.appListTableView];
        
    }
    return self;
}

#pragma mark - NSNotification Center

- (void)receiveEvent:(NSNotification *)notification {
    NSLog(@"Received iTunes Data Data Data");
    self.FetchComplete = YES;
    self.appEntries = [self buildDataArray];
    [self.appListTableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.appEntries count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELAppCell *elAppCell = (ELAppCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    AppEntry *appEntry = [self.appEntries objectAtIndex:indexPath.row];

    if (!elAppCell) {
        elAppCell = [[ELAppCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier appEntry:appEntry];
    }
    else {
        [elAppCell configureCellWithAppEntry:appEntry];
    }
    return elAppCell;
}

#pragma mark - Data Array

- (NSArray *)buildDataArray
{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];

    if (self.FetchComplete){
        
        dataArray = [self.dataStore appEntryArray];
        [dataArray addObject:self.appEntryPlaceHolder];
    }else {
        NSLog(@"jack jason");
        for (NSInteger i=0; i<26; i++) {
            [dataArray addObject:self.appEntryPlaceHolder];
            NSLog(@"jack jck %@", self.appEntryPlaceHolder);
        }
    }
    
    return dataArray;
}

- (void)createAppEntryPlaceHolder
{
    self.appEntryPlaceHolder = [AppEntry appEntryName:@"Letter Sort Ultimate Winning Challenge"
                                             idNumber:@44
                                               artist:@"Curly Day"
                                              summary:@"Letter Sort is an anagram maker. It generates every possible word when you input a set of letters. It can be used to help you think of what words your name can create or aid you in any word game."
                                                price:@"$1,000,000"
                                             sharLink:@"https://itunes.apple.com/us/app/letter-sort/id875653244?mt=8"
                                      largePictureURL:@"http://a4.mzstatic.com/us/r30/Purple4/v4/e4/35/4e/e4354ef0-4208-8cb0-ea7b-a69e76c2d4c7/mzl.xrwodswy.100x100-75.jpg"
                                   andSmallPictureURL:@"http://a4.mzstatic.com/us/r30/Purple4/v4/e4/35/4e/e4354ef0-4208-8cb0-ea7b-a69e76c2d4c7/mzl.xrwodswy.53x53-50.jpg"
                               inManagedObjectContext:self.dataStore.managedObjectContext];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppEntry *appEntry;
    
    if (indexPath.row<25) {
        appEntry = [self.appEntries objectAtIndex:indexPath.row];
    }
    else {
        appEntry = self.appEntryPlaceHolder;
    }
    
    
    ELSingleAppViewController *singleAppViewController = [[ELSingleAppViewController alloc] initWithAppEntry:appEntry];
    [self.navigationController pushViewController:singleAppViewController animated:YES];
}


@end

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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.dataStore = [ELDataStore sharedELDataStore];
        [self setTitle:@"My Favorites"];
 
        self.favoritesTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.favoritesTableView.delegate = self;
        self.favoritesTableView.dataSource = self;
        
       // NSLog(@"Favorite Apps: %@", self.dataStore.favoriteAppArray);
        self.favoriteApps = self.dataStore.favoriteAppArray;
        
        [self.view addSubview:self.favoritesTableView];
        
        NSLog(@"Fav List count %lu", (unsigned long)[self.favoriteApps count]);

        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataStore.fetchedFavoriteResultsController.sections[section] numberOfObjects];
    //return [self.dataStore.favoriteAppArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ELAppCell *elAppCell = (ELAppCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    AppEntry *appEntry = [self.dataStore.appEntryArray objectAtIndex:indexPath.row];
    
    if (!elAppCell) {
        elAppCell = [[ELAppCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier appEntry:appEntry];
    }
    
    [elAppCell configureCellWithAppEntry:appEntry];
    
    return elAppCell;
    
    
//    static NSString *CellIdentifier = @"ELCell";
//    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    List *myList = [self.dataStore getListAtIndex:indexPath.row];
//    myCell.textLabel.text = myList.name;

}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FavoriteApp *favoriteApp = [self.dataStore.fetchedFavoriteResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = favoriteApp.name;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - NSFetchedResultsControllerDelegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}



@end

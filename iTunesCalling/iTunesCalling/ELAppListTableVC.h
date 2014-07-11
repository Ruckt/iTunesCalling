//
//  ELAppListTableVC.h
//  iTunesCalling
//
//  Created by Edan Lichtenstein on 7/6/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELAppCell.h"


@interface ELAppListTableVC : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property UITableView *appListTableView;

@end

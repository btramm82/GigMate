//
//  GigSetTableViewController.h
//  GigMate
//
//  Created by BRIAN TRAMMELL on 5/11/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SetListTableViewController.h"
#import "Song.h"
#import "SetList.h"

@interface GigSetTableViewController : UITableViewController

@property (nonatomic, strong) SetList *setList;

@end

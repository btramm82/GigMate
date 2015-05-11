//
//  SetListTableViewController.h
//  Gig Mate
//
//  Created by BRIAN TRAMMELL on 4/27/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SetList.h"
#import "Song.h"
#import "AddSetViewController.h"
#import "GigSetTableViewController.h"

@interface SetListTableViewController : UITableViewController <UITabBarControllerDelegate>

@property (nonatomic, strong) SetList *setList;





@end

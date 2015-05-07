//
//  AddSongsToSetViewController.h
//  GigMate
//
//  Created by BRIAN TRAMMELL on 5/4/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Song.h"
#import "SetList.h"
#import "AddSetViewController.h"
#import "SongsViewController.h"



@interface AddSongsToSetViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)saveSongsToSet:(id)sender;


- (IBAction)segmentedControll:(id)sender;

@end

//
//  AddSetViewController.h
//  Gig Mate
//
//  Created by BRIAN TRAMMELL on 4/27/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SetList.h"
#import "SetListTableViewController.h"
#import "Song.h"

@interface AddSetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SetList *setList;
@property (nonatomic, strong) NSMutableArray* songs;
@property (nonatomic, strong) NSMutableArray *songsInSet;
@property (weak, nonatomic) IBOutlet UITextField *setName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)addSongToSet:(id)sender;

- (IBAction)saveSet:(id)sender;

@end

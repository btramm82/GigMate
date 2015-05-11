//
//  AddSongViewController.h
//  Gig Mate
//
//  Created by BRIAN TRAMMELL on 4/27/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Song.h"
#import "SetList.h"

@interface AddSongViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Song *song;
@property (weak, nonatomic) IBOutlet UITextField *songName;
@property (weak, nonatomic) IBOutlet UITextField *artistName;
@property (weak, nonatomic) IBOutlet UITextField *bpm;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (IBAction)saveSong:(id)sender;

@end

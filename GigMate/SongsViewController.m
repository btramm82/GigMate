//
//  SongsViewController.m
//  Gig Mate
//
//  Created by BRIAN TRAMMELL on 4/27/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import "SongsViewController.h"

@interface SongsViewController ()
@property (nonatomic, strong) NSMutableArray *songs;
@property (nonatomic) NSInteger selectedSegmentedIndex;
@property (nonatomic, strong) NSMutableArray *alphabetArray;

@end

@implementation SongsViewController
@synthesize segmentedControl;



#pragma mark - Core Data
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Fetch the places from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Song"];
    self.songs = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSArray *sortedArray;
        if (segmentedControl.selectedSegmentIndex == 0) {
            NSSortDescriptor *songNameSort = [NSSortDescriptor sortDescriptorWithKey:@"songName" ascending:YES];
            sortedArray = [self.songs sortedArrayUsingDescriptors:@[songNameSort]];
        } if (segmentedControl.selectedSegmentIndex == 1) {
            NSSortDescriptor *artistNameSort = [NSSortDescriptor sortDescriptorWithKey:@"artistName" ascending:YES];
            sortedArray = [self.songs sortedArrayUsingDescriptors:@[artistNameSort]];
        }
        self.songs = [sortedArray mutableCopy];
        [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"songCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSManagedObject *songs = [self.songs objectAtIndex:indexPath.row];
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[songs valueForKey:@"songName"]]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ - %@ bpm",[songs valueForKey:@"artistName"], [songs valueForKey:@"bpm"]]];
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[songs valueForKey:@"artistName"]]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ - %@ bpm",[songs valueForKey:@"songName"], [songs valueForKey:@"bpm"]]];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObjectContext *context = [self managedObjectContext];
    [self.tableView reloadData];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [context deleteObject:[self.songs objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
       
        [self.songs removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Table View Sorting Method
- (IBAction)segmentedControll:(id)sender {
    self.selectedSegmentedIndex = segmentedControl.selectedSegmentIndex;
    NSArray *sortedArray;
    if (segmentedControl.selectedSegmentIndex == 0) {
        NSSortDescriptor *songNameSort = [NSSortDescriptor sortDescriptorWithKey:@"songName" ascending:YES];
        sortedArray = [self.songs sortedArrayUsingDescriptors:@[songNameSort]];
    } if (segmentedControl.selectedSegmentIndex == 1) {
        NSSortDescriptor *artistNameSort = [NSSortDescriptor sortDescriptorWithKey:@"artistName" ascending:YES];
        sortedArray = [self.songs sortedArrayUsingDescriptors:@[artistNameSort]];
    }
    self.songs = [sortedArray mutableCopy];
     [self.tableView reloadData];
}

#pragma mark - Navigation
-(IBAction)prepareForSongUnwind:(UIStoryboardSegue *)segue {
}

@end

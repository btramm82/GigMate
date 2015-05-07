//
//  AddSongsToSetViewController.m
//  GigMate
//
//  Created by BRIAN TRAMMELL on 5/4/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import "AddSongsToSetViewController.h"

@interface AddSongsToSetViewController ()

@property (nonatomic, strong) NSMutableArray *songs;
@property (nonatomic) NSInteger selectedSegmentedIndex;
@property (nonatomic, strong) NSMutableArray *alphabetArray;
@property (nonatomic, strong) NSMutableArray *selectedSongsFromSongList;

@end

@implementation AddSongsToSetViewController
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
    self.tableView.allowsMultipleSelection = YES;
    self.selectedSongsFromSongList = [NSMutableArray array];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"addSongToSetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSManagedObject *song = [self.songs objectAtIndex:indexPath.row];
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[song valueForKey:@"songName"]]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ - %@ bpm",[song valueForKey:@"artistName"], [song valueForKey:@"bpm"]]];
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[song valueForKey:@"artistName"]]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ - %@ bpm",[song valueForKey:@"songName"], [song valueForKey:@"bpm"]]];
    }
    if ([self.selectedSongsFromSongList containsObject:(song)]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *song = [self.songs objectAtIndex:indexPath.row];
    if ([self.selectedSongsFromSongList containsObject:(song)]) {
        [self.selectedSongsFromSongList removeObject:song];
    } else {
        [self.selectedSongsFromSongList addObject:song];
    }
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
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

- (IBAction)saveSongsToSet:(id)sender {
}

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"unwindSongSet"]) {
    AddSetViewController *destViewController = segue.destinationViewController;
    destViewController.songs = self.selectedSongsFromSongList;
    }
}

@end

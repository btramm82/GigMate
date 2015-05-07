//
//  AddSetViewController.m
//  Gig Mate
//
//  Created by BRIAN TRAMMELL on 4/27/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import "AddSetViewController.h"

@interface AddSetViewController ()
@property (nonatomic, strong) NSMutableArray *selectedSongs;
@property (nonatomic, strong) NSMutableArray *setLists;
@property (nonatomic, strong) NSSet *savedSongsToPass;
@end

@implementation AddSetViewController

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
    if (self.setList) {
        [self.setName setText:[self.setList valueForKey:@"setName"]];
    } else if (self.songs) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SetList"];
        self.setLists = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        self.selectedSongs = self.songs;
        [self.tableView reloadData];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.setList) {
        NSMutableArray *songs = [self.setList valueForKey:@"songs"];
        return [songs count];
    } else {
        return [self.selectedSongs count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"songSetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.setList) {
        NSMutableArray *songsList = [NSMutableArray arrayWithArray:[[self.setList.songs allObjects] mutableCopy]];
        NSMutableArray *songs = [songsList objectAtIndex:indexPath.row];
        NSLog(@"%@, %@, %@", [songs valueForKey:@"songName" ], [songs valueForKey:@"artistName"], [songs valueForKey:@"bpm"]);
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[songs valueForKey:@"songName"]]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ - %@ bpm",[songs valueForKey:@"artistName"], [songs valueForKey:@"bpm"]]];
    } else {
        NSManagedObject *songs = [self.selectedSongs objectAtIndex:indexPath.row];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[songs valueForKey:@"songName"]]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ - %@ bpm",[songs valueForKey:@"artistName"], [songs valueForKey:@"bpm"]]];
    }
    return cell;
}

- (IBAction)addSongToSet:(id)sender {
}

- (IBAction)saveSet:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    if (self.setList) {
        [self.setList setValue:self.setName.text forKey:@"setName"];
        [self.setList setValue:[NSSet setWithArray:self.selectedSongs] forKey:@"songs"];
    } else {
        SetList *newSet = (SetList *)[NSEntityDescription insertNewObjectForEntityForName:@"SetList" inManagedObjectContext:context];
        [newSet setValue:self.setName.text forKey:@"setName"];
        [newSet setValue:[NSSet setWithArray:self.selectedSongs] forKey:@"songs"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        } else {
            NSLog(@"Save Was Successful");
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"unwindToSetTableViewController"]) {
    [self saveSet:nil];
    }
}

-(IBAction)prepareForSongSetUnwind:(UIStoryboardSegue *)segue {
}
@end






























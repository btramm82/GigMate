//
//  AddSetViewController.m
//  Gig Mate
//
//  Created by BRIAN TRAMMELL on 4/27/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import "AddSetViewController.h"

@interface AddSetViewController ()
@property (nonatomic, strong) NSArray *songs;

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
    if (self.setLists) {
        [self.setName setText:[self.setLists valueForKey:@"setName"]];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Fetch the places from persistent data store
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"songCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSManagedObject *songs = [self.songs objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",[songs valueForKey:@"songName"]]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ - %@ bpm",[songs valueForKey:@"artistName"], [songs valueForKey:@"bpm"]]];
    return cell;
}

- (IBAction)addSongToSet:(id)sender {
}

- (IBAction)saveSet:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    if (self.setLists) {
        [self.setLists setValue:self.setName.text forKey:@"setName"];
    } else {
        NSManagedObject *newSet = [NSEntityDescription insertNewObjectForEntityForName:@"SetList" inManagedObjectContext:context];
        [newSet setValue:self.setName.text forKey:@"setName"];

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
    if ([[segue identifier] isEqualToString:@"unwindToSetTableViewController"])
        [self saveSet:nil];
}
@end






























//
//  SetListTableViewController.m
//  Gig Mate
//
//  Created by BRIAN TRAMMELL on 4/27/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import "SetListTableViewController.h"

@interface SetListTableViewController ()
@property (nonatomic, strong) NSMutableArray *setLists;
@property (nonatomic, strong) NSMutableArray *songsToPassBack;
@property (nonatomic, strong) NSString *setName;
@property (nonatomic, strong) NSMutableArray *songsInSet;
@property (nonatomic, strong) NSMutableArray *setToEdit;

@end

@implementation SetListTableViewController

NSInteger selectedRows;

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
    self.navigationItem.hidesBackButton = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Fetch the places from persistent data store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SetList"];
    NSArray *fetchedSets = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    self.setLists = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (SetList *setList in fetchedSets) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[[setList.songs allObjects] mutableCopy]];
        self.songsInSet = array;
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.setLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *CellIdentifier = @"setsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSManagedObject *sets = [self.setLists objectAtIndex:indexPath.row];
    NSMutableArray *songs = [sets valueForKey:@"songs"];

    UILabel *nameLabel = (UILabel *)[cell viewWithTag:200];
    [nameLabel setText:[NSString stringWithFormat:@"%@", [sets valueForKey:@"setName"]]];
    UILabel *songCountLabel = (UILabel *)[cell viewWithTag:201];
    if ([songs count] < 1) {
        [songCountLabel setText:[NSString stringWithFormat:@"No songs in set"]];
    } else if ([songs count] == 1) {
         [songCountLabel setText:[NSString stringWithFormat:@"%lu song in set", (unsigned long)[songs count]]];
    } else {
        [songCountLabel setText:[NSString stringWithFormat:@"%lu songs in set", (unsigned long)[songs count]]];
    }
    UIButton *editButton = (UIButton *)[cell viewWithTag:202];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    selectedRows = indexPath.row;
    self.setToEdit = [self.setLists objectAtIndex:selectedRows];
    [self performSegueWithIdentifier:@"editSetList" sender:self];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObjectContext *context = [self managedObjectContext];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [context deleteObject:[self.setLists objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        [self.setLists removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"editSetList"]) {
        NSManagedObject *selectedSet = [self.setLists objectAtIndex:selectedRows];
        AddSetViewController *destViewController = segue.destinationViewController;
        destViewController.setList = (SetList *)selectedSet;
    } else if ([[segue identifier] isEqualToString:@"showGigSet"]) {
          NSManagedObject *selectedSet = [self.setLists objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        GigSetTableViewController *destViewController = segue.destinationViewController;
        destViewController.setList = (SetList *)selectedSet;
    }
}

-(IBAction)prepareForSetUnwind:(UIStoryboardSegue *)segue {
}
@end

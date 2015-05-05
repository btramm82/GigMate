//
//  GigsTableViewController.m
//  Gig Mate
//
//  Created by BRIAN TRAMMELL on 4/27/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import "GigsTableViewController.h"

@interface GigsTableViewController ()
@property (nonatomic, strong) NSMutableArray *gigs;

@end

@implementation GigsTableViewController

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
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Gigs"];
    self.gigs = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.gigs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"gigsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSManagedObject *gigs = [self.gigs objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    [nameLabel setText:[NSString stringWithFormat:@"%@",[gigs valueForKey:@"name"]]];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:101];
    [dateLabel setText:[NSString stringWithFormat:@"%@", [gigs valueForKey:@"date"]]];
    UILabel *startTimeLabel = (UILabel *)[cell viewWithTag:102];
    [startTimeLabel setText:[NSString stringWithFormat:@"%@ - %@", [gigs valueForKey:@"startTime"], [gigs valueForKey:@"endTime"]]];
    UIButton *editButton = (UIButton *)[cell viewWithTag:103];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tabBarController.selectedIndex = 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [context deleteObject:[self.gigs objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        [self.gigs removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Navigation
 -(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
 }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"editGig"]) {
        NSManagedObject *selectedGig = [self.gigs objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        AddGigViewController *destViewController = segue.destinationViewController;
        destViewController.gigs = (Gigs *)selectedGig;
    } if ([segue.identifier isEqualToString:@"gigCellClickedOn"])
         [self.tabBarController setSelectedIndex:1];
}

@end

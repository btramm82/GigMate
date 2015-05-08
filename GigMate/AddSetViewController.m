//
//  AddSetViewController.m
//  Gig Mate
//
//  Created by BRIAN TRAMMELL on 4/27/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import "AddSetViewController.h"
#import "AddSongsToSetViewController.h"

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
        if (self.songs) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SetList"];
            self.setLists = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            self.selectedSongs = self.songs;
            [self.tableView reloadData];
        } else {
            [self.setName setText:[self.setList valueForKey:@"setName"]];
            self.songs = [NSMutableArray arrayWithArray:[[self.setList.songs allObjects] mutableCopy]];
        }
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
        if (self.songs) {
             return [self.selectedSongs count];
        } else {
        NSMutableArray *songs = [self.setList valueForKey:@"songs"];
        return [songs count];
        }
    } else {
        return [self.selectedSongs count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"songSetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.setList) {
        if (self.songs) {
            NSManagedObject *songs = [self.selectedSongs objectAtIndex:indexPath.row];
            [cell.textLabel setText:[NSString stringWithFormat:@"%@",[songs valueForKey:@"songName"]]];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ - %@ bpm",[songs valueForKey:@"artistName"], [songs valueForKey:@"bpm"]]];
        } else {
        NSMutableArray *songsList = [NSMutableArray arrayWithArray:[[self.setList.songs allObjects] mutableCopy]];
        NSMutableArray *songs = [songsList objectAtIndex:indexPath.row];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[songs valueForKey:@"songName"]]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ - %@ bpm",[songs valueForKey:@"artistName"], [songs valueForKey:@"bpm"]]];
        }
    } else {
        NSManagedObject *songs = [self.selectedSongs objectAtIndex:indexPath.row];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[songs valueForKey:@"songName"]]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ - %@ bpm",[songs valueForKey:@"artistName"], [songs valueForKey:@"bpm"]]];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.setList) {
        if (self.songs) {
            NSManagedObjectContext *context = [self managedObjectContext];
            if (editingStyle == UITableViewCellEditingStyleDelete) {
                NSError *error = nil;
                if (![context save:&error]) {
                    NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                    return;
                }
                [self.songs removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        } else {
            NSManagedObjectContext *context = [self managedObjectContext];
            NSMutableArray *songsList = [NSMutableArray arrayWithArray:[[self.setList.songs allObjects] mutableCopy]];
            Song *song = [songsList objectAtIndex:indexPath.row];
            [self.setList.songs removeObject:song];
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                return;
            }
            [songsList removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        NSManagedObjectContext *context = [self managedObjectContext];
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                return;
            }
            [self.selectedSongs removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (IBAction)addSongToSet:(id)sender {
}

- (IBAction)saveSet:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    if (self.setList) {
        if (self.songs) {
            [self.setList setValue:self.setName.text forKey:@"setName"];
            [self.setList setValue:[NSSet setWithArray:self.songs] forKey:@"songs"];
        } else {
            [self.setList setValue:self.setName.text forKey:@"setName"];
            [self.setList setValue:[NSSet setWithArray:self.songs] forKey:@"songs"];
        }
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
    if ([[segue identifier] isEqualToString:@"addSongsToSet"]) {
        if (self.selectedSongs) {
            AddSongsToSetViewController *vc = ((UINavigationController *)segue.destinationViewController).viewControllers[0];
            vc.selectedSongsFromSongList = self.selectedSongs;
        } else if (self.setList) {
            AddSongsToSetViewController *vc = ((UINavigationController *)segue.destinationViewController).viewControllers[0];
            vc.selectedSongsFromSongList =  [NSMutableArray arrayWithArray:[[self.setList.songs allObjects] mutableCopy]];
        } else {
            AddSongsToSetViewController *vc = ((UINavigationController *)segue.destinationViewController).viewControllers[0];
            vc.selectedSongsFromSongList =  [NSMutableArray arrayWithArray:[[self.setList.songs allObjects] mutableCopy]];
        }
    }
}

-(IBAction)prepareForSongSetUnwind:(UIStoryboardSegue *)segue {
}
@end






























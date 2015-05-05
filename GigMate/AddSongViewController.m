//
//  AddSongViewController.m
//  Gig Mate
//
//  Created by BRIAN TRAMMELL on 4/27/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import "AddSongViewController.h"

@interface AddSongViewController ()

@end

@implementation AddSongViewController
@synthesize managedObjectContext;
@synthesize fetchedResultsController;

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
    if (self.song) {
        [self.songName setText:[self.song valueForKey:@"songName"]];
        [self.artistName setText:[self.song valueForKey:@"artistName"]];
        [self.bpm setText:[self.song valueForKey:@"bpm"]];
        [self.songNotes setText:[self.song valueForKey:@"notes"]];
    }
}

- (IBAction)saveSong:(id)sender {
    if (self.song) {
        [self.song setValue:self.songName.text forKey:@"songName"];
        [self.song setValue:self.artistName.text forKey:@"artistName"];
        [self.song setValue:self.bpm.text forKey:@"bpm"];
        [self.song setValue:self.songNotes.text forKey:@"notes"];
    } else {

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"songName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];

    NSLog(@"saveSongInformation");
    NSError *error = nil;
    if (self.songName.text !=nil) {
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"songName  contains[cd] %@", self.songName.text];
        [fetchedResultsController.fetchRequest setPredicate:predicate];
    }
        if (![[self fetchedResultsController] performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  // Fail
        }
            if ([fetchedResultsController.fetchedObjects count] < 1) {
                NSLog(@"Found that Artist already in Core Data");
                NSManagedObjectContext *context = [self managedObjectContext];
                NSManagedObject *newSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:context];
                [newSong setValue:self.songName.text forKey:@"songName"];
                [newSong setValue:self.artistName.text forKey:@"artistName"];
                [newSong setValue:self.bpm.text forKey:@"bpm"];
                [newSong setValue:self.songNotes.text forKey:@"notes"];
           
                if (![context save:&error]) {
                NSLog(@"Problem saving: %@", [error localizedDescription]);
                }
            } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Song Already Exists" message:@"Edit Existing Song or Save with New Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Song Name: %@", [info valueForKey:@"songName"]);
        NSLog(@"Artist Name: %@", [info valueForKey:@"artistName"]);
        NSLog(@"Song BPM: %@", [info valueForKey:@"bpm"]);
        }
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"unwindToSongViewController"])
        [self saveSong:nil];
}

@end

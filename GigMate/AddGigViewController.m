//
//  AddGigViewController.m
//  Gig Mate
//
//  Created by BRIAN TRAMMELL on 4/27/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import "AddGigViewController.h"

@interface AddGigViewController ()
@property (nonatomic, strong) NSArray *timePickerData;

@end

@implementation AddGigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _gigDate.delegate = self;
    _gigStartTime.delegate = self;
    _gigEndTime.delegate = self;
    
    if (self.gigs) {
        [self.gigName setText:[self.gigs valueForKey:@"name"]];
        [self.gigDate setText:[self.gigs valueForKey:@"date"]];
        [self.gigStartTime setText:[self.gigs valueForKey:@"startTime"]];
        [self.gigEndTime setText:[self.gigs valueForKey:@"endTime"]];
        [self.gigAddress setText:[self.gigs valueForKey:@"address"]];
        [self.gigCity setText:[self.gigs valueForKey:@"city"]];
        [self.gigState setText:[self.gigs valueForKey:@"state"]];
        [self.gigZip setText:[self.gigs valueForKey:@"zip"]];
        [self.gigContactName setText:[self.gigs valueForKey:@"contactName"]];
        [self.gigNotes setText:[self.gigs valueForKey:@"notes"]];
    }
}
    
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_gigDate) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(updateDate:) forControlEvents:UIControlEventValueChanged];
        [self.gigDate setInputView: datePicker];
    } if (_gigStartTime) {
        UIDatePicker *startTimePicker = [[UIDatePicker alloc] init];
        startTimePicker.datePickerMode = UIDatePickerModeTime;
        self.gigStartTime.inputView = startTimePicker;
        [startTimePicker addTarget:self action:@selector(updateStartTime:) forControlEvents:UIControlEventValueChanged];
    } if (_gigEndTime) {
        UIDatePicker *endTimePicker = [[UIDatePicker alloc] init];
        endTimePicker.datePickerMode = UIDatePickerModeTime;
        self.gigEndTime.inputView = endTimePicker;
        [endTimePicker addTarget:self action:@selector(updateEndTime:) forControlEvents:UIControlEventValueChanged];
    }
}
    
-(void)updateDate:(id)sender {
        UIDatePicker *picker = (UIDatePicker*)self.gigDate.inputView;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd-yy"];
        NSString *date = [dateFormat stringFromDate:picker.date];
    self.gigDate.text = [NSString stringWithFormat:@"%@", date];
}

-(void)updateStartTime:(id)sender {
        UIDatePicker *timePicker = (UIDatePicker*)self.gigStartTime.inputView;
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"h:mm a"];
        NSString *time = [timeFormat stringFromDate:timePicker.date];
        self.gigStartTime.text = [NSString stringWithFormat:@"%@", time];
}

-(void)updateEndTime:(id)sender {
        UIDatePicker *endTimePicker = (UIDatePicker *)self.gigEndTime.inputView;
        NSDateFormatter *endTimeFormat = [[NSDateFormatter alloc] init];
        [endTimeFormat setDateFormat:@"h:mm a"];
        NSString *endTime = [endTimeFormat stringFromDate:endTimePicker.date];
        self.gigEndTime.text = [NSString stringWithFormat:@"%@", endTime];
}

#pragma mark - Core Data

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)saveGig:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.gigs) {
        [self.gigs setValue:self.gigName.text forKey:@"name"];
        [self.gigs setValue:self.gigStartTime.text forKey:@"startTime"];
        [self.gigs setValue:self.gigEndTime.text forKey:@"endTime"];
        [self.gigs setValue:self.gigDate.text forKey:@"date"];
        [self.gigs setValue:self.gigAddress.text forKey:@"address"];
        [self.gigs setValue:self.gigCity.text forKey:@"city"];
        [self.gigs setValue:self.gigState.text forKey:@"state"];
        [self.gigs setValue:self.gigZip.text forKey:@"zip"];
        [self.gigs setValue:self.gigContactName.text forKey:@"contactName"];
        [self.gigs setValue:self.gigNotes.text forKey:@"notes"];
    } else {
        NSManagedObject *newGig = [NSEntityDescription insertNewObjectForEntityForName:@"Gigs" inManagedObjectContext:context];
        [newGig setValue:self.gigName.text forKey:@"name"];
        [newGig setValue:self.gigStartTime.text forKey:@"startTime"];
        [newGig setValue:self.gigEndTime.text forKey:@"endTime"];
        [newGig setValue:self.gigDate.text forKey:@"date"];
        [newGig setValue:self.gigAddress.text forKey:@"address"];
        [newGig setValue:self.gigCity.text forKey:@"city"];
        [newGig setValue:self.gigState.text forKey:@"state"];
        [newGig setValue:self.gigZip.text forKey:@"zip"];
        [newGig setValue:self.gigContactName.text forKey:@"contactName"];
        [newGig setValue:self.gigNotes.text forKey:@"notes"];
    }

    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    } else {
        NSLog(@"Save Was Successful");
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"unwindToGigTableViewController"]) {
        [self saveGig:nil];
    }
}

@end






































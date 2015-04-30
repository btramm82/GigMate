//
//  AddGigViewController.h
//  Gig Mate
//
//  Created by BRIAN TRAMMELL on 4/27/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Gigs.h"

@interface AddGigViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate, NSCoding>

@property (nonatomic, strong) Gigs *gigs;

@property (weak, nonatomic) IBOutlet UITextField *gigName;
@property (weak, nonatomic) IBOutlet UITextField *gigDate;
@property (weak, nonatomic) IBOutlet UITextField *gigStartTime;
@property (weak, nonatomic) IBOutlet UITextField *gigEndTime;
@property (weak, nonatomic) IBOutlet UITextField *gigAddress;
@property (weak, nonatomic) IBOutlet UITextField *gigCity;
@property (weak, nonatomic) IBOutlet UITextField *gigState;
@property (weak, nonatomic) IBOutlet UITextField *gigZip;
@property (weak, nonatomic) IBOutlet UITextField *gigContactName;
@property (weak, nonatomic) IBOutlet UITextField *gigNotes;


- (IBAction)saveGig:(id)sender;


@end

//
//  AddSongViewController.h
//  Gig Mate
//
//  Created by BRIAN TRAMMELL on 4/27/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSongViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *songName;
@property (weak, nonatomic) IBOutlet UITextField *artistName;
@property (weak, nonatomic) IBOutlet UITextField *bpm;
@property (weak, nonatomic) IBOutlet UITextView *songNotes;

@end

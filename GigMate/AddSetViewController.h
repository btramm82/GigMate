//
//  AddSetViewController.h
//  Gig Mate
//
//  Created by BRIAN TRAMMELL on 4/27/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSetViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *setName;

- (IBAction)addSongToSet:(id)sender;

@end

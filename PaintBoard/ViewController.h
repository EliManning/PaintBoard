//
//  ViewController.h
//  PaintBoard
//
//  Created by smart_parking on 9/4/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyView.h"
@interface ViewController : UIViewController
@property (strong,nonatomic) MyView* MyView;
@property (strong,nonatomic) IBOutlet UISlider *sliderCtl;
-(IBAction)changeColors:(id)sender;
- (IBAction)showSlider:(id)sender;
- (IBAction)clearButton:(id)sender;
- (IBAction)undoButton:(id)sender;
- (IBAction)saveImg:(id)sender;

@end

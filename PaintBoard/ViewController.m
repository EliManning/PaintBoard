//
//  ViewController.m
//  PaintBoard
//
//  Created by smart_parking on 9/4/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"
#import "QuartzCore/QuartzCore.h"

@interface ViewController ()
@property (assign,nonatomic) BOOL buttonHidden;
@property(nonatomic) NSMutableArray *colorsSet;
@end
@implementation ViewController
@synthesize MyView,sliderCtl,colorsSet;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //initialize colors and drawing view
    colorsSet=[[NSMutableArray alloc]initWithObjects:[UIColor blackColor],[UIColor orangeColor],[UIColor greenColor],[UIColor blueColor],[UIColor redColor], nil];
    self.MyView = [[MyView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.MyView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.MyView];
    [self.view sendSubviewToBack:self.MyView];
    [self hideControls];

}

//Color Button clicked, show the colors to choose from
-(IBAction)changeColors:(id)sender{
    if(!sliderCtl.hidden)
        sliderCtl.hidden = YES;
    
    if (self.buttonHidden) {
        for (int i=1; i<6; i++) {
            UIButton *button=(UIButton *)[self.view viewWithTag:i];
            button.hidden=NO;
            self.buttonHidden=NO;
        }
    }else{
        for (int i=1; i<6; i++) {
            UIButton *button=(UIButton *)[self.view viewWithTag:i];
            button.hidden=YES;
            self.buttonHidden=YES;
        }
        
    }
    
}

//Set the line color by clicking the colors
- (IBAction)colorSet:(id)sender {
    UIButton *button=(UIButton *)sender;
    [self.MyView setLineColor:[colorsSet objectAtIndex:button.tag-1]];
}

//Width button clicked, show the slider control
- (IBAction)showSlider:(id)sender {
    if(!self.buttonHidden) {
        for (int i=1; i<6; i++) {
            UIButton *button=(UIButton *)[self.view viewWithTag:i];
            button.hidden=YES;
            self.buttonHidden=YES;
        }
    }
    
    if(sliderCtl.hidden){
        sliderCtl.hidden = NO;
        
    }
    else{
        sliderCtl.hidden = YES;
    }
}

//Set the line width using slider
- (IBAction)sliderAction:(id)sender {
    UISlider *slider = (UISlider *)sender;
    NSLog(@"value = %f",  [slider value]);
    [self.MyView setLineWidth:[slider value]];
}

//hide slider and color buttons
-(void)hideControls{
    if(!self.buttonHidden){
        for (int i=1; i<6; i++) {
            UIButton *button=(UIButton *)[self.view viewWithTag:i];
            button.hidden=YES;
            self.buttonHidden=YES;
        }
    }
    if(!sliderCtl.hidden)
        sliderCtl.hidden = YES;

}

//Clear the screen
- (IBAction)clearButton:(id)sender {
    [self hideControls];
    [self.MyView clearPath];
}
//Undo the former drawing
- (IBAction)undoButton:(id)sender {
    [self.MyView undoPath];
}

//Save the drawing image to local photo album
- (IBAction)saveImg:(id)sender {
    //set all controls to be transparent, only save the drawing view
	for (UIView* temp in [self.view subviews])
	{
        if(temp != self.MyView)
            [temp setAlpha:0.0];
	}
    //get image
	UIGraphicsBeginImageContext(self.MyView.bounds.size);
	
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	
	UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	//save image
	UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    //recover the transparency
    for (UIView* temp in [self.view subviews])
	{
		[temp setAlpha:1.0];
	}    
}

//Show saveing result
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    [alert show];
}

//forbid rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationPortrait)
        return YES;
    return NO;
}
@end

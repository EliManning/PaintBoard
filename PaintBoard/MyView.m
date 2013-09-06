//
//  MyView.m
//  PaintBoard
//
//  Created by smart_parking on 9/4/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import "MyView.h"
#define defaultLineColor       [UIColor blackColor]
#define defaultLineWidth       10.0f;
@implementation MyView
@synthesize lineWidth = _lineWidth;
@synthesize lineColor = _lineColor;
@synthesize lineArray = _lineArray;
@synthesize colorArray = _colorArray;
@synthesize pointArray = _pointArray;
@synthesize widthArray = _widthArray;
@synthesize colors = _colors;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        //init arrays for storing path data
        self.lineColor = defaultLineColor;
        self.lineWidth = defaultLineWidth;
        pointArray=[[NSMutableArray alloc]init];
        lineArray=[[NSMutableArray alloc]init];
        colorArray=[[NSMutableArray alloc]init];
        widthArray=[[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - Touch Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //add color and width to array
    [colorArray addObject:self.lineColor];
    [widthArray addObject:[NSNumber numberWithFloat:self.lineWidth]];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //save all the touches in the path
    UITouch* touch=[touches anyObject];
    
    //add the current point to the path
	MyMovepoint=[touch locationInView:self];
    NSString *sPoint=NSStringFromCGPoint(MyMovepoint);
    [pointArray addObject:sPoint];
    [self setNeedsDisplay];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //make sure a point is recorded
    [self touchesMoved:touches withEvent:event];
    //when touch ended, store move points to line array
    [self addLA];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}
-(void)addLA{
    // store move points to line array
    NSArray *array=[NSArray arrayWithArray:pointArray];
    [lineArray addObject:array];
    //clear the current point array to draw the next line
    [pointArray removeAllObjects];
}

#pragma mark - DrawRect

- (void)drawRect:(CGRect)rect
{
    //init CGContext
    CGContextRef context=UIGraphicsGetCurrentContext();
    //set the line style
    CGContextSetLineJoin(context,kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineJoinRound);
    
    //draw all the lines in lineArray if there is any
    if ([lineArray count]>0) {
        for (int i=0; i<[lineArray count]; i++) {
            //get points set, color, line width for each line
            NSArray * array=[NSArray
                             arrayWithArray:[lineArray objectAtIndex:i]];
            UIColor *color = [colorArray objectAtIndex:i];
            CGFloat width = [[widthArray objectAtIndex:i]floatValue];
            
            if ([array count]>0)
            {
                //draw line
                CGContextBeginPath(context);
                CGPoint myStartPoint=CGPointFromString([array objectAtIndex:0]);
                CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
                
                for (int j=0; j<[array count]-1; j++)
                {
                    CGPoint myEndPoint=CGPointFromString([array objectAtIndex:j+1]);
                    //--------------------------------------------------------
                    CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
                }
                //set line color
                CGContextSetStrokeColorWithColor(context, color.CGColor);
                //set line width
                CGContextSetLineWidth(context, width);
                //save context
                CGContextStrokePath(context);
            }
        }
    }
    //draw the current path
    if ([pointArray count]>0)
    {
        //draw line
        CGContextBeginPath(context);
        CGPoint myStartPoint=CGPointFromString([pointArray objectAtIndex:0]);
        CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
        
        for (int j=0; j<[pointArray count]-1; j++)
        {
            CGPoint myEndPoint=CGPointFromString([pointArray objectAtIndex:j+1]);
            //--------------------------------------------------------
            CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
        }
        
        UIColor *color = [colorArray lastObject];
        CGFloat width = [[widthArray lastObject]floatValue];
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, width);
        CGContextStrokePath(context);
    }
  
}

#pragma mark - Clear / Undo

-(void)clearPath{
    if ([lineArray count]>0) {
        [pointArray removeAllObjects];
        [lineArray removeAllObjects];
        [colorArray removeAllObjects];
        [widthArray removeAllObjects];
        NSLog(@"Clear");
        [self setNeedsDisplay];
    }
    
}

-(void)undoPath{
    if ([lineArray count]>0) {
        [pointArray removeAllObjects];
        [lineArray removeLastObject];
        [colorArray removeLastObject];
        [widthArray removeLastObject];
        NSLog(@"Undo");
        [self setNeedsDisplay];
    }
    
}
@end

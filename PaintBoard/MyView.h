//
//  MyView.h
//  PaintBoard
//
//  Created by smart_parking on 9/4/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyView : UIView{
    NSMutableArray *pointArray;
    NSMutableArray *colorArray;
    NSMutableArray *lineArray;
    NSMutableArray *widthArray;
    CGFloat *lineWidth;
    UIColor *lineColor;
    CGPoint MyMovepoint;
    NSMutableArray *colors;
}
@property (nonatomic, assign ) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property(nonatomic) NSMutableArray *widthArray;
@property(nonatomic) NSMutableArray *pointArray;
@property(nonatomic) NSMutableArray *colors;
@property(nonatomic) NSMutableArray *colorArray;
@property(nonatomic) NSMutableArray *lineArray;
-(void)clearPath;
-(void)undoPath;
@end

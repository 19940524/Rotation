//
//  CustomImageView.m
//  HeadPhotoRotation
//
//  Created by 薛国宾 on 16/6/19.
//  Copyright © 2016年 Pan Li. All rights reserved.
//

#import "CustomImageView.h"
#import "NSString+Additions.h"

static BOOL isFirst = YES;

@implementation CustomImageView

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self setNeedsDisplay];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    UIImage *image;
    CGRect imageRect = CGRectMake(10, 10, 80, 80);
    if (self.isOnTheBack) {
        
        image = [UIImage imageNamed:@"head2.jpg"];
    } else {
        if (!isFirst) {
            CGContextTranslateCTM(ctx, 0.0, self.frame.size.height);
            CGContextScaleCTM(ctx, 1.0, -1.0);
        }
        isFirst = NO;
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
        
        [@"昵称" drawInContext:ctx withPosition:CGPointMake(self.frame.size.width / 2 - 15, self.frame.size.height / 2 - 10) andFont:[UIFont systemFontOfSize:14] andTextColor:[UIColor lightGrayColor] andHeight:20 andWidth:30];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    
    CGContextDrawImage(ctx, imageRect, image.CGImage);
    
    CGContextRestoreGState(ctx);
}


@end

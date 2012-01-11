//
//  GOBlackOutView.m
//  GOImageCache
//
//  Created by Samuel Goodwin on 12/31/11.
//

#import "GOBlackOutView.h"

@implementation GOBlackOutView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef context = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetRGBFillColor(context, 0.3f, 0.3f, 0.3f, 1.0f);
    CGContextFillRect(context, NSRectToCGRect(dirtyRect));// Drawing code here.
}

@end

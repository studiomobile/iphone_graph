//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import "iGraphConfig.h"

@implementation iGraphConfig


@synthesize gridDash;
@synthesize axisFont;
@synthesize keyFont;
@synthesize axisColor;
@synthesize axisTextColor;
@synthesize keyTextColor;
@synthesize padding;
@synthesize xAxisMargin;
@synthesize yAxisMargin;
@synthesize keyMargin;
@synthesize rightMargin;
@synthesize barMargin;
@synthesize lineWidth;
@synthesize xAxisSkipTicks;
@synthesize yAxisSkipTicks;


- (void)dealloc {
    [gridDash release];
    [axisFont release];
    [keyFont release];
    [axisColor release];
    [axisTextColor release];
    [keyTextColor release];
    [super dealloc];
}

@end

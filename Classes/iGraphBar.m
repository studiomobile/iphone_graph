//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import "iGraphBar.h"
#import "iGraph.h"


@implementation iGraphBar

@synthesize index;
@synthesize color;


- (id)initWithIndex:(NSUInteger)_index {
    if (![super init]) return nil;
    index = _index;
    return self;
}


- (void)dealloc {
    [color release];
    CGPathRelease(path);
    [super dealloc];
}


- (CGRect)barForPoint1:(CGPoint)p1 point2:(CGPoint)p2 baseLine:(CGFloat)baseLine margin:(CGFloat)margin {
    CGFloat width = fabsf(p2.x - p1.x) - margin;
    CGFloat height = p2.y - baseLine;
    return CGRectMake(p2.x - ceilf(width/2), baseLine, width, height);
}


- (void)precalculateWithGraph:(iGraph*)graph dataSource:(iGraphDataSource*)dataSource {
    CGPathRelease(path);
    path = CGPathCreateMutable();
    CGPoint p0;
    CGFloat baseLine = CGRectGetMinY(graph.gridBounds);
    CGFloat margin = graph.config.barMargin;
    for (NSUInteger x = 0; x < dataSource.xAxisPoints; ++x) {
        double value = [dataSource valueForLine:index XAxisPoint:x];
        CGPoint p = [graph pointForValue:value withIndex:x];
        if (x > 0) {
            if (x == 1) {
                CGPathAddRect(path, nil, [self barForPoint1:p point2:p0 baseLine:baseLine margin:margin]);
            }
            CGPathAddRect(path, nil, [self barForPoint1:p0 point2:p baseLine:baseLine margin:margin]);
        }
        p0 = p;
    }
}


- (void)drawInContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
}


@end

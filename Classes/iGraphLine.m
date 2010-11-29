//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import "iGraphLine.h"
#import "iGraph.h"

@implementation iGraphLine

@synthesize index;
@synthesize width;
@synthesize dash;
@synthesize color;
@synthesize keyLabel;


- (id)initWithIndex:(NSUInteger)_index {
    if (![super init]) return nil;
    index = _index;
    return self;
}


- (void)dealloc {
    [dash release];
    [color release];
    [keyLabel release];
    CGPathRelease(path);
    [super dealloc];
}


- (void)precalculateWithGraph:(iGraph*)graph dataSource:(iGraphDataSource*)dataSource {
    CGPathRelease(path);
    path = CGPathCreateMutable();
    CGPoint p0;
    for (NSUInteger x = 0; x < dataSource.xAxisPoints; ++x) {
        double value = [dataSource valueForLine:index XAxisPoint:x];
        CGPoint p = [graph pointForValue:value withIndex:x];
        if (x == 0) {
            CGPathMoveToPoint(path, nil, p.x, p.y);
        } else {
            CGPathAddQuadCurveToPoint(path, nil, ceilf((p0.x + p.x)/2), p0.y, p.x, p.y);
        }
        p0 = p;
    }
}


- (void)drawInContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx, width);
    if (dash.count > 0) {
        CGFloat *cgDash = alloca(sizeof(CGFloat)*dash.count);
        for (int i = 0; i < dash.count; ++i) {
            cgDash[i] = [[dash objectAtIndex:i] floatValue];
        }
        CGContextSetLineDash(ctx, 0, cgDash, dash.count);
    }
    
    CGContextBeginPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

@end

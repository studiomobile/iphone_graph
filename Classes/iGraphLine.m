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
    [keyLabel removeFromSuperview];
    [keyLabel release];
    CGPathRelease(path);
    [super dealloc];
}


- (void)precalculateWithGraph:(iGraph*)graph dataSource:(iGraphDataSource*)dataSource {
    CGPathRelease(path);
    path = CGPathCreateMutable();
    CGPoint p0;
    BOOL start = YES;
    for (iGraphMark *mark in graph.xAxis.marks) {
        double value = [dataSource valueForLine:index XAxisPoint:mark.index];
        if (isnan(value)) {
            start = YES;
            continue;
        }
        CGPoint p = [graph pointForValue:value withIndex:mark.index];
        if (start) {
            CGPathMoveToPoint(path, nil, p.x, p.y);
            start = NO;
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

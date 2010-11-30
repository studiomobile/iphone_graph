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
    CGFloat baseLine = CGRectGetMinY(graph.gridBounds);
    CGFloat margin = graph.config.barMargin;
    CGPoint p0 = CGPointZero, p1 = CGPointZero;
    double v0 = NAN, v1 = NAN;
    for (iGraphMark *mark in graph.xAxis.marks) {
        v1 = [dataSource valueForLine:index XAxisPoint:mark.index];
        p1 = [graph pointForValue:v1 withIndex:mark.index];
        if (!isnan(v0)) {
            CGRect rect = CGRectMake(p0.x, baseLine, ceilf(p1.x - p0.x - margin)/2, p0.y - baseLine);
            CGPathAddRect(path, nil, rect);
        }
        if (!isnan(v1)) {
            CGFloat width = ceilf(p1.x - p0.x - margin)/2;
            CGRect rect = CGRectMake(p1.x - width, baseLine, width, p1.y - baseLine);
            CGPathAddRect(path, nil, rect);
        }
        v0 = v1;
        p0 = p1;
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

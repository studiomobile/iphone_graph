//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import "iGraph.h"

@implementation iGraph

@synthesize config;
@synthesize bounds;
@synthesize keyBounds;
@synthesize gridBounds;
@synthesize xAxis;
@synthesize yAxis;
@synthesize bars;
@synthesize lines;


- (void)configureAxis:(iGraphAxis*)axis {
    axis.dash = config.gridDash;
    axis.gridLineWidth = 1;
    axis.marksLineSize = 5;
    axis.gridColor = config.axisColor;
    axis.marksColor = config.axisTextColor;
    axis.textFont = config.axisFont;
    axis.textColor = config.axisTextColor;
}


- (id)initWithBounds:(CGRect)_bounds config:(iGraphConfig*)_config {
    if (![super init]) return nil;
    
    bounds = _bounds;
    config = [_config retain];

    CGRect body;
    CGRectDivide(CGRectInset(bounds, config.padding, config.padding), &keyBounds, &body, config.keyMargin, CGRectMinYEdge);
    body.size.width -= config.rightMargin;
    
    CGRect xBounds;
    CGRect yBounds;
    CGRect tmp;
    CGRectDivide(body, &xBounds, &tmp, config.xAxisMargin, CGRectMinYEdge);
    CGRectDivide(body, &yBounds, &tmp, config.yAxisMargin, CGRectMinXEdge);
    
    gridBounds = body;
    gridBounds.origin.x += config.yAxisMargin;
    gridBounds.size.width -= config.yAxisMargin;
    gridBounds.origin.y += config.xAxisMargin;
    gridBounds.size.height -= config.xAxisMargin;

    xAxis = [[iGraphAxis alloc] initWithOrientation:iGraphAxisOrientationX];
    xAxis.bounds = xBounds;
    xAxis.gridBounds = gridBounds;
    xAxis.skipMarks = config.xAxisSkipTicks;
    [self configureAxis:xAxis];

    yAxis = [[iGraphAxis alloc] initWithOrientation:iGraphAxisOrientationY];
    yAxis.bounds = yBounds;
    yAxis.gridBounds = gridBounds;
    yAxis.skipMarks = config.yAxisSkipTicks;
    [self configureAxis:yAxis];
    
    return self;
}


- (void)dealloc {
    [config release];
    [xAxis release];
    [yAxis release];
    [bars release];
    [lines release];
    [super dealloc];
}


- (CGPoint)pointForValue:(double)value withIndex:(NSUInteger)index {
    iGraphMark *x = [xAxis.marks objectAtIndex:index];
    iGraphMark *p = nil;
    for (iGraphMark *y in yAxis.marks) {
        if (!p) {
            p = y;
            continue;
        }
        if (value < y.value) {
            CGFloat sy = (value - p.value) / (y.value - p.value);
            CGFloat dy = ceilf(p.point.y + (y.point.y - p.point.y) * sy);
            return CGPointMake(x.point.x, dy);
        }
    }
    return p.point;
}


- (void)precalculateWithDataSource:(iGraphDataSource*)dataSource {
    [xAxis precalculateWithDataSource:dataSource];
    [yAxis precalculateWithDataSource:dataSource];
    
    for (iGraphBar *bar in bars) {
        [bar precalculateWithGraph:self dataSource:dataSource];
    }
    
    for (iGraphLine *line in lines) {
        [line precalculateWithGraph:self dataSource:dataSource];
    }
}


- (void)drawInContext:(CGContextRef)ctx {
    [xAxis drawInContext:ctx];
    [yAxis drawInContext:ctx];

    CGContextSaveGState(ctx);
    CGContextClipToRect(ctx, gridBounds);

    for (iGraphBar *bar in bars) {
        [bar drawInContext:ctx];
    }

    for (iGraphLine *line in lines) {
        [line drawInContext:ctx];
    }

    CGContextRestoreGState(ctx);
}

@end

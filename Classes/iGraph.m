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
    [self configureAxis:xAxis];

    yAxis = [[iGraphAxis alloc] initWithOrientation:iGraphAxisOrientationY];
    yAxis.bounds = yBounds;
    yAxis.gridBounds = gridBounds;
    [self configureAxis:yAxis];
    
    return self;
}


- (void)dealloc {
    [config release];
    [xAxis release];
    [yAxis release];
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

    for (iGraphLine *line in lines) {
        [line precalculateWithGraph:self dataSource:dataSource];
    }
}


- (void)drawInContext:(CGContextRef)ctx {
    [xAxis drawInContext:ctx];
    [yAxis drawInContext:ctx];
    
    CGFloat keyLeft = CGRectGetMinX(keyBounds) + 5;
    CGFloat keyCenter = CGRectGetMidY(keyBounds);
    CGFloat iconWidth = 20;
    CGFloat iconHeight = 10;

    UIFont *font = config.keyFont;
	CGContextSelectFont(ctx, [[font fontName] cStringUsingEncoding:NSUTF8StringEncoding], [font pointSize], kCGEncodingMacRoman);
    CGFloat textHeight = [font pointSize];
    
    for (iGraphLine *line in lines) {
        [line drawInContext:ctx];

        CGContextSaveGState(ctx);
        
        CGContextSetFillColorWithColor(ctx, [line.color CGColor]);
        CGRect iconRect = CGRectMake(keyLeft, keyCenter - iconHeight/2 - 2, iconWidth, iconHeight);
        CGContextFillRect(ctx, iconRect);
        keyLeft += iconRect.size.width + 5;

        const char *str = [line.title cStringUsingEncoding:NSUTF8StringEncoding];
        size_t length = strlen(str);
        
        CGContextSetTextDrawingMode(ctx, kCGTextInvisible);
        CGContextSetTextPosition(ctx, 0, 0);
        CGContextShowText(ctx, str, length);
        CGFloat textWidth = CGContextGetTextPosition(ctx).x;
        
        CGContextSetTextDrawingMode(ctx, kCGTextFill);
        CGContextSetFillColorWithColor(ctx, [config.keyTextColor CGColor]);
        CGContextShowTextAtPoint(ctx, keyLeft, ceilf(keyCenter - textHeight/2), str, length);
        keyLeft += textWidth + 10;

        CGContextRestoreGState(ctx);
    }
}

@end

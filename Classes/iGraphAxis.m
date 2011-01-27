//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import "iGraphAxis.h"
#import "iGraphMark.h"


@implementation iGraphAxis

@synthesize orientation;
@synthesize bounds;
@synthesize gridBounds;
@synthesize marks;
@synthesize skipMarks;
@synthesize dash;
@synthesize gridLineWidth;
@synthesize marksLineSize;
@synthesize gridColor;
@synthesize marksColor;
@synthesize textFont;
@synthesize textColor;


- (id)initWithOrientation:(iGraphAxisOrientation)_orientation {
    if (![super init]) return nil;
    orientation = _orientation;
    return self;
}


- (void)dealloc {
    [marks release];
    [dash release];
    [gridColor release];
    [marksColor release];
    [textFont release];
    [textColor release];
    CGPathRelease(gridPath);
    CGPathRelease(marksPath);
    [super dealloc];
}


- (void)precalculateWithDataSource:(iGraphDataSource*)dataSource {
    CGPathRelease(gridPath);
    gridPath = CGPathCreateMutable();
    CGPathRelease(marksPath);
    marksPath = CGPathCreateMutable();

    NSUInteger marksCount = orientation == iGraphAxisOrientationX ? [dataSource xAxisPoints] : [dataSource yAxisPoints];
    
    CGFloat xMin = CGRectGetMinX(gridBounds);
    CGFloat xMax = CGRectGetMaxX(gridBounds);
    CGFloat xOffset = gridBounds.size.width / (marksCount - 1);
    CGFloat yMin = CGRectGetMinY(gridBounds);
    CGFloat yMax = CGRectGetMaxY(gridBounds);
    CGFloat yOffset = gridBounds.size.height / (marksCount - 1);
    NSUInteger skip = 0;
    
    NSMutableArray *gridMarks = [NSMutableArray arrayWithCapacity:marksCount];
    for (int i = 0; i < marksCount; ++i) {
        iGraphMark *mark = [[[iGraphMark alloc] initWithIndex:i] autorelease];
        CGPoint markPoint, gridOffset, markOffset;
        NSString *title;

        switch (orientation) {
            case iGraphAxisOrientationX: {
                CGFloat x = ceilf(xMin + xOffset * i);
                markPoint = CGPointMake(x, yMin);
                gridOffset = CGPointMake(x, yMax);
                markOffset = CGPointMake(x, yMin - marksLineSize);
                title = [dataSource titleForXAxisPoint:i];
            }   break;
            case iGraphAxisOrientationY: {
                CGFloat y = ceilf(yMin + yOffset * i);
                markPoint = CGPointMake(xMin, y);
                gridOffset = CGPointMake(xMax, y);
                markOffset = CGPointMake(xMin - marksLineSize, y);
                title = [dataSource titleForYAxisPoint:i];
                mark.value = [dataSource valueForYAxisPoint:i];
            }   break;
        }
        
        if (!skip) {
            CGPathMoveToPoint(gridPath, nil, markPoint.x, markPoint.y);
            CGPathAddLineToPoint(gridPath, nil, gridOffset.x, gridOffset.y);

            CGPathMoveToPoint(marksPath, nil, markPoint.x, markPoint.y);
            CGPathAddLineToPoint(marksPath, nil, markOffset.x, markOffset.y);

            mark.label = [[UILabel new] autorelease];
            mark.label.text = title;
            mark.label.font = textFont;
            mark.label.textColor = textColor;
            mark.label.backgroundColor = [UIColor clearColor];

            skip = skipMarks;
        } else {
            --skip;
        }

        mark.point = markPoint;
        [gridMarks addObject:mark];
    }

    [marks autorelease];
    marks = [gridMarks retain];
}


- (void)drawInContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx, gridLineWidth);
    if (dash.count > 0) {
        CGFloat *cgDash = alloca(sizeof(CGFloat)*dash.count);
        for (int i = 0; i < dash.count; ++i) {
            cgDash[i] = [[dash objectAtIndex:i] floatValue];
        }
        CGContextSetLineDash(ctx, 0, cgDash, dash.count);
    }
    
    CGContextBeginPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, [gridColor CGColor]);
    CGContextAddPath(ctx, gridPath);
    CGContextStrokePath(ctx);
    
    CGContextBeginPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, [marksColor CGColor]);
    CGContextAddPath(ctx, marksPath);
    CGContextStrokePath(ctx);

    CGContextRestoreGState(ctx);
}

@end

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
    
    NSMutableArray *gridMarks = [NSMutableArray arrayWithCapacity:marksCount];
    for (int i = 0; i < marksCount; ++i) {
        iGraphMark *mark = [[[iGraphMark alloc] initWithIndex:i] autorelease];
        CGPoint markPoint, gridOffset, markOffset;

        switch (orientation) {
            case iGraphAxisOrientationX: {
                CGFloat x = ceilf(xMin + xOffset * i);
                markPoint = CGPointMake(x, yMin);
                gridOffset = CGPointMake(x, yMax);
                markOffset = CGPointMake(x, yMin - marksLineSize);
                mark.title = [dataSource titleForXAxisPoint:i];
            }   break;
            case iGraphAxisOrientationY: {
                CGFloat y = ceilf(yMin + yOffset * i);
                markPoint = CGPointMake(xMin, y);
                gridOffset = CGPointMake(xMax, y);
                markOffset = CGPointMake(xMin - marksLineSize, y);
                mark.title = [dataSource titleForYAxisPoint:i];
                mark.value = [dataSource valueForYAxisPoint:i];
            }   break;
        }
        
        CGPathMoveToPoint(gridPath, nil, markPoint.x, markPoint.y);
        CGPathAddLineToPoint(gridPath, nil, gridOffset.x, gridOffset.y);

        CGPathMoveToPoint(marksPath, nil, markPoint.x, markPoint.y);
        CGPathAddLineToPoint(marksPath, nil, markOffset.x, markOffset.y);
        
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

	CGContextSelectFont(ctx, [[textFont fontName] cStringUsingEncoding:NSUTF8StringEncoding], [textFont pointSize], kCGEncodingMacRoman);
    CGContextSetFillColorWithColor(ctx, [textColor CGColor]);
    
    CGFloat textHeight = [textFont pointSize];
    
    for (iGraphMark *mark in marks) {
        const char *str = [mark.title cStringUsingEncoding:NSUTF8StringEncoding];
        size_t length = strlen(str);

        CGContextSetTextDrawingMode(ctx, kCGTextInvisible);
        CGContextSetTextPosition(ctx, 0, 0);
        CGContextShowText(ctx, str, length);
        CGFloat textWidth = CGContextGetTextPosition(ctx).x;

        CGContextSetTextDrawingMode(ctx, kCGTextFill);

        switch (orientation) {
            case iGraphAxisOrientationX:
                CGContextSetTextPosition(ctx, mark.point.x - ceilf(textWidth/2), mark.point.y - textHeight - marksLineSize);
                break;
            case iGraphAxisOrientationY:
                CGContextSetTextPosition(ctx, mark.point.x - textWidth - marksLineSize*2, mark.point.y - ceilf(textHeight/2));
                break;
        }
        
        CGContextShowText(ctx, str, length);
    }
    
    CGContextRestoreGState(ctx);
}

@end

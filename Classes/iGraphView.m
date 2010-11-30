//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import "iGraphView.h"
#import "iGraph.h"
#import "iGraphConfig.h"

@implementation iGraphView

@synthesize dataSource;
@synthesize delegate;
@synthesize config;


- (void)initialize {
    config = [iGraphConfig new];
    config.gridDash = [NSArray arrayWithObjects:[NSNumber numberWithFloat:3], [NSNumber numberWithFloat:3], nil];
    config.axisFont = [UIFont italicSystemFontOfSize:12];
    config.keyFont = [UIFont boldSystemFontOfSize:12];
    config.axisColor = [UIColor lightGrayColor];
    config.axisTextColor = [UIColor blackColor];
    config.keyTextColor = [UIColor blackColor];
    config.padding = 5;
    config.xAxisMargin = 20;
    config.yAxisMargin = 25;
    config.keyMargin = 20;
    config.rightMargin = 20;
    config.barMargin = 3;
    config.lineWidth = 1;
}


- (void)dealloc {
    [graph release];
    [config release];
    [pointViews release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame {
    if (![super initWithFrame:frame]) return nil;
    [self initialize];
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}


- (void)reloadData:(BOOL)forceLayout {
    [graph autorelease];
    graph = [[iGraph alloc] initWithBounds:self.bounds config:config];

    NSUInteger L = [dataSource respondsToSelector:@selector(graphViewNumberOfGraphsInGraphView:)] ? [dataSource graphViewNumberOfGraphsInGraphView:self] : 1;
    BOOL drawBars = [dataSource respondsToSelector:@selector(graphView:barColorForLine:)];
    NSMutableArray *lines = [NSMutableArray arrayWithCapacity:L];
    NSMutableArray *bars =  drawBars ? [NSMutableArray arrayWithCapacity:L] : nil;
    for (NSUInteger l = 0; l < L; ++l) {
        iGraphLine *line = [[[iGraphLine alloc] initWithIndex:l] autorelease];
        
        UILabel *label = [[UILabel new] autorelease];
        label.text = [dataSource graphView:self titleForLine:l];
        label.font = config.keyFont;
        label.textColor = config.keyTextColor;
        [label sizeToFit];

        line.keyLabel = label;
        line.color = [dataSource graphView:self colorForLine:l];
        line.width = config.lineWidth;
        [lines addObject:line];
        if (drawBars) {
            iGraphBar *bar = [[[iGraphBar alloc] initWithIndex:l] autorelease];
            bar.color = [dataSource graphView:self barColorForLine:l];
            if (bar.color) {
                [bars addObject:bar];
            }
        }
    }
    graph.lines = lines;
    graph.bars = bars;

    iGraphDataSource *source = [[[iGraphDataSource alloc] initWithView:self dataSource:dataSource] autorelease];
    [graph precalculateWithDataSource:source];

    [self setNeedsDisplay];
    
    if (forceLayout) {
        [self setNeedsLayout];
    }
}


- (void)reloadData {
    [self reloadData:YES];
}


- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self reloadData:NO];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    BOOL pointViewsReleaseSupported = [dataSource respondsToSelector:@selector(graphView:willReleaseView:)];
    for (UIView *v in pointViews) {
        if (pointViewsReleaseSupported) {
            [dataSource graphView:self willReleaseView:v];
        }
        [v removeFromSuperview];
    }
    [pointViews release];
    pointViews = nil;
    
    BOOL pointViewsSupported = [dataSource respondsToSelector:@selector(graphView:viewForLine:xAxisPoint:)];
    if (pointViewsSupported) {
        NSMutableArray *newPointViews = [NSMutableArray array];
        for (iGraphMark *mark in graph.xAxis.marks) {
            for (iGraphLine *line in graph.lines) {
                double value = [dataSource graphView:self valueForLine:line.index XAxisPoint:mark.index];
                if (isnan(value)) continue;
                UIView *view = [dataSource graphView:self viewForLine:line.index xAxisPoint:mark.index];
                if (view) {
                    CGPoint p = [graph pointForValue:value withIndex:mark.index];
                    p.y = self.bounds.size.height - p.y;
                    [self addSubview:view];
                    view.center = p;
                    [newPointViews addObject:view];
                }
            }
        }
        pointViews = [newPointViews copy];
    }
}



- (void)drawKeyInContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    
    CGFloat keyLeft = CGRectGetMinX(graph.keyBounds) + 5;
    CGFloat keyCenter = CGRectGetMidY(graph.keyBounds);
    CGFloat iconWidth = 20;
    CGFloat iconHeight = 10;
    
    for (iGraphLine *line in graph.lines) {
        CGContextSetFillColorWithColor(ctx, [line.color CGColor]);
        CGRect iconRect = CGRectMake(keyLeft, keyCenter - iconHeight/2 - 2, iconWidth, iconHeight);
        CGContextFillRect(ctx, iconRect);
        keyLeft += iconRect.size.width + 5;
        CGRect frame = line.keyLabel.frame;
        frame.origin.x = keyLeft;
        frame.origin.y = self.bounds.size.height - keyCenter - ceilf(frame.size.height/2) + 3;
        line.keyLabel.frame = frame;
        [self addSubview:line.keyLabel];
        keyLeft += frame.size.width + 10;
    }
    
    CGContextRestoreGState(ctx);
}


- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGAffineTransform tr = CGContextGetCTM(ctx);
    CGContextScaleCTM(ctx, tr.a < 0 ? -1 : 1, tr.d < 0 ? -1 : 1);
    CGContextTranslateCTM(ctx, tr.a < 0 ? tr.tx/tr.a : 0, tr.d < 0 ? tr.ty/tr.d : 0);

    [self drawKeyInContext:ctx];
    [graph drawInContext:ctx];
}

@end

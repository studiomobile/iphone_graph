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


- (void)reloadData {
    [graph autorelease];
    graph = [[iGraph alloc] initWithBounds:self.bounds config:config];

    NSUInteger L = [dataSource respondsToSelector:@selector(graphViewNumberOfGraphsInGraphView:)] ? [dataSource graphViewNumberOfGraphsInGraphView:self] : 1;
    BOOL drawBars = [dataSource respondsToSelector:@selector(graphView:barColorForLine:)];
    NSMutableArray *lines = [NSMutableArray arrayWithCapacity:L];
    NSMutableArray *bars =  drawBars ? [NSMutableArray arrayWithCapacity:L] : nil;
    for (NSUInteger l = 0; l < L; ++l) {
        iGraphLine *line = [[[iGraphLine alloc] initWithIndex:l] autorelease];
        line.title = [dataSource graphView:self titleForLine:l];
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

    BOOL pointViewsReleaseSupported = [dataSource respondsToSelector:@selector(graphView:willReleaseView:)];
    if (pointViewsReleaseSupported) {
        for (UIView *v in pointViews) {
            [dataSource graphView:self willReleaseView:v];
            [v removeFromSuperview];
        }
    }

    BOOL pointViewsSupported = [dataSource respondsToSelector:@selector(graphView:viewForLine:xAxisPoint:)];
    if (pointViewsSupported) {
        NSMutableArray *newPointViews = [NSMutableArray array];
        for (iGraphMark *mark in graph.xAxis.marks) {
            for (iGraphLine *line in graph.lines) {
                UIView *view = [dataSource graphView:self viewForLine:line.index xAxisPoint:mark.index];
                if (view) {
                    double value = [dataSource graphView:self valueForLine:line.index XAxisPoint:mark.index];
                    CGPoint p = [graph pointForValue:value withIndex:mark.index];
                    p.y = self.bounds.size.height - p.y;
                    [self addSubview:view];
                    view.center = p;
                    [newPointViews addObject:view];
                }
            }
        }
    }
}


- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self reloadData];
}


- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGAffineTransform tr = CGContextGetCTM(ctx);
    CGContextScaleCTM(ctx, tr.a < 0 ? -1 : 1, tr.d < 0 ? -1 : 1);
    CGContextTranslateCTM(ctx, tr.a < 0 ? tr.tx/tr.a : 0, tr.d < 0 ? tr.ty/tr.d : 0);
    [graph drawInContext:ctx];
}

@end

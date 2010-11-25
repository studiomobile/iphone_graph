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
}


- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self reloadData];
}


- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(ctx, CGAffineTransformInvert(CGContextGetCTM(ctx)));
    [graph drawInContext:ctx];
}

@end

//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import "iGraphDataSource.h"
#import "iGraphView.h"

@implementation iGraphDataSource


- (id)initWithView:(iGraphView*)_view dataSource:(id)_dataSource {
    if (![super init]) return nil;
    view = [_view retain];
    dataSource = _dataSource;
    return self;
}


- (NSUInteger)xAxisPoints {
    return [dataSource graphViewNumberOfXAxisPoints:view];
}


- (NSUInteger)yAxisPoints {
    return [dataSource graphViewNumberOfYAxisPoints:view];
}


- (NSString*)titleForXAxisPoint:(NSInteger)pointIndex {
    return [dataSource graphView:view titleForXAxisPoint:pointIndex];
}


- (NSString*)titleForYAxisPoint:(NSInteger)pointIndex {
    return [dataSource graphView:view titleForYAxisPoint:pointIndex];
}


- (double_t)valueForLine:(NSInteger)lineIndex XAxisPoint:(NSInteger)pointIndex {
    return [dataSource graphView:view valueForLine:lineIndex XAxisPoint:pointIndex];
}


- (double_t)valueForYAxisPoint:(NSInteger)pointIndex {
    return [dataSource graphView:view valueForYAxisPoint:pointIndex];
}


- (void)dealloc {
    [view release];
    [super dealloc];
}


@end

//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import <Foundation/Foundation.h>

@class iGraphView;

@interface iGraphDataSource : NSObject {
    iGraphView *view;
    id dataSource;
}

- (id)initWithView:(iGraphView*)view dataSource:(id)dataSource;

- (NSUInteger)xAxisPoints;
- (NSUInteger)yAxisPoints;

- (NSString*)titleForXAxisPoint:(NSInteger)pointIndex;
- (NSString*)titleForYAxisPoint:(NSInteger)pointIndex;

- (double_t)valueForLine:(NSInteger)lineIndex XAxisPoint:(NSInteger)pointIndex;
- (double_t)valueForYAxisPoint:(NSInteger)pointIndex;

@end

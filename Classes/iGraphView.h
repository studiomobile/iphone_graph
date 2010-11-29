//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import <UIKit/UIKit.h>
#import "iGraphConfig.h"

@protocol iGraphViewDataSource;
@protocol iGraphViewDelegate;

@class iGraph;

@interface iGraphView : UIView {
    IBOutlet id<iGraphViewDataSource> dataSource;
    IBOutlet id<iGraphViewDelegate> delegate;
    iGraph *graph;
    iGraphConfig *config;
    NSArray *pointViews;
}
@property (nonatomic, assign) id<iGraphViewDataSource> dataSource;
@property (nonatomic, assign) id<iGraphViewDelegate> delegate;
@property (nonatomic, readonly) iGraphConfig *config;

- (void)reloadData;

@end


@protocol iGraphViewDataSource <NSObject>

- (NSUInteger)graphViewNumberOfXAxisPoints:(iGraphView*)view;
- (NSUInteger)graphViewNumberOfYAxisPoints:(iGraphView*)view;

- (NSString*)graphView:(iGraphView*)view titleForXAxisPoint:(NSUInteger)pointIndex;
- (NSString*)graphView:(iGraphView*)view titleForYAxisPoint:(NSUInteger)pointIndex;

- (NSString*)graphView:(iGraphView*)view titleForLine:(NSUInteger)lineIndex;
- (UIColor*)graphView:(iGraphView*)view colorForLine:(NSUInteger)lineIndex;

- (double_t)graphView:(iGraphView*)view valueForLine:(NSUInteger)lineIndex XAxisPoint:(NSUInteger)pointIndex;
- (double_t)graphView:(iGraphView*)view valueForYAxisPoint:(NSUInteger)pointIndex;

@optional

- (NSUInteger)graphViewNumberOfGraphsInGraphView:(iGraphView*)view;

- (UIColor*)graphView:(iGraphView*)view barColorForLine:(NSUInteger)lineIndex;

- (UIView*)graphView:(iGraphView*)view viewForLine:(NSUInteger)lineIndex xAxisPoint:(NSUInteger)pointIndex;
- (void)graphView:(iGraphView*)view willReleaseView:(UIView*)view;

@end


@protocol iGraphViewDelegate <NSObject>

@end

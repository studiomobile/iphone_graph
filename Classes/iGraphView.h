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
}
@property (nonatomic, assign) id<iGraphViewDataSource> dataSource;
@property (nonatomic, assign) id<iGraphViewDelegate> delegate;
@property (nonatomic, readonly) iGraphConfig *config;

- (void)reloadData;

@end


@protocol iGraphViewDataSource <NSObject>

- (NSUInteger)graphViewNumberOfXAxisPoints:(iGraphView*)view;
- (NSUInteger)graphViewNumberOfYAxisPoints:(iGraphView*)view;

- (NSString*)graphView:(iGraphView*)view titleForXAxisPoint:(NSInteger)pointIndex;
- (NSString*)graphView:(iGraphView*)view titleForYAxisPoint:(NSInteger)pointIndex;

- (NSString*)graphView:(iGraphView*)view titleForLine:(NSInteger)lineIndex;
- (UIColor*)graphView:(iGraphView*)view colorForLine:(NSInteger)lineIndex;

- (double_t)graphView:(iGraphView*)view valueForLine:(NSInteger)lineIndex XAxisPoint:(NSInteger)pointIndex;
- (double_t)graphView:(iGraphView*)view valueForYAxisPoint:(NSInteger)pointIndex;

@optional

- (NSUInteger)graphViewNumberOfGraphsInGraphView:(iGraphView*)view;

- (UIColor*)graphView:(iGraphView*)view barColorForLine:(NSInteger)lineIndex;

- (UIView*)graphView:(iGraphView*)view keyViewForLine:(NSInteger)lineIndex;

@end


@protocol iGraphViewDelegate <NSObject>

@end

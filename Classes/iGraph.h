//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import "iGraphConfig.h"
#import "iGraphDataSource.h"
#import "iGraphAxis.h"
#import "iGraphMark.h"
#import "iGraphBar.h"
#import "iGraphLine.h"

@interface iGraph : NSObject {
    iGraphConfig *config;
    
    CGRect bounds;
    CGRect keyBounds;
    CGRect gridBounds;
    
    iGraphAxis *xAxis;
    iGraphAxis *yAxis;
    
    NSArray *bars;
    NSArray *lines;
}
@property (nonatomic, readonly) iGraphConfig *config;
@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readonly) CGRect keyBounds;
@property (nonatomic, readonly) CGRect gridBounds;
@property (nonatomic, readonly) iGraphAxis *xAxis;
@property (nonatomic, readonly) iGraphAxis *yAxis;
@property (nonatomic, retain) NSArray *bars;
@property (nonatomic, retain) NSArray *lines;


- (id)initWithBounds:(CGRect)bounds config:(iGraphConfig*)config;

- (CGPoint)pointForValue:(double)value withIndex:(NSUInteger)index;

- (void)precalculateWithDataSource:(iGraphDataSource*)dataSource;

- (void)drawInContext:(CGContextRef)ctx;

@end

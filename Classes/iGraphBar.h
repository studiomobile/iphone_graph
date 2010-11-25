//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import <CoreGraphics/CoreGraphics.h>
#import "iGraphDataSource.h"

@class iGraph;

@interface iGraphBar : NSObject {
    NSUInteger index;
    UIColor *color;
    CGMutablePathRef path;
}
@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, retain) UIColor *color;

- (id)initWithIndex:(NSUInteger)index;

- (void)precalculateWithGraph:(iGraph*)graph dataSource:(iGraphDataSource*)dataSource;

- (void)drawInContext:(CGContextRef)ctx;

@end

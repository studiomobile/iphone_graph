//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import <CoreGraphics/CoreGraphics.h>
#import "iGraphDataSource.h"

@class iGraph;

@interface iGraphLine : NSObject {
    NSUInteger index;
    
    CGFloat width;
    NSArray *dash;

    UIColor *color;

    UILabel *keyLabel;
    
    CGMutablePathRef path;
}
@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, retain) NSArray *dash;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) UILabel *keyLabel;

- (id)initWithIndex:(NSUInteger)index;

- (void)precalculateWithGraph:(iGraph*)graph dataSource:(iGraphDataSource*)dataSource;

- (void)drawInContext:(CGContextRef)ctx;

@end

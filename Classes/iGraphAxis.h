//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import <CoreGraphics/CoreGraphics.h>
#import "iGraphDataSource.h"

typedef enum {
    
    iGraphAxisOrientationY,
    iGraphAxisOrientationX,
    
} iGraphAxisOrientation;


@interface iGraphAxis : NSObject {
    iGraphAxisOrientation orientation;

    CGRect bounds;
    CGRect gridBounds;
    
    NSArray *marks;
    NSUInteger skipMarks;
    
    NSArray *dash;
    
    CGFloat gridLineWidth;
    NSUInteger marksLineSize;
    
    UIColor *gridColor;
    UIColor *marksColor;
    
    UIFont *textFont;
    UIColor *textColor;
    
    CGMutablePathRef gridPath;
    CGMutablePathRef marksPath;
}
@property (nonatomic, readonly) iGraphAxisOrientation orientation;
@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) CGRect gridBounds;
@property (nonatomic, retain) NSArray *marks;
@property (nonatomic, assign) NSUInteger skipMarks;
@property (nonatomic, retain) NSArray *dash;
@property (nonatomic, assign) CGFloat gridLineWidth;
@property (nonatomic, assign) NSUInteger marksLineSize;
@property (nonatomic, retain) UIColor *gridColor;
@property (nonatomic, retain) UIColor *marksColor;
@property (nonatomic, retain) UIFont *textFont;
@property (nonatomic, retain) UIColor *textColor;

- (id)initWithOrientation:(iGraphAxisOrientation)orientation;

- (void)precalculateWithDataSource:(iGraphDataSource*)dataSource;

- (void)drawInContext:(CGContextRef)ctx;

@end

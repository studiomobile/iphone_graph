//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import <CoreGraphics/CoreGraphics.h>

@interface iGraphMark : NSObject {
    NSUInteger index;
    UILabel *label;
    CGPoint point;
    double value;
}
@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) double value;

- (id)initWithIndex:(NSUInteger)index;

@end


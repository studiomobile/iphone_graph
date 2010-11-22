//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import <CoreGraphics/CoreGraphics.h>

@interface iGraphMark : NSObject {
    NSUInteger index;
    NSString *title;
    CGPoint point;
    double value;
}
@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) double value;

- (id)initWithIndex:(NSUInteger)index;

@end


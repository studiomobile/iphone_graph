//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import <Foundation/Foundation.h>

@interface iGraphConfig : NSObject {
    NSArray *gridDash;
    UIFont *axisFont;
    UIFont *keyFont;
    UIColor *axisColor;
    UIColor *axisTextColor;
    UIColor *keyTextColor;
    CGFloat padding;
    CGFloat xAxisMargin;
    CGFloat yAxisMargin;
    CGFloat keyMargin;
    CGFloat rightMargin;
    CGFloat barMargin;
    CGFloat lineWidth;
}
@property (nonatomic, retain) NSArray *gridDash;
@property (nonatomic, retain) UIFont *axisFont;
@property (nonatomic, retain) UIFont *keyFont;
@property (nonatomic, retain) UIColor *axisColor;
@property (nonatomic, retain) UIColor *axisTextColor;
@property (nonatomic, retain) UIColor *keyTextColor;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) CGFloat xAxisMargin;
@property (nonatomic, assign) CGFloat yAxisMargin;
@property (nonatomic, assign) CGFloat keyMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) CGFloat barMargin;
@property (nonatomic, assign) CGFloat lineWidth;

@end

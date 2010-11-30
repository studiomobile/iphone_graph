//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import "iPhoneGraphViewController.h"

@implementation iPhoneGraphViewController

double y[] = { 9, 18, 27, 36, 45, 54, 63, 72, 81, 90, 99 };
double x[] = { 10, 13, 15, NAN, 20, 18, 14, 10 };


- (void)viewDidLoad {
    [super viewDidLoad];
    dates = [NSMutableArray new];
    NSDate *date = [NSDate date];
    for (int i = 0; i < sizeof(x)/sizeof(x[0]); i++) {
        [dates addObject:date];
        date = [date dateByAddingTimeInterval:24*60*60];
    }
    formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MMM d"];
    [graphView reloadData];
}


- (NSUInteger)graphViewNumberOfXAxisPoints:(iGraphView*)view {
    return dates.count;
}


- (NSUInteger)graphViewNumberOfYAxisPoints:(iGraphView*)view {
    return sizeof(y)/sizeof(y[0]);
}


- (NSString*)graphView:(iGraphView*)view titleForXAxisPoint:(NSUInteger)pointIndex {
    return [formatter stringFromDate:[dates objectAtIndex:pointIndex]];
}


- (NSString*)graphView:(iGraphView*)view titleForYAxisPoint:(NSUInteger)pointIndex {
    return [NSString stringWithFormat:@"%.0f", y[pointIndex]];
}


- (NSString*)graphView:(iGraphView*)view titleForLine:(NSUInteger)lineIndex {
    return @"My Mood";
}


- (UIColor*)graphView:(iGraphView*)view colorForLine:(NSUInteger)lineIndex {
    return [UIColor redColor];
}


- (UIColor*)graphView:(iGraphView*)view barColorForLine:(NSUInteger)lineIndex {
    return [UIColor greenColor];
}


- (double_t)graphView:(iGraphView*)view valueForLine:(NSUInteger)graphIndex XAxisPoint:(NSUInteger)pointIndex {
    return x[pointIndex];
}


- (double_t)graphView:(iGraphView*)view valueForYAxisPoint:(NSUInteger)pointIndex {
    return y[pointIndex];
}


- (UIView*)graphView:(iGraphView*)view viewForLine:(NSUInteger)lineIndex xAxisPoint:(NSUInteger)pointIndex {
    UIImage *image = [UIImage imageNamed:@"ICQ_Flower_Icon.png"];
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)] autorelease];
    imageView.image = image;
    return imageView;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [graphView setNeedsLayout];
}


- (void)dealloc {
    [dates release];
    [formatter release];
    [super dealloc];
}

@end

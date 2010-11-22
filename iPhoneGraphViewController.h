//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import <UIKit/UIKit.h>
#import "iGraphView.h"

@interface iPhoneGraphViewController : UIViewController <iGraphViewDataSource, iGraphViewDelegate> {
    IBOutlet iGraphView *graphView;
    NSMutableArray *dates;
    NSDateFormatter *formatter;
}

@end


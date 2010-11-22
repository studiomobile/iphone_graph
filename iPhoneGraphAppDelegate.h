//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import <UIKit/UIKit.h>

@class iPhoneGraphViewController;

@interface iPhoneGraphAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iPhoneGraphViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iPhoneGraphViewController *viewController;

@end


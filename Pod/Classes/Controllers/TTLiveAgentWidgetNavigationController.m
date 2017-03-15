
#import "TTLiveAgentWidgetNavigationController.h"

@implementation TTLiveAgentWidgetNavigationController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.viewControllers.firstObject preferredStatusBarStyle];
}

@end

//
//  TTLiveAgentWidgetEmailComposer.h
//  Pods
//
//  Created by Lukas Boura on 24/06/15.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "TTLiveAgentWidgetSupportTopic.h"

@interface TTLiveAgentWidgetEmailComposer : NSObject <MFMailComposeViewControllerDelegate>

- (void)show:(UIViewController *) controller withTopic:(TTLiveAgentWidgetSupportTopic *) topic;

@end

//
//  TTLiveAgentWidgetTopicsController.h
//  Pods
//
//  Created by Lukas Boura on 22/06/15.
//
//

#import <UIKit/UIKit.h>
#import "TTLiveAgentWidget.h"
#import "TTLiveAgentWidgetSupportTopic.h"
#import "TTLiveAgentWidgetQuestionsController.h"

@interface TTLiveAgentWidgetTopicsController : UITableViewController

@property (nonatomic, copy) NSArray<TTLiveAgentWidgetSupportTopic *> *topics;
@property (nonatomic, copy) UIColor *tintColor;
@property (nonatomic, copy) UIColor *barColor;
@property (nonatomic, copy) UIColor *titleColor;
@property UIStatusBarStyle statusBarStyle;

@end

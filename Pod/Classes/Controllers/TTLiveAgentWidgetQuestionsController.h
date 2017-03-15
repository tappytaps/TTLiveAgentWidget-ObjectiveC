//
//  TTLiveAgentWidgetQuestionsController.h
//  Pods
//
//  Created by Lukas Boura on 22/06/15.
//
//

#import <UIKit/UIKit.h>
#import "TTLiveAgentWidgetSupportTopic.h"
#import "TTLiveAgentWidgetSupportArticle.h"

@class TTLiveAgentWidget;

@interface TTLiveAgentWidgetQuestionsController : UITableViewController

@property (nonatomic, retain) TTLiveAgentWidget *supportWidget;

@property (nonatomic, retain) TTLiveAgentWidgetSupportTopic *topic;
@property (nonatomic, copy) NSArray<TTLiveAgentWidgetSupportArticle *> *articles;

@property (assign) UIColor *tintColor;
@property (assign) UIColor *barColor;
@property (assign) UIColor *titleColor;
@property UIStatusBarStyle statusBarStyle;

@end

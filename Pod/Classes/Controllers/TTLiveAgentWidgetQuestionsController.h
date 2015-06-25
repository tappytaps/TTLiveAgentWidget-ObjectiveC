//
//  TTLiveAgentWidgetQuestionsController.h
//  Pods
//
//  Created by Lukas Boura on 22/06/15.
//
//

#import <UIKit/UIKit.h>
#import "TTLiveAgentWidgetArticleControllerViewController.h"
#import "TTLiveAgentWidgetSupportTopic.h"
#import "TopicQuestionTableViewCell.h"

@class TTLiveAgentWidget;

@interface IconTableViewCell : UITableViewCell

@property (nonatomic, assign) UIImageView *iconView;
@property (nonatomic, assign) UILabel *titleLabel;

@end

@interface TTLiveAgentWidgetQuestionsController : UITableViewController

@property (nonatomic, assign) dispatch_once_t onceLoad;

@property (nonatomic, retain) TTLiveAgentWidget *supportWidget;

@property (nonatomic, retain) TTLiveAgentWidgetSupportTopic *topic;

@property CGFloat contentOffset;

@property (nonatomic, copy) NSArray *articles;

@property (nonatomic, copy) UIColor *tintColor;
@property (nonatomic, copy) UIColor *barColor;
@property (nonatomic, copy) UIColor *titleColor;
@property UIBarStyle barStyle;

@end

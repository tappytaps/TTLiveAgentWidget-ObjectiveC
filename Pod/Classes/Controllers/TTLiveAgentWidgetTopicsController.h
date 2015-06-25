//
//  TTLiveAgentWidgetTopicsController.h
//  Pods
//
//  Created by Lukas Boura on 22/06/15.
//
//

#import <UIKit/UIKit.h>
#import "TTLiveAgentWidget.h"
#import "TTLiveAgentWidgetQuestionsController.h"
#import "TopicQuestionTableViewCell.h"

@interface TTLiveAgentWidgetTopicsController : UITableViewController

@property (nonatomic, strong) TopicQuestionTableViewCell *prototypeCell;

@property (nonatomic, assign) dispatch_once_t onceLoad;

@property (nonatomic, copy) NSArray *topics;
@property (nonatomic, copy) UIColor *tintColor;
@property (nonatomic, copy) UIColor *barColor;
@property (nonatomic, copy) UIColor *titleColor;
@property UIBarStyle barStyle;

@property CGPoint pointNow;
@property CGFloat contentOffset;

@end

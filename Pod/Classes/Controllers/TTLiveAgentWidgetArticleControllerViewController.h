//
//  TTLiveAgentWidgetArticleControllerViewController.h
//  Pods
//
//  Created by Lukas Boura on 22/06/15.
//
//

#import <UIKit/UIKit.h>
#import "TTLiveAgentWidget.h"


@class TTLiveAgentWidgetSupportArticle;

@interface TTLiveAgentWidgetArticleControllerViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, assign) TTLiveAgentWidgetSupportArticle *article;
@property (nonatomic, assign) UIWebView *articleContentWebView;

@end

//
//  TTLiveAgentWidget.h
//  Pods
//
//  Created by Lukas Boura on 22/06/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTLiveAgentWidgetQuestionsController.h"
#import "TTLiveAgentWidgetTopicsController.h"
#import "TTLiveAgentWidgetDataManager.h"
#import "TTLiveAgentWidgetEmailComposer.h"

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

typedef enum : NSUInteger {
    Push,
    Present
} TTLiveAgentWidgetStyle;

@interface TTLiveAgentWidget : NSObject

+ (TTLiveAgentWidget*) sharedInstance;

@property (nonatomic, strong) TTLiveAgentWidgetDataManager *dataManager;
@property (nonatomic, strong) TTLiveAgentWidgetEmailComposer *emailComposer;

//
// Configuration
//
// maxArticleCount - max count of showed articles in topic
// topics - array of topics which filters articles
// supportEmail - email address for support
// supportEmailFooter - dictionary of footer data (key, value)
// spportEmailSubject - email subject for email composer
//
@property int maxArticlesCount;
@property (nonatomic, copy) NSArray *topics;

@property (nonatomic, copy) NSString *supportEmail;
@property (nonatomic, copy) NSString *supportEmailSubject;
@property (nonatomic, copy) NSDictionary *supportEmailFooter;

// navigation bar appereance
@property (nonatomic, copy) UIColor *tintColor;
@property (nonatomic, copy) UIColor *navigationBarColor;
@property (nonatomic, copy) UIColor *titleColor;
@property UIBarStyle statusBarStyle;

//
// Configuration - data manager
//
// API URL - url without slash at the end, e.g. 'http://localhost:9000'
// API Folder ID - id of live agent folder
// API Key - live agent apikey
// API Limit - limit articles from api
//
@property (nonatomic, copy) NSString *apiURL;
@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSNumber *apiFolderId;
@property (nonatomic, copy) NSNumber *apiLimitArticles;

// MARK: - API functions

//
// Primary function for opening widget.
//
// If data manager has any articles and widget has any topics, then open main widget controller.
// If the are no topics or articles then open email composer.
//
- (void)openFromController:(UIViewController *) controller withStyle:(TTLiveAgentWidgetStyle) style;

//
// Secondary function for opening widget.
//
// Allows to open topic questions controller by given keyword.
// If given keyword does not fit any topic act like primary function.
//
- (void)openFromController:(UIViewController *) controller forKeyword:(NSString *) keyword withStyle:(TTLiveAgentWidgetStyle) style;

//
// Open system Email composer
//
- (void)openEmailComposerFromController:(UIViewController *)controller withTopic:(TTLiveAgentWidgetSupportTopic *)topic;

//
// Update articles
//
- (void)updateArticles:(void (^)())onSuccess :(void (^)())onError;

@end
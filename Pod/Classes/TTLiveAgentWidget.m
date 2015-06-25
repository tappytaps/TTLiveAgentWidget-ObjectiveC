//
//  TTLiveAgentWidget.m
//  Pods
//
//  Created by Lukas Boura on 22/06/15.
//
//

#import "TTLiveAgentWidget.h"

@implementation TTLiveAgentWidget

+(TTLiveAgentWidget *)sharedInstance {
    static TTLiveAgentWidget *_instance = nil;
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.dataManager = [[TTLiveAgentWidgetDataManager alloc] init];
        self.emailComposer = [[TTLiveAgentWidgetEmailComposer alloc] init];
        self.maxArticlesCount = 5;
    }
    
    return self;
}

- (NSString *)apiURL {
    return self.dataManager.apiURL;
}

- (void)setApiURL:(NSString *)apiURL {
    self.dataManager.apiURL = apiURL;
}

- (NSString *)apiKey {
    return self.dataManager.apiKey;
}

- (void)setApiKey:(NSString *)apiKey {
    self.dataManager.apiKey = apiKey;
}

- (NSNumber *)apiFolderId {
    return self.dataManager.apiFolderId;
}

- (void)setApiFolderId:(NSNumber *)apiFolderId {
    self.dataManager.apiFolderId = apiFolderId;
}

- (NSNumber *)apiLimitArticles {
    return self.dataManager.apiLimitArticles;
}

- (void)setApiLimitArticles:(NSNumber *)apiLimitArticles {
    self.dataManager.apiLimitArticles = apiLimitArticles;
}

- (void)openFromController:(UIViewController *)controller withStyle:(TTLiveAgentWidgetStyle)style {
    if (self.topics != nil && self.topics.count > 0 && self.dataManager.articles.count > 0) {
        [self showController:[self createTopicsController] fromController:controller withStyle:style];
    } else {
        [self.emailComposer show:controller withTopic:nil];
    }
}

- (void)openFromController:(UIViewController *)controller forKeyword:(NSString *)keyword withStyle:(TTLiveAgentWidgetStyle)style {
    if (self.topics && self.topics.count > 0 &&self.dataManager.articles.count > 0) {
        TTLiveAgentWidgetSupportTopic *filteredTopic = nil;
        
        for (int i = 0; i < self.topics.count; i++) {
            TTLiveAgentWidgetSupportTopic *topic = self.topics[i];
            if (topic.key == keyword) {
                filteredTopic = topic;
                break;
            }
        }
        
        if (filteredTopic) {
            TTLiveAgentWidgetQuestionsController *law = [self createQuestionsControllerWithTopic:filteredTopic];
            [self showController:law fromController:controller withStyle:style];
        } else {
            [self showController:[self createTopicsController] fromController:controller withStyle:style];
        }
        
    } else {
        [self openEmailComposerFromController:controller withTopic:nil];
    }
}

- (void)openEmailComposerFromController:(UIViewController *)controller withTopic:(TTLiveAgentWidgetSupportTopic *)topic {
    [self.emailComposer show:controller withTopic:topic];
}

- (void)updateArticles:(void (^)())onSuccess :(void (^)())onError {
    [self.dataManager updateArticles:onSuccess :onError];
}

- (void)showController:(UIViewController *) vc fromController:(UIViewController *) fromController withStyle:(TTLiveAgentWidgetStyle) style {
    
    UINavigationController *navCtrl = nil;
    
    switch (style) {
        case Push:
        
            if (fromController.navigationController) {
                [fromController.navigationController pushViewController:vc animated:YES];
            }
            
            break;
            
        case Present:
            
            navCtrl = [[UINavigationController alloc] initWithRootViewController:vc];
            [fromController presentViewController:navCtrl animated:YES completion:nil];
            
            break;
            
        default:
            break;
    }
}

- (TTLiveAgentWidgetQuestionsController*) createQuestionsControllerWithTopic: (TTLiveAgentWidgetSupportTopic *) topic {
    TTLiveAgentWidgetQuestionsController *lawq = [[[TTLiveAgentWidgetQuestionsController alloc] init] autorelease];
    lawq.topic = topic;
    lawq.tintColor = self.tintColor;
    lawq.barColor = self.navigationBarColor;
    lawq.titleColor = self.titleColor;
    lawq.barStyle = self.statusBarStyle;
    return lawq;
}

- (TTLiveAgentWidgetTopicsController *) createTopicsController {
    TTLiveAgentWidgetTopicsController *law = [[[TTLiveAgentWidgetTopicsController alloc] init] autorelease];
    law.topics = self.topics;
    law.tintColor = self.tintColor;
    law.barColor = self.navigationBarColor;
    law.titleColor = self.titleColor;
    law.barStyle = self.statusBarStyle;
    return law;
}

@end

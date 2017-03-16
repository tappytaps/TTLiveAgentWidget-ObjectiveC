//
//  TTLiveAgentWidget.m
//  Pods
//
//  Created by Lukas Boura on 22/06/15.
//
//

#import "TTLiveAgentWidget.h"

@implementation TTLiveAgentWidget

+ (TTLiveAgentWidget *)sharedInstance {
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
        self.maxArticlesCount = 50;
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

- (NSString *)apiFolderId {
    return self.dataManager.apiFolderId;
}

- (void)setApiFolderId:(NSString *)apiFolderId {
    self.dataManager.apiFolderId = apiFolderId;
}

- (NSNumber *)apiLimitArticles {
    return self.dataManager.apiLimitArticles;
}

- (void)setApiLimitArticles:(NSNumber *)apiLimitArticles {
    self.dataManager.apiLimitArticles = apiLimitArticles;
}

- (void)openFromController:(UIViewController *)controller withPresentationStyle:(TTLiveAgentWidgetPresentationStyle)presentationStyle {
    if (self.topics && self.topics.count > 0 && self.dataManager.articles.count > 0) {
        [self showController:[self createTopicsController] fromController:controller withStyle:presentationStyle];
    } else {
        [self.emailComposer showFromController:controller withTopic:nil];
    }
}

- (void)openFromController:(UIViewController *)controller forKeyword:(NSString *)keyword withPresentationStyle:(TTLiveAgentWidgetPresentationStyle)presentationStyle {
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
            [self showController:law fromController:controller withStyle:presentationStyle];
        } else {
            [self showController:[self createTopicsController] fromController:controller withStyle:presentationStyle];
        }

    } else {
        [self openEmailComposerFromController:controller withTopic:nil];
    }
}

- (void)openEmailComposerFromController:(UIViewController *)controller withTopic:(TTLiveAgentWidgetSupportTopic *)topic {
    [self.emailComposer showFromController:controller withTopic:topic];
}

- (void)updateArticlesOnSuccess:(void (^)())onSuccess onError:(void (^)())onError {
    [self.dataManager updateArticlesOnSuccess:onSuccess onError:onError];
}

- (void)showController:(UIViewController *)vc fromController:(UIViewController *)fromController withStyle:(TTLiveAgentWidgetPresentationStyle)style {

    switch (style) {
        case TTLiveAgentWidgetPresentationStylePush:
            if (fromController.navigationController) {
                [fromController.navigationController pushViewController:vc animated:YES];
            }
            break;

        case TTLiveAgentWidgetPresentationStylePresent: {
            
            TTLiveAgentWidgetNavigationController *navCtrl = [[TTLiveAgentWidgetNavigationController alloc] initWithRootViewController:vc];
            navCtrl.modalPresentationStyle = UIModalPresentationFormSheet;
            
            [fromController presentViewController:navCtrl animated:YES completion:nil];
            
        }
            break;
    }
}

- (TTLiveAgentWidgetQuestionsController*)createQuestionsControllerWithTopic: (TTLiveAgentWidgetSupportTopic *)topic {
    TTLiveAgentWidgetQuestionsController *lawq = [[TTLiveAgentWidgetQuestionsController alloc] init];
    lawq.topic = topic;
    lawq.tintColor = self.tintColor;
    lawq.barColor = self.navigationBarColor;
    lawq.titleColor = self.titleColor;
    lawq.statusBarStyle = self.statusBarStyle;
    return lawq;
}

- (TTLiveAgentWidgetTopicsController *)createTopicsController {
    TTLiveAgentWidgetTopicsController *law = [[TTLiveAgentWidgetTopicsController alloc] init];
    law.topics = self.topics;
    law.tintColor = self.tintColor;
    law.barColor = self.navigationBarColor;
    law.titleColor = self.titleColor;
    law.statusBarStyle = self.statusBarStyle;
    return law;
}

@end

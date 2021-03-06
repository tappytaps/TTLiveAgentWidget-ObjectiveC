//
//  TTLiveAgentWidgetDataManager.h
//  Pods
//
//  Created by Lukas Boura on 24/06/15.
//
//

#import <Foundation/Foundation.h>
#import "TTLiveAgentWidgetSupportArticle.h"

@interface TTLiveAgentWidgetDataManager : NSObject

@property (nonatomic, copy) NSString *apiURL;
@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *apiFolderId;
@property (nonatomic, copy) NSNumber *apiLimitArticles;

@property (nonatomic, copy) NSArray *articles;
@property (nonatomic, copy) NSString *articleMD5;

- (void)updateArticlesOnSuccess:(void (^)())onSuccess onError:(void (^)())onError;

- (NSArray<TTLiveAgentWidgetSupportArticle *> *)getArticlesByKeyword:(NSString *)keyword;
- (NSArray<TTLiveAgentWidgetSupportArticle *> *)getArticlesByKeyword:(NSString *)keyword orderBy:(NSArray<NSSortDescriptor *> *)sortDescriptors;

@end

//
//  TTLiveAgentWidgetDataManager.m
//  Pods
//
//  Created by Lukas Boura on 24/06/15.
//
//

#import "TTLiveAgentWidgetDataManager.h"

@implementation TTLiveAgentWidgetDataManager

NSString * const kArticleMD5KeyIdentifier = @"com.tappytaps.support.widget.articlemd5";
NSString * const kArticlesKeyIdentifier = @"com.tappytaps.support.widget.articles";

- (NSArray *)articles {
    return [self loadArticles];
}

- (NSString *)articleMD5 {
    return [[NSUserDefaults standardUserDefaults]stringForKey:kArticleMD5KeyIdentifier];
}

- (void)setArticleMD5:(NSString *)articleMD5 {
    [[NSUserDefaults standardUserDefaults]setObject:articleMD5 forKey:kArticleMD5KeyIdentifier];
}

- (void)updateArticlesOnSuccess:(void (^)())onSuccess onError:(void (^)())onError {

    if (!self.apiURL) {
        NSLog(@"TTLiveAgentWidget - API URL is missing. Can't request server.");
        return;
    }

    if (!self.apiFolderId) {
        NSLog(@"TTLiveAgentWidget - Folder ID is missing. Can't request server.");
        return;
    }

    NSString *url = [NSString stringWithFormat:@"%@/api/knowledgebase/articles?parent_id=%@", self.apiURL, self.apiFolderId];

    NSString *hash = self.articleMD5;
    NSArray *articles = [self loadArticles];

    if (hash && articles.count > 0) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&hash=%@", hash]];
    }

    if (self.apiKey) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&apiKey=%@", self.apiKey]];
        NSLog(@"TTLiveAgentWidget - Warning! Your API key is contained in request URL. For security reasons you should use some proxy server.");
    }

    if (self.apiLimitArticles) {
        url = [url stringByAppendingString: [NSString stringWithFormat:@"&limit=%@", self.apiLimitArticles]];
    }

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = [NSURL URLWithString:url];

    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }

        if (((NSHTTPURLResponse *)response).statusCode == 200) {

            NSError *error = nil;

            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

            // Check if data up to date
            BOOL upToDate = [(NSNumber *)[json objectForKey:@"up-to-date"] boolValue];
            if (upToDate) {
                NSLog(@"TTLiveAgentWidget - support articles are up to date.");
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (onSuccess) {
                        onSuccess();
                    }
                });
                return;
            }

            // Else parse articles
            NSDictionary *response = json[@"response"];
            if (response) {
                NSArray *articles = response[@"articles"];
                NSString *hash = response[@"hash"];

                NSMutableArray *newArticles = [NSMutableArray array];

                if (articles) {

                    for (int i = 0; i < articles.count; i++) {

                        NSDictionary *articleDict = articles[i];
                        NSString *title = articleDict[@"title"];
                        NSString *content = articleDict[@"content"];
                        NSString *keywords = articleDict[@"keywords"];
                        int order = ((NSNumber *)articleDict[@"rorder"]).intValue;

                        if (title && content && keywords) {
                            TTLiveAgentWidgetSupportArticle *article = [[TTLiveAgentWidgetSupportArticle alloc] init];
                            article.title = title;
                            article.content = content;
                            article.keywords = keywords;

                            if (order) {
                                article.order = order;
                            } else {
                                article.order = 0;
                            }
                            
                            [newArticles addObject:article];
                            
                        }
                    }

                    [self saveArticles:newArticles];

                    NSLog(@"TTLiveAgentWidget - new articles saved");

                    if (hash) {
                        self.articleMD5 = hash;
                    }

                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (onSuccess) {
                            onSuccess();
                        }
                    });


                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (onError) {
                            onError();
                        }
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (onError) {
                        onError();
                    }
                });
            }

        } else {

            NSLog(@"TTLiveAgentWidget - request URL: %@", ((NSHTTPURLResponse *)response).URL);
            NSLog(@"TTLiveAgentWidget - server response status: %ld", ((NSHTTPURLResponse *)response).statusCode);

            dispatch_async(dispatch_get_main_queue(), ^{
                if (onError) {
                    onError();
                }
            });
        }

    }];

}

- (void)saveArticles:(NSArray *) articles {

    NSMutableArray *dict = [NSMutableArray array];

    if (articles) {
        for (int i = 0; i < articles.count; i++) {
            TTLiveAgentWidgetSupportArticle *article = articles[i];
            [dict addObject:@{
                             @"title": article.title,
                             @"content": article.content,
                             @"keywords": article.keywords,
                             @"order": [NSNumber numberWithInt:article.order]
                             }];
        }
        [dict writeToFile:[self articlesPlistPath] atomically:YES];
    }

}

- (NSArray<TTLiveAgentWidgetSupportArticle *> *)getArticlesByKeyword:(NSString *)keyword {
    return [self getArticlesByKeyword:keyword orderBy:nil];
}

- (NSArray<TTLiveAgentWidgetSupportArticle *> *)getArticlesByKeyword:(NSString *)keyword orderBy:(NSArray<NSSortDescriptor *> *)sortDescriptors {
    
    NSMutableArray *articles = [NSMutableArray array];
    
    NSArray *storedArticles = self.articles;
    
    for (int i = 0; i < storedArticles.count; i++) {
        TTLiveAgentWidgetSupportArticle *article = storedArticles[i];
        NSRange match = [article.keywords rangeOfString:keyword];
        if (match.location != NSNotFound) {
            [articles addObject:article];
        }
    }
    
    if (sortDescriptors) {
        NSArray *sortedArticles = [articles sortedArrayUsingDescriptors:sortDescriptors];
        return sortedArticles;
    }
    
    return articles;
    
}

- (NSArray *)loadArticles {
    NSArray *results = [NSArray arrayWithContentsOfFile:[self articlesPlistPath]];
    if (results) {
        NSMutableArray *articles = [NSMutableArray array];
        for (int i = 0; i < results.count; i++) {
            NSDictionary *articleDict = results[i];

            NSString *title = articleDict[@"title"];
            NSString *content = articleDict[@"content"];
            NSString *keywords = articleDict[@"keywords"];
            NSNumber *order = ((NSNumber *) articleDict[@"order"]);

            if (title != nil && content != nil && keywords != nil && order != nil) {
                TTLiveAgentWidgetSupportArticle *article = [[TTLiveAgentWidgetSupportArticle alloc] init];
                article.title = title;
                article.content = content;
                article.keywords = keywords;
                article.order = order.intValue;
                [articles addObject:article];
            }
        }
        return articles;
    } else {
        return @[];
    }

}

- (BOOL)hasArticles {
    NSArray *result = [NSArray arrayWithContentsOfFile:[self articlesPlistPath]];
    return result != nil;
}

- (NSString *)articlesPlistPath {

    // get App's /Library/Caches directory
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

    // create path to plist file
    NSString *articlesPlistPath = [cachesPath stringByAppendingString:@"/liveAgentArticles.plist"];

    return articlesPlistPath;

}

@end

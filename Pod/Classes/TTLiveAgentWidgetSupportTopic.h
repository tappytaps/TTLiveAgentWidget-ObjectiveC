//
//  TTLiveAgentWidgetSupportTopic.h
//  Pods
//
//  Created by Lukas Boura on 24/06/15.
//
//

#import <Foundation/Foundation.h>

@interface TTLiveAgentWidgetSupportTopic : NSObject

@property (nonatomic, assign) NSString *key;
@property (nonatomic, assign) NSString *title;

- (id)initWithKey:(NSString *)key :(NSString *)title;

@end

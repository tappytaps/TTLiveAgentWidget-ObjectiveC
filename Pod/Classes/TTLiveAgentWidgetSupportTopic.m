//
//  TTLiveAgentWidgetSupportTopic.m
//  Pods
//
//  Created by Lukas Boura on 24/06/15.
//
//

#import "TTLiveAgentWidgetSupportTopic.h"

@implementation TTLiveAgentWidgetSupportTopic

- (id)initWithKey:(NSString *)key :(NSString *)title {
    self = [super init];
    if (self) {
        _key = key;
        _title = title;
    }
    return self;
}

@end

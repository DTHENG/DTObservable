//
// Created by Daniel Thengvall on 3/2/15.
// Copyright (c) 2015 DTHENG. All rights reserved.
//

#import "ExampleSubscriber.h"


@implementation ExampleSubscriber

- (void)complete:(NSDictionary *)value {

    BOOL fourTwenty = [value[@"4"] intValue] == 20;

    NSLog(@"Does 4 == 20? %@", fourTwenty ? @"YES" : @"NO");
}

- (void)error:(NSError *)error {
    NSLog(@"%@", error);
}

@end
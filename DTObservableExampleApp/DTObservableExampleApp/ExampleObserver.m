//
// Created by Daniel Thengvall on 3/2/15.
// Copyright (c) 2015 DTHENG. All rights reserved.
//

#import "ExampleObserver.h"
#import "ExampleSubscriber.h"


@implementation ExampleObserver

- (void (^)(DTSubscriber *))new {

    return ^(DTSubscriber *subscriber) {

        NSDictionary *value = @{@"4": @20};

        // Lets pretend something cpu intensive happens here
        [NSThread sleepForTimeInterval:3.f];

        [subscriber complete:value];
    };
}

@end
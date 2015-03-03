//
//  DTSubscriber.m
//  DTSubscriber
//
//  Created by Daniel Thengvall on 3/2/15.
//  Copyright (c) 2015 DTHENG. All rights reserved.
//

#import "DTSubscriber.h"

@implementation DTSubscriber {
    void (^complete)(id);
    void (^error)(id);
}

- (void)complete:(id)object {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self onComplete]) {
            [self onComplete](object);
        }
    });
}

- (void)error:(id)object {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self onError]) {
            [self onError](object);
        }
    });
}

- (void (^)(id))onComplete {
    return complete;
}

- (void (^)(id))onError {
    return error;
}

- (DTSubscriber *)init:(void (^)(id))onComplete onError:(void (^)(id))onError {
    complete = onComplete;
    error = onError;
    return self;
}

@end

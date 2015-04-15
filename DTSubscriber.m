//
//  DTSubscriber.m
//  DTSubscriber
//
//  Created by Daniel Thengvall on 3/2/15.
//  Copyright (c) 2015 DTHENG. All rights reserved.
//

#import "DTSubscriber.h"

@implementation DTSubscriber {
    void (^complete)();
    void (^error)(id);
    void (^next)(id);
}

- (void)complete {
    if ( ! [NSThread currentThread].isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self onComplete]) {
                [self onComplete];
            }
        });
    } else {
        if ([self onComplete]) {
            [self onComplete];
        }
    }
}

- (void)error:(id)object {
    if ( ! [NSThread currentThread].isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self onError]) {
                [self onError](object);
            }
        });
    } else {
        if ([self onError]) {
            [self onError](object);
        }
    }
}

- (void)next:(id)object {
    if ([self onNext]) {
        [self onNext](object);
    }
}

- (void (^)())onComplete {
    return complete;
}

- (void (^)(id))onError {
    return error;
}

- (void (^)(id))onNext {
    return next;
}

- (DTSubscriber *)init:(void (^)(id))onNext onComplete:(void (^)())onComplete onError:(void (^)(id))onError {
    next = onNext;
    complete = onComplete;
    error = onError;
    return self;
}

@end

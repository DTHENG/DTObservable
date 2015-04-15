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

- (void)complete {
    if ( ! [NSThread currentThread].isMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleResults];
        });
    } else {
        [self handleResults];
    }
}

- (void)handleResults {
    if ([self onComplete]) {
        if (_results != nil) {
            if (_results.count == 1) {
                [self onComplete](_results[0]);
            } else {
                [self onComplete](_results);
            }
        } else {
            [self onComplete](nil);
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
    if (_results == nil) {
        _results = [[NSArray alloc] init];
    }
    NSMutableArray *mResults = [_results mutableCopy];
    [mResults addObject:object];
    _results = [[NSArray alloc] initWithArray:mResults];
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

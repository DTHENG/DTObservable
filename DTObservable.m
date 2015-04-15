//
//  DTObservable.m
//  DTObservable
//
//  Created by Daniel Thengvall on 3/2/15.
//  Copyright (c) 2015 DTHENG. All rights reserved.
//

#import "DTObservable.h"

@implementation DTObservable {
    void (^observe)(DTSubscriber *);
    BOOL async;
}

- (void)subscribe:(DTSubscriber *)subscriber {
    if (async) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSThread currentThread] setName:@"DTObservable"];
            [self new](subscriber);
        });
    } else {
        [self new](subscriber);
    }
}

- (void (^)(DTSubscriber *))new {
    return observe;
}

- (DTObservable *)init:(void (^)(DTSubscriber *))observable {
    observe = observable;
    return self;
}

- (DTObservable *)newThread {
    async = YES;
    return self;
}

@end

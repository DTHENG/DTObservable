//
//  DTObservable.m
//  DTObservable
//
//  Created by Daniel Thengvall on 3/2/15.
//  Copyright (c) 2015 DTHENG. All rights reserved.
//

#import "DTObservable.h"
#import "DTSubscriber.h"

@implementation DTObservable {
    void (^observe)(DTSubscriber *);
}

- (void)subscribe:(DTSubscriber *)subscriber {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self new](subscriber);
    });
}

- (void (^)(DTSubscriber *))new {
    return observe;
}

- (DTObservable *)init:(void (^)(DTSubscriber *))observable {
    observe = observable;
    return self;
}

@end

//
//  DTObservable.h
//  DTObservable
//
//  Created by Daniel Thengvall on 3/2/15.
//  Copyright (c) 2015 DTHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTSubscriber.h"    

@interface DTObservable : NSObject 

- (void)subscribe:(DTSubscriber *)subscriber;

- (void (^)(DTSubscriber *))new;

- (DTObservable *)init:(void (^)(DTSubscriber *))observable;

+ (DTObservable *)merge:(DTObservable *)observable,...;

- (void)newThread;

@end

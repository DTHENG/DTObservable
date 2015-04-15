//
//  DTSubscriber.h
//  DTSubscriber
//
//  Created by Daniel Thengvall on 3/2/15.
//  Copyright (c) 2015 DTHENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTSubscriber : NSObject

@property NSArray *results;

- (void)next:(id)object;
- (void)complete;
- (void)error:(id)object;
- (DTSubscriber *)init:(void (^)(id))onComplete onError:(void (^)(id))onError;

@end

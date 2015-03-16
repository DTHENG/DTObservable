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

+ (DTObservable *)merge:(DTObservable *)observable,... {
    NSMutableArray *observables = [[NSMutableArray alloc] init];
    va_list args;
    va_start(args, observable);

    /**
    * EXCEPTION ALERT!
    * If you find you're getting an exception here it's probably
    * because you have omitted nil at the end of your results set.
    * Like so:
    * [DTObservable merge:[[DTObservable ...]], nil];
    */
    for (DTObservable *arg = observable; arg != nil; arg = va_arg(args, DTObservable *)) {

        [observables addObject:arg];
    }
    va_end(args);
    return [self initObservableMerge:observables];
}

+ (DTObservable *)initObservableMerge:(NSArray *)observables {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        [[self buildResultsSet:observables] subscribe:[[DTSubscriber alloc] init:^(NSArray *results) {
            [subscriber complete:results];
        } onError:^(NSError *mergeError) {
            [subscriber error:mergeError];
        }]];
    }];
}

+ (DTObservable *)buildResultsSet:(NSArray *)observables {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        NSMutableArray *mResults = [[NSMutableArray alloc] init];
        for (NSUInteger j = 0; j < observables.count; j++) {
            mResults[j] = @NO;
        }
        [[self processMergeObservables:observables :mResults] subscribe:[[DTSubscriber alloc] init:^(NSArray *resultsSet) {
            [subscriber complete:resultsSet];
        } onError:^(NSError *error) {
            [subscriber error:error];
        }]];
    }];
}

+ (DTObservable *)processMergeObservables:(NSArray *)observables :(NSMutableArray *)resultsSet {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        for (NSUInteger i = 0; i < observables.count; i++) {
            [observables[i] subscribe:[[DTSubscriber alloc] init:^(NSDictionary *result) {
                resultsSet[i] = result;
                [[self isMergeMissingValues:resultsSet] subscribe:[[DTSubscriber alloc] init:^(NSNumber *isResultsSetComplete) {
                    if ([isResultsSetComplete boolValue]) {
                        [subscriber complete:[[NSArray alloc] initWithArray:resultsSet]];
                    }
                } onError:^(NSError *error) {
                    [subscriber error:error];
                }]];
            } onError:^(NSError *error) {
                [subscriber error:error];
            }]];
        }
    }];
}

+ (DTObservable *)isMergeMissingValues:(NSArray *)results {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        @try {
            BOOL missingValues = NO;
            for (NSUInteger k = 0; k < results.count; k++) {
                if ([results[k] isKindOfClass:[NSNumber class]] &&
                        ! [results[k] boolValue]) {
                    missingValues = YES;
                }
            }
            [subscriber complete:@( ! missingValues)];
        } @catch (NSException *e) {
            [subscriber error:[NSError errorWithDomain:@"DTObservable" code:-1 userInfo:@{@"message": [NSString stringWithFormat:@"%@", e]}]];
        }
    }];
}

- (void)newThread {
    async = YES;
}

@end

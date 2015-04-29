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

- (DTObservable *)flatMap:(id (^)(id))block {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        DTSubscriber *intermediarySubscriber = [[DTSubscriber alloc] init:^(id object) {
            [subscriber next:block(object)];
            [subscriber complete];
        } onError:^(NSError *error) {
            [subscriber error:error];
        }];
        if (async) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self new](intermediarySubscriber);
            });
        } else {
            [self new](intermediarySubscriber);
        }
    }];
}

- (DTObservable *)filter:(BOOL (^)(id))block {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        DTSubscriber *intermediarySubscriber = [[DTSubscriber alloc] init:^(id object) {
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray *array = (NSArray *)object;
                for (NSUInteger i = 0; i < array.count; i++) {
                    if (block(array[i])) {
                        [subscriber next:array[i]];
                    }
                }
            } else {
                if (block(object)) {
                    [subscriber next:object];
                }
            }
            [subscriber complete];
        } onError:^(NSError *error) {
            [subscriber error:error];
        }];
        if (async) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self new](intermediarySubscriber);
            });
        } else {
            [self new](intermediarySubscriber);
        }
    }];
}

+ (DTObservable *)zip:(DTObservable *)observable1 :(DTObservable *)observable2 :(id (^)(id, id))block {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        [observable1 subscribe:[[DTSubscriber alloc] init:^(id objectFromObservable1) {
            [observable2 subscribe:[[DTSubscriber alloc] init:^(id objectFromObservable2) {
                [subscriber next:block(objectFromObservable1, objectFromObservable2)];
                [subscriber complete];
            } onError:^(NSError *error) {
                [subscriber error:error];
            }]];
        } onError:^(NSError *error) {
            [subscriber error:error];
        }]];
    }];
}

+ (DTObservable *)zip:(DTObservable *)observable1 :(DTObservable *)observable2 :(DTObservable *)observable3
        :(id (^)(id, id, id))block {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        [observable1 subscribe:[[DTSubscriber alloc] init:^(id objectFromObservable1) {
            [observable2 subscribe:[[DTSubscriber alloc] init:^(id objectFromObservable2) {
                [observable3 subscribe:[[DTSubscriber alloc] init:^(id objectFromObservable3) {
                    [subscriber next:block(objectFromObservable1, objectFromObservable2, objectFromObservable3)];
                    [subscriber complete];
                } onError:^(NSError *error) {
                    [subscriber error:error];
                }]];
            } onError:^(NSError *error) {
                [subscriber error:error];
            }]];
        } onError:^(NSError *error) {
            [subscriber error:error];
        }]];
    }];
}

+ (DTObservable *)zip:(DTObservable *)observable1 :(DTObservable *)observable2 :(DTObservable *)observable3
        :(DTObservable *)observable4 :(id (^)(id, id, id, id))block {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        [observable1 subscribe:[[DTSubscriber alloc] init:^(id objectFromObservable1) {
            [observable2 subscribe:[[DTSubscriber alloc] init:^(id objectFromObservable2) {
                [observable3 subscribe:[[DTSubscriber alloc] init:^(id objectFromObservable3) {
                    [observable4 subscribe:[[DTSubscriber alloc] init:^(id objectFromObservable4) {
                        [subscriber next:block(objectFromObservable1, objectFromObservable2, objectFromObservable3,
                                objectFromObservable4)];
                        [subscriber complete];
                    } onError:^(NSError *error) {
                        [subscriber error:error];
                    }]];
                } onError:^(NSError *error) {
                    [subscriber error:error];
                }]];
            } onError:^(NSError *error) {
                [subscriber error:error];
            }]];
        } onError:^(NSError *error) {
            [subscriber error:error];
        }]];
    }];
}

+ (DTObservable *)zip:(DTObservable *)observable1 :(DTObservable *)observable2 :(DTObservable *)observable3
        :(DTObservable *)observable4 :(DTObservable *)observable5 :(id (^)(id, id, id, id, id))block {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        [observable1 subscribe:[[DTSubscriber alloc] init:^(id objectFromObservable1) {
            [observable2 subscribe:[[DTSubscriber alloc] init:^(id objectFromObservable2) {
                [observable3 subscribe:[[DTSubscriber alloc] init:^(id objectFromObservable3) {
                    [observable4 subscribe:[[DTSubscriber alloc] init:^(id objectFromObservable4) {
                        [observable5 subscribe:[[DTSubscriber alloc] init:^(id objectFromObservable5) {
                            [subscriber next:block(objectFromObservable1, objectFromObservable2, objectFromObservable3,
                                    objectFromObservable4, objectFromObservable5)];
                            [subscriber complete];
                        } onError:^(NSError *error) {
                            [subscriber error:error];
                        }]];
                    } onError:^(NSError *error) {
                        [subscriber error:error];
                    }]];
                } onError:^(NSError *error) {
                    [subscriber error:error];
                }]];
            } onError:^(NSError *error) {
                [subscriber error:error];
            }]];
        } onError:^(NSError *error) {
            [subscriber error:error];
        }]];
    }];
}

@end

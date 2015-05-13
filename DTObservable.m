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

- (DTObservable *)flatMap:(DTObservable * (^)(id))block {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        DTSubscriber *intermediarySubscriber = [[DTSubscriber alloc] init:^(id object) {
            [block(object) subscribe:subscriber];
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

+ (DTObservable *)create:(void (^)(DTSubscriber *))observer {
    return [[DTObservable alloc] init:observer];
}

+ (DTObservable *)zip:(DTObservable *)observable1 :(DTObservable *)observable2 :(id (^)(id, id))block {
    return [observable1 flatMap:^(id object1) {
        return [observable2 flatMap:^(id object2) {
            return [DTObservable just:block(object1, object2)];
        }];
    }];
}

+ (DTObservable *)zip:(DTObservable *)observable1 :(DTObservable *)observable2 :(DTObservable *)observable3
        :(id (^)(id, id, id))block {
    return [observable1 flatMap:^(id object1) {
        return [observable2 flatMap:^(id object2) {
            return [observable3 flatMap:^(id object3) {
                return [DTObservable just:block(object1, object2, object3)];
            }];
        }];
    }];
}

+ (DTObservable *)zip:(DTObservable *)observable1 :(DTObservable *)observable2 :(DTObservable *)observable3
        :(DTObservable *)observable4 :(id (^)(id, id, id, id))block {
    return [observable1 flatMap:^(id object1) {
        return [observable2 flatMap:^(id object2) {
            return [observable3 flatMap:^(id object3) {
                return [observable4 flatMap:^(id object4) {
                    return [DTObservable just:block(object1, object2, object3, object4)];
                }];
            }];
        }];
    }];
}

+ (DTObservable *)zip:(DTObservable *)observable1 :(DTObservable *)observable2 :(DTObservable *)observable3
        :(DTObservable *)observable4 :(DTObservable *)observable5 :(id (^)(id, id, id, id, id))block {
    return [observable1 flatMap:^(id object1) {
        return [observable2 flatMap:^(id object2) {
            return [observable3 flatMap:^(id object3) {
                return [observable4 flatMap:^(id object4) {
                    return [observable5 flatMap:^(id object5) {
                        return [DTObservable just:block(object1, object2, object3, object4, object5)];
                    }];
                }];
            }];
        }];
    }];
}

+ (DTObservable *)zip:(DTObservable *)observable1 :(DTObservable *)observable2 :(DTObservable *)observable3
                     :(DTObservable *)observable4 :(DTObservable *)observable5 :(DTObservable *)observable6
                     :(id (^)(id, id, id, id, id, id))block {
    return [observable1 flatMap:^(id object1) {
        return [observable2 flatMap:^(id object2) {
            return [observable3 flatMap:^(id object3) {
                return [observable4 flatMap:^(id object4) {
                    return [observable5 flatMap:^(id object5) {
                        return [observable6 flatMap:^(id object6) {
                            return [DTObservable just:block(object1, object2,
                                                            object3, object4, object5, object6)];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

+ (DTObservable *)zip:(DTObservable *)observable1 :(DTObservable *)observable2 :(DTObservable *)observable3
                     :(DTObservable *)observable4 :(DTObservable *)observable5 :(DTObservable *)observable6
                     :(DTObservable *)observable7 :(id (^)(id, id, id, id, id, id, id))block {
    return [observable1 flatMap:^(id object1) {
        return [observable2 flatMap:^(id object2) {
            return [observable3 flatMap:^(id object3) {
                return [observable4 flatMap:^(id object4) {
                    return [observable5 flatMap:^(id object5) {
                        return [observable6 flatMap:^(id object6) {
                            return [observable7 flatMap:^(id object7) {
                                return [DTObservable just:block(object1, object2, object3,
                                                                object4, object5, object6, object7)];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

+ (DTObservable *)zip:(DTObservable *)observable1 :(DTObservable *)observable2 :(DTObservable *)observable3
                     :(DTObservable *)observable4 :(DTObservable *)observable5 :(DTObservable *)observable6
                     :(DTObservable *)observable7 :(DTObservable *)observable8 :(id (^)(id, id, id, id, id, id, id, id))block {
    return [observable1 flatMap:^(id object1) {
        return [observable2 flatMap:^(id object2) {
            return [observable3 flatMap:^(id object3) {
                return [observable4 flatMap:^(id object4) {
                    return [observable5 flatMap:^(id object5) {
                        return [observable6 flatMap:^(id object6) {
                            return [observable7 flatMap:^(id object7) {
                                return [observable8 flatMap:^(id object8) {
                                    return [DTObservable just:block(object1, object2, object3,
                                                                    object4, object5, object6, object7, object8)];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

+ (DTObservable *)zip:(DTObservable *)observable1 :(DTObservable *)observable2 :(DTObservable *)observable3
                     :(DTObservable *)observable4 :(DTObservable *)observable5 :(DTObservable *)observable6
                     :(DTObservable *)observable7 :(DTObservable *)observable8 :(DTObservable *)observable9
                     :(id (^)(id, id, id, id, id, id, id, id, id))block {
    return [observable1 flatMap:^(id object1) {
        return [observable2 flatMap:^(id object2) {
            return [observable3 flatMap:^(id object3) {
                return [observable4 flatMap:^(id object4) {
                    return [observable5 flatMap:^(id object5) {
                        return [observable6 flatMap:^(id object6) {
                            return [observable7 flatMap:^(id object7) {
                                return [observable8 flatMap:^(id object8) {
                                    return [observable9 flatMap:^(id object9) {
                                        return [DTObservable just:block(object1, object2, object3,
                                                                        object4, object5, object6, object7,
                                                                        object8, object9)];
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

+ (DTObservable *)zip:(DTObservable *)observable1 :(DTObservable *)observable2 :(DTObservable *)observable3
                     :(DTObservable *)observable4 :(DTObservable *)observable5 :(DTObservable *)observable6
                     :(DTObservable *)observable7 :(DTObservable *)observable8 :(DTObservable *)observable9
                     :(DTObservable *)observable10 :(id (^)(id, id, id, id, id, id, id, id, id, id))block {
    return [observable1 flatMap:^(id object1) {
        return [observable2 flatMap:^(id object2) {
            return [observable3 flatMap:^(id object3) {
                return [observable4 flatMap:^(id object4) {
                    return [observable5 flatMap:^(id object5) {
                        return [observable6 flatMap:^(id object6) {
                            return [observable7 flatMap:^(id object7) {
                                return [observable8 flatMap:^(id object8) {
                                    return [observable9 flatMap:^(id object9) {
                                        return [observable10 flatMap:^(id object10) {
                                            return [DTObservable just:block(object1, object2, object3,
                                                                            object4, object5, object6, object7,
                                                                            object8, object9, object10)];
                                        }];
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

+ (DTObservable *)just:(id)object {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        if (object != nil) {
            [subscriber next:object];
        }
        [subscriber complete];
    }];
}

- (void)subscribe {
    [self new]([[DTSubscriber alloc] init:^(id object) {} onError:^(NSError *error) {
        NSLog(@"ERROR: %@", error);
    }]);
}

+ (DTObservable *)empty {
    return [DTObservable just:nil];
}

+ (DTObservable *)concat:(NSArray *)arrayOfObservables {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        for (NSUInteger i = 0; i < arrayOfObservables.count; i++) {
            [arrayOfObservables[i] subscribe:[[DTSubscriber alloc] init:^(id object) {
                [subscriber next:object];
            } onError:^(NSError *error) {
                [subscriber error:error];
            }]];
        }
        [subscriber complete];
    }];
}

@end

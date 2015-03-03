//
//  ViewController.m
//  DTObservableExampleApp
//
//  Created by Daniel Thengvall on 3/2/15.
//  Copyright (c) 2015 DTHENG. All rights reserved.
//

#import "ViewController.h"
#import "DTObservable.h"
#import "ExampleObserver.h"
#import "ExampleSubscriber.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        NSDictionary *value = @{@"4": @20};

        // Lets pretend something cpu intensive happens here
        [NSThread sleepForTimeInterval:1.f];
        [subscriber complete:value];
    }] subscribe:[[DTSubscriber alloc] init:^(NSDictionary *value) {
        BOOL fourTwenty = [value[@"4"] intValue] == 20;
        NSLog(@"Does 4 == 20? %@", fourTwenty ? @"YES" : @"NO");
    } onError:^(NSError *error) {
        NSLog(@"%@", error);
    }]];

    // This can also be written like this:
    [[self exampleObservable] subscribe:[self exampleSubscriber]];

    // or like this:
    [[[ExampleObserver alloc] init] subscribe:[[ExampleSubscriber alloc] init]];
}

- (DTObservable *)exampleObservable {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        NSDictionary *value = @{@"4": @20};

        // Lets pretend something cpu intensive happens here
        [NSThread sleepForTimeInterval:2.f];
        [subscriber complete:value];
    }];
}

- (DTSubscriber *)exampleSubscriber {
    return [[DTSubscriber alloc] init:^(NSDictionary *value) {
        BOOL fourTwenty = [value[@"4"] intValue] == 20;
        NSLog(@"Does 4 == 20? %@", fourTwenty ? @"YES" : @"NO");
    } onError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end

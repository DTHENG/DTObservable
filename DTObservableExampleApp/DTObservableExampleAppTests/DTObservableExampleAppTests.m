//
//  DTObservableExampleAppTests.m
//  DTObservableExampleAppTests
//
//  Created by Daniel Thengvall on 3/2/15.
//  Copyright (c) 2015 DTHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <DTObservable/DTObservable.h>

@interface DTObservableExampleAppTests : XCTestCase

@end

@implementation DTObservableExampleAppTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSynchronous {

    XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];

    DTObservable *exampleObservable = [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        NSDictionary *value = @{@"4": @20};

        if ( ! [NSThread currentThread].isMainThread) {
            XCTFail(@"Synchronous observable not being executed on main thread!");
            [expectation fulfill];
        } else {
            [subscriber next:value];
            [subscriber complete];
        }
    }];
    
    [exampleObservable subscribe:[[DTSubscriber alloc] init:^(NSDictionary *value) {
        BOOL fourTwenty = [value[@"4"] intValue] == 20;
        if (fourTwenty) {
            [expectation fulfill];
        } else {
            XCTFail(@"Unexpected result returned: %@", value);
            [expectation fulfill];
        }
    } onError:^(NSError *error) {
        XCTFail(@"Example Observable failed with error: %@", error);
        [expectation fulfill];
    }]];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testAsynchronous {

    XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];

    DTObservable *exampleObservable = [[DTObservable alloc] init:^(DTSubscriber *subscriber) {
        NSDictionary *value = @{@"4": @20};

        if ([NSThread currentThread].isMainThread) {
            XCTFail(@"Asynchronous observable not being executed on new thread!");
            [expectation fulfill];
        } else {
            [subscriber next:value];
            [subscriber complete];
        }
    }];
    [exampleObservable newThread];
    [exampleObservable subscribe:[[DTSubscriber alloc] init:^(NSDictionary *value) {
        BOOL fourTwenty = [value[@"4"] intValue] == 20;
        if (fourTwenty) {
            [expectation fulfill];
        } else {
            XCTFail(@"Unexpected result returned: %@", value);
            [expectation fulfill];
        }
    } onError:^(NSError *error) {
        XCTFail(@"Example Observable failed with error: %@", error);
        [expectation fulfill];
    }]];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

@end

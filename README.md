# DTObservable

[![CI Status](http://img.shields.io/travis/DTHENG/DTObservable.svg?style=flat)](https://travis-ci.org/DTHENG/DTObservable)
[![Version](https://img.shields.io/cocoapods/v/DTObservable.svg?style=flat)](http://cocoadocs.org/docsets/DTObservable)
[![License](https://img.shields.io/cocoapods/l/DTObservable.svg?style=flat)](http://cocoadocs.org/docsets/DTObservable)  
[![Platform](https://img.shields.io/cocoapods/p/DTObservable.svg?style=flat)](http://cocoadocs.org/docsets/DTObservable)

## Usage

To run the example project, clone the repo, and run `pod install` from the DTObservableExampleApp directory first.

#### Simple Style

```obj-c
- (void)viewDidLoad {
    [super viewDidLoad];

	[[[DTObservable alloc] init:^(DTSubscriber *subscriber) {

		// Setup some data
		NSDictionary *value = @{@"4": @20};

		// Lets pretend something cpu intensive happens here
		[NSThread sleepForTimeInterval:1.f];
	
		// Notify the subscriber
		[subscriber complete:value];
	
	}] subscribe:[[DTSubscriber alloc] init:^(NSDictionary *value) {

		// Confirm the result
		BOOL fourTwenty = [value[@"4"] intValue] == 20;

		// Success!
		NSLog(@"Does 4 == 20? %@", fourTwenty ? @"YES" : @"NO");

	} onError:^(NSError *error) {
		NSLog(@"%@", error);
	}]];
}
```

#### Method Style

_ViewController.m_
```obj-c
- (void)viewDidLoad {
    [super viewDidLoad];

    [[self exampleObservable] subscribe:[self exampleSubscriber]];
}

- (DTObservable *)exampleObservable {
    return [[DTObservable alloc] init:^(DTSubscriber *subscriber) {

		// Setup some data
		NSDictionary *value = @{@"4": @20};

		// Lets pretend something cpu intensive happens here
		[NSThread sleepForTimeInterval:1.f];
	
		// Notify the subscriber
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
```
#### File Style

_ViewController.m_
```obj-c
- (void)viewDidLoad {
    [super viewDidLoad];

    [[[ExampleObserver alloc] init] subscribe:[[ExampleSubscriber alloc] init]];
}
```

_ExampleObservable.h_
```obj-c
#import "DTObservable.h"

@interface ExampleObserver : DTObservable

@end
```

_ExampleObservable.m_
```obj-c
#import "ExampleObserver.h"
#import "ExampleSubscriber.h"

@implementation ExampleObserver

- (void (^)(DTSubscriber *))new {

    return ^(DTSubscriber *subscriber) {

        NSDictionary *value = @{@"4": @20};

        // Lets pretend something cpu intensive happens here
        [NSThread sleepForTimeInterval:3.f];

        [subscriber complete:value];
    };
}

@end
```

_ExampleSubscriber.h_
```obj-c
#import <DTObservable/DTSubscriber.h>

@interface ExampleSubscriber : DTSubscriber

@end
```

_ExampleSubscriber.m_
```obj-c
#import "ExampleSubscriber.h"


@implementation ExampleSubscriber

- (void)complete:(NSDictionary *)value {

    BOOL fourTwenty = [value[@"4"] intValue] == 20;

    NSLog(@"Does 4 == 20? %@", fourTwenty ? @"YES" : @"NO");
}

- (void)error:(NSError *)error {
    NSLog(@"%@", error);
}

@end
```

## Installation

DTObservable is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod 'DTObservable', '0.1.1'

## Author

DTHENG, fender5289@gmail.com

## License

DTObservable is available under the MIT license. See the LICENSE file for more info.


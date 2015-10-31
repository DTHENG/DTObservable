# DTObservable

[![CI Status](http://img.shields.io/travis/DTHENG/DTObservable.svg?style=flat)](https://travis-ci.org/DTHENG/DTObservable)
[![Version](https://img.shields.io/cocoapods/v/DTObservable.svg?style=flat)](http://cocoadocs.org/docsets/DTObservable)
[![License](https://img.shields.io/cocoapods/l/DTObservable.svg?style=flat)](http://cocoadocs.org/docsets/DTObservable)
[![Platform](https://img.shields.io/cocoapods/p/DTObservable.svg?style=flat)](http://cocoadocs.org/docsets/DTObservable)

## Simple style, powerful implications

Objective-C:
```obj-c
[[[DTObservable alloc] init:^(DTSubscriber *subscriber) {

    // Setup some data
    NSDictionary *value = @{@"4": @20};

    // Notify the subscriber
    [subscriber next:value];
    [subscriber complete];

}] subscribe:[[DTSubscriber alloc] init:^(NSDictionary *value) {

    // Confirm the result
    BOOL fourTwenty = [value[@"4"] intValue] == 20;

    // Success!
    NSLog(@"Does 4 == 20? %@", fourTwenty ? @"YES" : @"NO");

} onError:^(NSError *error) {

    // Something went wrong :(
    NSLog(@"%@", error);
}]];
```

Swift:

```swift
DTObservable({ subscriber in

        // Setup some data
        let value = ["4":20]

        // Notify the subscriber
        subscriber.next(value)
        subscriber.complete()
    })
    .subscribe(DTSubscriber({ value in

        // Confirm the result
        let fourTwenty = value["4"] as! Int == 20

        // Success!
        print("Does 4 == 20? %@", fourTwenty ? "yes" : "no")
    }) { error in

        // Something went wrong :(
        print(error)
    })
```

- - -

## Installation

DTObservable is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod 'DTObservable', '1.0.0'

## Author

DTHENG, fender5289@gmail.com

## License

DTObservable is available under the MIT license. See the LICENSE file for more info.

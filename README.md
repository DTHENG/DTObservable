# DTObservable

[![CI Status](http://img.shields.io/travis/DTHENG/DTObservable.svg?style=flat)](https://travis-ci.org/DTHENG/DTObservable)
[![Version](https://img.shields.io/cocoapods/v/DTObservable.svg?style=flat)](http://cocoadocs.org/docsets/DTObservable)
[![License](https://img.shields.io/cocoapods/l/DTObservable.svg?style=flat)](http://cocoadocs.org/docsets/DTObservable)
[![Platform](https://img.shields.io/cocoapods/p/DTObservable.svg?style=flat)](http://cocoadocs.org/docsets/DTObservable)

## Simple style, powerful implications

```obj-c
[[[DTObservable alloc] init:^(DTSubscriber *subscriber) {

    // Setup some data
    NSDictionary *value = @{@"4": @20};

    // Lets pretend something cpu intensive happens here
    [NSThread sleepForTimeInterval:1.f];

    // Notify the subscriber
    [subscriber next:value];
    [subscriber complete];

}] subscribe:[[DTSubscriber alloc] init:^(NSDictionary *value) {

    // Confirm the result
    BOOL fourTwenty = [value[@"4"] intValue] == 20;

    // Success!
    NSLog(@"Does 4 == 20? %@", fourTwenty ? @"YES" : @"NO");

} onError:^(NSError *error) {
    NSLog(@"%@", error);
}]];
```

- - -

## Installation

DTObservable is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod 'DTObservable', '0.4.2'

## Author

DTHENG, fender5289@gmail.com

## License

DTObservable is available under the MIT license. See the LICENSE file for more info.


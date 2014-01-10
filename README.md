## PWProgressView ##

PWProgressView is a circular progress indicator inspired by the app install / update animation from iOS 7.

![pwprogressview](https://f.cloud.github.com/assets/954833/1884927/f929ad12-79b4-11e3-95e4-6dbac782387d.gif)

## Installation ##

If you use cocoapods add `pod 'PWProgressView'` to your Podfile and run `pod install`. Alternatively drag `PWProgressView.h` and `PWProgressView.m` into your project file and add the QuartzCore framework.

## Properties ##
```objc
@property (nonatomic, assign) float progress;
```
The current progress of the progress view. The progress property should be between 0.0 and 1.0.

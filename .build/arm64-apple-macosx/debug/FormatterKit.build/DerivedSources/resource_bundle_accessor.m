#import <Foundation/Foundation.h>

NSBundle* FormatterKit_SWIFTPM_MODULE_BUNDLE() {
    NSURL *bundleURL = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:@"FormatterKit_FormatterKit.bundle"];

    NSBundle *preferredBundle = [NSBundle bundleWithURL:bundleURL];
    if (preferredBundle == nil) {
      return [NSBundle bundleWithPath:@"/Users/nakulsingh/Documents/FormatterKit/.build/arm64-apple-macosx/debug/FormatterKit_FormatterKit.bundle"];
    }

    return preferredBundle;
}
// NSBundle+FormatterKit.m
//
// Copyright (c) 2011–2019 Mattt (https://mat.tt)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "NSBundle+FormatterKit.h"

@interface _TTTDummyClassForReferencingBundle : NSObject @end
@implementation _TTTDummyClassForReferencingBundle @end

@implementation NSBundle (FormatterKit)

+ (NSBundle *)formatterKitBundle {
    static NSBundle *formatterKitBundle = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifdef SWIFT_PACKAGE
        // For SPM, first try to find the resource bundle
        NSBundle *currentBundle = [NSBundle bundleForClass:[_TTTDummyClassForReferencingBundle class]];
        
        // Try to find FormatterKit.bundle in the SPM resource bundle
        NSURL *bundleURL = [currentBundle URLForResource:@"FormatterKit" withExtension:@"bundle"];
        if (bundleURL) {
            formatterKitBundle = [NSBundle bundleWithURL:bundleURL];
        }
        
        // Fallback: try different bundle locations
        if (!formatterKitBundle) {
            // Try in main bundle (for testing scenarios)
            bundleURL = [[NSBundle mainBundle] URLForResource:@"FormatterKit" withExtension:@"bundle"];
            if (bundleURL) {
                formatterKitBundle = [NSBundle bundleWithURL:bundleURL];
            }
        }
        
        // Final fallback: use main bundle
        if (!formatterKitBundle) {
            formatterKitBundle = [NSBundle mainBundle];
        }
#else
        // Original CocoaPods implementation
        NSString *bundlePath = [[NSBundle bundleForClass:[_TTTDummyClassForReferencingBundle class]] pathForResource:@"FormatterKit" ofType:@"bundle"];
        if (bundlePath) {
            formatterKitBundle = [NSBundle bundleWithPath:bundlePath];
        }
#endif
    });
    
    return formatterKitBundle ?: [NSBundle mainBundle];
}

@end

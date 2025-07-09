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
        // For SPM, look for the resource bundle
        NSBundle *moduleBundle = [NSBundle bundleForClass:[_TTTDummyClassForReferencingBundle class]];
        
        // Try different possible bundle names that SPM might create
        NSArray *possibleBundleNames = @[
            @"FormatterKit_FormatterKit",
            @"FormatterKit",
            @"FormatterKit_Resources"
        ];
        
        for (NSString *bundleName in possibleBundleNames) {
            NSString *bundlePath = [moduleBundle pathForResource:bundleName ofType:@"bundle"];
            if (bundlePath) {
                NSBundle *outerBundle = [NSBundle bundleWithPath:bundlePath];
                if (outerBundle) {
                    // Check if there's a nested FormatterKit.bundle inside
                    NSString *nestedBundlePath = [outerBundle pathForResource:@"FormatterKit" ofType:@"bundle"];
                    if (nestedBundlePath) {
                        formatterKitBundle = [NSBundle bundleWithPath:nestedBundlePath];
                        NSLog(@"Found nested FormatterKit bundle at: %@", nestedBundlePath);
                    } else {
                        formatterKitBundle = outerBundle;
                        NSLog(@"Using outer bundle: %@", bundlePath);
                    }
                    break;
                }
            }
        }
        
        // If no separate bundle found, check if resources are directly in the module bundle
        if (!formatterKitBundle) {
            NSArray *localizations = [moduleBundle localizations];
            if ([localizations count] > 1) { // More than just "Base"
                formatterKitBundle = moduleBundle;
                NSLog(@"Using module bundle directly for FormatterKit resources");
            }
        }
#else
        // Original CocoaPods implementation
        NSString *bundlePath = [[NSBundle bundleForClass:[_TTTDummyClassForReferencingBundle class]] pathForResource:@"FormatterKit" ofType:@"bundle"];
        if (bundlePath) formatterKitBundle = [NSBundle bundleWithPath:bundlePath];
#endif
    });
    
    return formatterKitBundle ?: [NSBundle mainBundle];
}

+ (NSBundle *)packageBundle {
    // Get the bundle for the class itself. This will be the bundle containing your package's resources.
    return [NSBundle bundleForClass:[self class]];
}

@end

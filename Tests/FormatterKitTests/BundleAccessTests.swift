import XCTest
@testable import FormatterKit

final class BundleAccessTests: XCTestCase {
    
    func testBundleAccess() {
        let bundle = Bundle.formatterKit()!
        XCTAssertNotNil(bundle, "FormatterKit bundle should not be nil")
        
        // Print bundle path for debugging
        print("Bundle path: \(bundle.bundlePath)")
        print("Bundle identifier: \(bundle.bundleIdentifier ?? "No identifier")")
    }
    
    func testBundleStructure() {
        let bundle = Bundle.formatterKit()!
        
        // List all contents of the bundle
        let bundleContents = try? FileManager.default.contentsOfDirectory(atPath: bundle.bundlePath)
        print("Bundle contents: \(bundleContents ?? [])")
        
        // Check for FormatterKit.bundle specifically
        if let contents = bundleContents {
            let bundles = contents.filter { $0.hasSuffix(".bundle") }
            print("Found bundles: \(bundles)")
            
            for bundleName in bundles {
                let bundlePath = bundle.bundlePath + "/" + bundleName
                if let subBundle = Bundle(path: bundlePath) {
                    print("Sub-bundle \(bundleName) localizations: \(subBundle.localizations)")
                }
            }
        }
    }
    
    func testResourcePaths() {
            let bundle = Bundle.formatterKit()!
            
            // Try to find FormatterKit.strings in different ways
            print("Searching for FormatterKit.strings...")
            
            let englishStrings = bundle.path(forResource: "FormatterKit", ofType: "strings")
            print("English strings path: \(englishStrings ?? "Not found")")
            
            let spanishStrings = bundle.path(forResource: "FormatterKit", ofType: "strings", inDirectory: "es.lproj")
            print("Spanish strings path: \(spanishStrings ?? "Not found")")
            
            // Check if FormatterKit.bundle exists as a resource
            let formatterKitBundle = bundle.path(forResource: "FormatterKit", ofType: "bundle")
            print("FormatterKit.bundle path: \(formatterKitBundle ?? "Not found")")
            
            if let bundlePath = formatterKitBundle,
               let subBundle = Bundle(path: bundlePath) {
                print("FormatterKit.bundle localizations: \(subBundle.localizations)")
            }
        }
    
    
    // ...existing code...

    func testLocalizationsAvailable() {
        let bundle = Bundle.formatterKit()
        let localizations = bundle!.localizations
        
        print("Available localizations: \(localizations)")
        
        // Check for expected localizations
        let expectedLocalizations = ["en", "es", "fr", "de", "ja", "zh-Hans"]
        
        for locale in expectedLocalizations {
            let exists = localizations.contains(locale)
            print("Localization \(locale): \(exists ? "✓" : "✗")")
            XCTAssertTrue(exists, "Missing localization: \(locale)")
        }
    }

    func testLocalizedStrings() {
        let bundle = Bundle.formatterKit()!
        
        // Test localized string access
        let andString = NSLocalizedString("and", tableName: "FormatterKit", bundle: bundle, comment: "")
        print("Localized 'and' string: '\(andString)'")
        XCTAssertFalse(andString.isEmpty, "Localized string should not be empty")
        
        // Test with specific locale
        if let spanishPath = bundle.path(forResource: "fr", ofType: "lproj"),
           let spanishBundle = Bundle(path: spanishPath) {
            let spanishAnd = NSLocalizedString("and", tableName: "FormatterKit", bundle: spanishBundle, comment: "")
            print("Spanish 'and' string: '\(spanishAnd)'")
            XCTAssertNotEqual(andString, spanishAnd, "Spanish translation should be different from English")
        }
    }
    }

import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "circle_blue" asset catalog image resource.
    static let circleBlue = DeveloperToolsSupport.ImageResource(name: "circle_blue", bundle: resourceBundle)

    /// The "circle_green" asset catalog image resource.
    static let circleGreen = DeveloperToolsSupport.ImageResource(name: "circle_green", bundle: resourceBundle)

    /// The "circle_outline" asset catalog image resource.
    static let circleOutline = DeveloperToolsSupport.ImageResource(name: "circle_outline", bundle: resourceBundle)

    /// The "circle_outline_green" asset catalog image resource.
    static let circleOutlineGreen = DeveloperToolsSupport.ImageResource(name: "circle_outline_green", bundle: resourceBundle)

    /// The "circle_outline_red" asset catalog image resource.
    static let circleOutlineRed = DeveloperToolsSupport.ImageResource(name: "circle_outline_red", bundle: resourceBundle)

    /// The "circle_outline_yellow" asset catalog image resource.
    static let circleOutlineYellow = DeveloperToolsSupport.ImageResource(name: "circle_outline_yellow", bundle: resourceBundle)

    /// The "circle_red" asset catalog image resource.
    static let circleRed = DeveloperToolsSupport.ImageResource(name: "circle_red", bundle: resourceBundle)

    /// The "circle_yellow" asset catalog image resource.
    static let circleYellow = DeveloperToolsSupport.ImageResource(name: "circle_yellow", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "circle_blue" asset catalog image.
    static var circleBlue: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .circleBlue)
#else
        .init()
#endif
    }

    /// The "circle_green" asset catalog image.
    static var circleGreen: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .circleGreen)
#else
        .init()
#endif
    }

    /// The "circle_outline" asset catalog image.
    static var circleOutline: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .circleOutline)
#else
        .init()
#endif
    }

    /// The "circle_outline_green" asset catalog image.
    static var circleOutlineGreen: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .circleOutlineGreen)
#else
        .init()
#endif
    }

    /// The "circle_outline_red" asset catalog image.
    static var circleOutlineRed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .circleOutlineRed)
#else
        .init()
#endif
    }

    /// The "circle_outline_yellow" asset catalog image.
    static var circleOutlineYellow: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .circleOutlineYellow)
#else
        .init()
#endif
    }

    /// The "circle_red" asset catalog image.
    static var circleRed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .circleRed)
#else
        .init()
#endif
    }

    /// The "circle_yellow" asset catalog image.
    static var circleYellow: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .circleYellow)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "circle_blue" asset catalog image.
    static var circleBlue: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .circleBlue)
#else
        .init()
#endif
    }

    /// The "circle_green" asset catalog image.
    static var circleGreen: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .circleGreen)
#else
        .init()
#endif
    }

    /// The "circle_outline" asset catalog image.
    static var circleOutline: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .circleOutline)
#else
        .init()
#endif
    }

    /// The "circle_outline_green" asset catalog image.
    static var circleOutlineGreen: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .circleOutlineGreen)
#else
        .init()
#endif
    }

    /// The "circle_outline_red" asset catalog image.
    static var circleOutlineRed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .circleOutlineRed)
#else
        .init()
#endif
    }

    /// The "circle_outline_yellow" asset catalog image.
    static var circleOutlineYellow: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .circleOutlineYellow)
#else
        .init()
#endif
    }

    /// The "circle_red" asset catalog image.
    static var circleRed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .circleRed)
#else
        .init()
#endif
    }

    /// The "circle_yellow" asset catalog image.
    static var circleYellow: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .circleYellow)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif


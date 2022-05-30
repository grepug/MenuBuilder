import UIKit

@resultBuilder
public struct MenuBuilder {
    public static func buildBlock() -> [Menu] {
        []
    }
}

public protocol MenuConvertible {
    func asMenu() -> [Menu]
}

public extension MenuBuilder {
    static func buildBlock(_ components: MenuConvertible...) -> [Menu] {
        components.flatMap { $0.asMenu() }
    }
    
    static func buildOptional(_ component: [MenuConvertible]?) -> [Menu] {
        (component ?? []).flatMap { $0.asMenu() }
    }
    
    static func buildEither(first component: [MenuConvertible]) -> [Menu] {
        component.flatMap { $0.asMenu() }
    }

    static func buildEither(second component: [MenuConvertible]) -> [Menu] {
        component.flatMap { $0.asMenu() }
    }
    
    static func buildArray(_ components: [[MenuConvertible]]) -> [Menu] {
        components.flatMap { $0.flatMap { $0.asMenu() } }
    }
}

extension Array: MenuConvertible where Element == Menu {
    public func asMenu() -> [Menu] {
        self
    }
}

public extension MenuBuilder {
    static func build(@MenuBuilder _ content: () -> [Menu]) -> [Menu] {
        content()
    }
}

public struct Button: MenuConvertible {
    var title: String?
    var image: PlatformImage?
    var subtitle: String?
    var checked: Bool
    var destructive: Bool
    var color: PlatformColor?
    var action: (@escaping (Bool) -> Void) -> Void
    
    public init(_ title: String? = nil,
                subtitle: String? = nil,
                image: PlatformImage? = nil,
                color: PlatformColor? = nil,
                checked: Bool = false,
                destructive: Bool = false,
                action: @escaping (@escaping (Bool) -> Void) -> Void) {
        self.title = title
        self.image = image
        self.subtitle = subtitle
        self.checked = checked
        self.color = color
        self.destructive = destructive
        self.action = action
    }
    
    public init(_ title: String? = nil,
                subtitle: String? = nil,
                image: PlatformImage? = nil,
                color: PlatformColor? = nil,
                checked: Bool = false,
                destructive: Bool = false,
                action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.checked = checked
        self.subtitle = subtitle
        self.color = color
        self.destructive = destructive
        self.action = { completion in
            action()
            completion(true)
        }
    }
    
    public func asMenu() -> [Menu] {
        [.init(title ?? "",
               image: image,
               color: color,
               checked: checked,
               destructive: destructive,
               action: action,
               children: {})]
    }
}

public struct Menu: MenuConvertible {
    var title: String
    var image: PlatformImage?
    var subtile: String?
    var checked: Bool
    var destructive: Bool
    var color: PlatformColor?
    var action: ((@escaping (Bool) -> Void) -> Void)?
    var children: [Menu]
    
    public init(_ title: String,
                subtitle: String? = nil,
                image: PlatformImage? = nil,
                color: PlatformColor? = nil,
                checked: Bool = false,
                destructive: Bool = false,
                action: ((@escaping (Bool) -> Void) -> Void)? = nil,
                @MenuBuilder children: @escaping () -> [Menu]) {
        self.title = title
        self.image = image
        self.subtile = subtitle
        self.action = action
        self.color = color
        self.checked = checked
        self.destructive = destructive
        self.children = children()
    }
    
    public func asMenu() -> [Menu] {
        [self]
    }
}

public struct Group: MenuConvertible {
    var title: String
    var children: [Menu]
    
    public func asMenu() -> [Menu] {
        [.init(title,
               action: nil,
               children: { children })]
    }
    
    public init(@MenuBuilder children: @escaping () -> [Menu]) {
        title = "@@group@@"
        self.children = children()
    }
}

#if os(iOS)
public typealias PlatformImage = UIImage
public typealias PlatformColor = UIColor
#endif

public typealias MBMenu = Menu
public typealias MBButton = Button

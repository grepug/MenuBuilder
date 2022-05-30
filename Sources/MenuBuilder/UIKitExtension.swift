//
//  UIKitExtension.swift.swift
//  
//
//  Created by Kai on 2022/3/6.
//

import UIKit

public extension Array where Element == UIMenuElement {
    static func makeMenu(_ menus: [Menu], completion: (() -> Void)? = nil) -> UIMenu {
        UIMenu.makeMenu(menus, completion: completion)
    }
}

public extension UIMenu {
    static func makeMenu(_ menus: [Menu], completion: (() -> Void)? = nil) -> UIMenu {
        let children = Self.recursivelyMakeMenu(children: menus,
                                                completion: completion)
        
        return .init(children: children)
    }
    
    private static func recursivelyMakeMenu(children: [Menu], completion: (() -> Void)?) -> [UIMenuElement] {
        var elements: [UIMenuElement] = []
        
        for item in children {
            let isSep = item.title == "@@group@@"
            
            if isSep {
                let menu = UIMenu(options: [.displayInline],
                                  children: recursivelyMakeMenu(children: item.children,
                                                                completion: completion))
                
                elements.append(menu)
            } else if !item.children.isEmpty {
                let menu = UIMenu(title: item.title,
                                  image: item.image,
                                  children: recursivelyMakeMenu(children: item.children,
                                                                completion: completion))
                
                if #available(iOS 15.0, *) {
                    menu.subtitle = item.subtile
                }
                
                elements.append(menu)
            } else {
                let action = UIAction(title: item.title,
                                      image: item.image,
                                      attributes: item.destructive ? .destructive : [],
                                      state: item.checked ? .on : .off) { _ in
                    item.action?({ _ in })
                    completion?()
                }
                
                if #available(iOS 15.0, *) {
                    action.subtitle = item.subtile
                }

                elements.append(action)
            }
        }
        
        return elements
    }
}

public extension Array where Element == UIContextualAction {
    static func makeActions(_ menus: [Menu]) -> [UIContextualAction] {
        var actions = [UIContextualAction]()
        
        for menu in menus {
            let action = UIContextualAction(style: menu.destructive ? .destructive : .normal,
                                            title: menu.title) { _, _, completion in
                menu.action?(completion)
            }
            
            if let image = menu.image {
                action.image = image
                action.title = nil
            }
            
            if let color = menu.color {
                action.backgroundColor = color
            }
            
            actions.append(action)
        }
        
        return actions
    }
}

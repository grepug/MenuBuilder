//
//  UIKitExtension.swift.swift
//  
//
//  Created by Kai on 2022/3/6.
//

import UIKit

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
                elements.append(menu)
            } else {
                let action = UIAction(title: item.title,
                                      image: item.image,
                                      attributes: item.attributes ?? [],
                                      state: item.checked ? .on : .off) { _ in
                    item.action?()
                    completion?()
                }

                elements.append(action)
            }
        }
        
        return elements
    }
}

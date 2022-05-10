//
//  MenuBuilder+Utils.swift
//  Vision 3 (iOS)
//
//  Created by Kai on 2022/3/16.
//

import UIKit
import Foundation

public extension Button {
    static func delete(action: @escaping () -> Void) -> Button {
        .init("action_discard".loc,
              image: .init(systemName: "trash")!,
              color: .systemRed,
              destructive: true,
              action: action)
    }
    
    static func edit(action: @escaping () -> Void) -> Button {
        .init("action_edit".loc,
              image: .init(systemName: "pencil")!,
              color: .systemBlue,
              action: action)
    }
    
    static func detail(_ title: String? = nil, action: @escaping () -> Void) -> Button {
        .init(title ?? "action_detail".loc,
              image: .init(systemName: "info.circle"),
              action: action)
    }
    
    static func duplicate(action: @escaping () -> Void) -> Button {
        .init("action_duplicate".loc,
              image: .init(systemName: "doc.on.doc"),
              color: .systemGreen,
              action: action)
    }
}

extension String {
    var loc: Self {
        String(format: NSLocalizedString(self, bundle: .module, comment: ""), "")
    }
    
    func loc(_ string: String) -> Self {
        String(format: NSLocalizedString(self, comment: ""), string)
    }
}

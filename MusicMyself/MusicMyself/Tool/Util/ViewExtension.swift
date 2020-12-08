//
//  ViewExtension.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import Foundation
import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UITextField {
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
}

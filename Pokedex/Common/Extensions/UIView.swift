//
//  UIView.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 05/08/25.
//

import UIKit

public typealias Closure = () -> Void

class ClosureSleeve {
    let closure: Closure
    init(_ closure: @escaping Closure) {
        self.closure = closure
    }
    @objc func invoke() {
        closure()
    }
}

extension UIView {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping Closure) {
        let sleeve = ClosureSleeve(closure)
        let gesture = UITapGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        gesture.numberOfTapsRequired = 1
        addGestureRecognizer(gesture)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, String(format: "[%d]", Int.random(in: 0..<Int.max)), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

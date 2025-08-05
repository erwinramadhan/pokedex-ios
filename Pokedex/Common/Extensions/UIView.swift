//
//  UIView.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 05/08/25.
//

import UIKit

extension UIView {
    func loadNib() -> UIView {
        guard let nibName = type(of: self).description().components(separatedBy: ".").last else { return UIView() }
        let nib = UINib(nibName: nibName, bundle: Bundle(for: `classForCoder`.self))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }
}

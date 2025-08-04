//
//  BaseCoordinatorProtocol.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 04/08/25.
//

import UIKit

protocol BaseCoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

protocol AppCoordinatorProtocol: AnyObject {
    func start()
}

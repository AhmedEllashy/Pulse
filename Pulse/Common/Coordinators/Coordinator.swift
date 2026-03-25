//
//  Coordinator.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 25/03/2026.
//


import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
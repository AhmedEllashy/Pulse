//
//  AppCoordinator.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 25/03/2026.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

     func start() {
        let nav = UINavigationController()
        window.rootViewController = nav
        window.makeKeyAndVisible()

        let repository = AssetRepository(networkClient: DIContainer.shared.networkClient)
        let viewModel = SearchViewModel(repository: repository)
        let searchVC = SearchViewController(viewModel: viewModel)
        nav.pushViewController(searchVC, animated: false)
    }
}

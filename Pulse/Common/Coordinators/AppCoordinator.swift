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

    @MainActor func start() {
        let nav = UINavigationController()
        window.rootViewController = nav
        window.makeKeyAndVisible()

        // Tab bar with Search + Portfolio
        let tabBar = UITabBarController()

        let searchVC = makeSearchVC()
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)

        let portfolioVC = makePortfolioVC()
        portfolioVC.tabBarItem = UITabBarItem(title: "Portfolio", image: UIImage(systemName: "chart.pie"), tag: 1)

        tabBar.viewControllers = [
            UINavigationController(rootViewController: searchVC),
            UINavigationController(rootViewController: portfolioVC)
        ]

        window.rootViewController = tabBar
    }

    private func makeSearchVC() -> SearchViewController {
        let repository = AssetRepository(networkClient: DIContainer.shared.networkClient)
        let viewModel = SearchViewModel(repository: repository)
        return SearchViewController(viewModel: viewModel)
    }

    @MainActor private func makePortfolioVC() -> PortfolioViewController {
        let viewModel = PortfolioViewModel(repository: DIContainer.shared.portfolioRepository)
        return PortfolioViewController(viewModel: viewModel)
    }
}

//
//  SearchViewController.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 27/03/2026.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: SearchViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UITableViewDiffableDataSource<Int, Asset>!

    // MARK: - UI
    private let searchController = UISearchController(searchResultsController: nil)

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(AssetCell.self, forCellReuseIdentifier: AssetCell.reuseID)
        tv.keyboardDismissMode = .onDrag
        return tv
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        return ai
    }()

    // MARK: - Init
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
        bindViewModel()
    }

    // MARK: - Setup
    private func setupUI() {
        title = "Search"
        view.backgroundColor = .systemBackground

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Stocks, crypto..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, asset in
            let cell = tableView.dequeueReusableCell(withIdentifier: AssetCell.reuseID, for: indexPath) as! AssetCell
            cell.configure(with: asset)
            return cell
        }
    }

    // MARK: - Binding
    private func bindViewModel() {
        viewModel.$results
            .receive(on: DispatchQueue.main)
            .sink { [weak self] assets in
                self?.applySnapshot(assets)
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                loading ? self?.activityIndicator.startAnimating()
                        : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }

    // MARK: - Snapshot
    private func applySnapshot(_ assets: [Asset]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Asset>()
        snapshot.appendSections([0])
        snapshot.appendItems(assets)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        viewModel.searchText.send(query)
    }
}

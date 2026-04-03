//
//  AddAssetViewController.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 03/04/2026.
//

import UIKit
import Combine

final class AddAssetViewController: UIViewController {

    // MARK: - Callback
    var onAssetAdded: (() -> Void)?

    // MARK: - Properties
    private let viewModel: PortfolioViewModel
    private var selectedAsset: Asset?
    private var cancellables = Set<AnyCancellable>()
    private var searchDataSource: UITableViewDiffableDataSource<Int, Asset>!

    // MARK: - UI
    private let searchController = UISearchController(searchResultsController: nil)

    private let searchResultsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(AssetCell.self, forCellReuseIdentifier: AssetCell.reuseID)
        tv.isHidden = true
        return tv
    }()

    private let selectedAssetView: SelectedAssetView = {
        let v = SelectedAssetView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()

    private let quantityTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Quantity"
        tf.keyboardType = .decimalPad
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isHidden = true
        return tf
    }()

    private let buyPriceTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Buy Price (USD)"
        tf.keyboardType = .decimalPad
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isHidden = true
        return tf
    }()

    private let addButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Add to Portfolio"
        config.cornerStyle = .large
        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isHidden = true
        return b
    }()

    private let searchViewModel: SearchViewModel

    // MARK: - Init
    init(portfolioViewModel: PortfolioViewModel, searchViewModel: SearchViewModel) {
        self.viewModel = portfolioViewModel
        self.searchViewModel = searchViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
        bindSearchViewModel()
    }

    // MARK: - Setup
    private func setupUI() {
        title = "Add Asset"
        view.backgroundColor = .systemBackground

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search asset..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        view.addSubview(searchResultsTableView)
        view.addSubview(selectedAssetView)
        view.addSubview(quantityTextField)
        view.addSubview(buyPriceTextField)
        view.addSubview(addButton)

        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            searchResultsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            selectedAssetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            selectedAssetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectedAssetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selectedAssetView.heightAnchor.constraint(equalToConstant: 60),

            quantityTextField.topAnchor.constraint(equalTo: selectedAssetView.bottomAnchor, constant: 16),
            quantityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            quantityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            quantityTextField.heightAnchor.constraint(equalToConstant: 44),

            buyPriceTextField.topAnchor.constraint(equalTo: quantityTextField.bottomAnchor, constant: 12),
            buyPriceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buyPriceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buyPriceTextField.heightAnchor.constraint(equalToConstant: 44),

            addButton.topAnchor.constraint(equalTo: buyPriceTextField.bottomAnchor, constant: 24),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupDataSource() {
        searchDataSource = UITableViewDiffableDataSource(tableView: searchResultsTableView) { tableView, indexPath, asset in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AssetCell.reuseID,
                for: indexPath
            ) as! AssetCell
            cell.configure(with: asset)
            return cell
        }

        searchResultsTableView.delegate = self
    }

    // MARK: - Binding
    private func bindSearchViewModel() {
        searchViewModel.$results
            .receive(on: DispatchQueue.main)
            .sink { [weak self] assets in
                self?.applySnapshot(assets)
                self?.searchResultsTableView.isHidden = assets.isEmpty
            }
            .store(in: &cancellables)
    }

    // MARK: - Snapshot
    private func applySnapshot(_ assets: [Asset]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Asset>()
        snapshot.appendSections([0])
        snapshot.appendItems(assets)
        searchDataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Show asset form
    private func showAssetForm(for asset: Asset) {
        selectedAsset = asset
        searchResultsTableView.isHidden = true
        selectedAssetView.configure(with: asset)
        selectedAssetView.isHidden = false
        quantityTextField.isHidden = false
        buyPriceTextField.isHidden = false
        addButton.isHidden = false
        searchController.searchBar.resignFirstResponder()
    }

    // MARK: - Actions
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func addTapped() {
        guard
            let asset = selectedAsset,
            let quantityText = quantityTextField.text,
            let quantity = Double(quantityText),
            let buyPriceText = buyPriceTextField.text,
            let buyPrice = Double(buyPriceText)
        else { return }

        viewModel.addAsset(asset, quantity: quantity, buyPrice: buyPrice)
        onAssetAdded?()
        dismiss(animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension AddAssetViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        searchViewModel.searchText.send(query)
    }
}

// MARK: - UITableViewDelegate
extension AddAssetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let asset = searchDataSource.itemIdentifier(for: indexPath) else { return }
        showAssetForm(for: asset)
    }
}

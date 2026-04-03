//
//  PortfolioViewController.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 01/04/2026.
//


import UIKit
import Combine

final class PortfolioViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: PortfolioViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UITableViewDiffableDataSource<Int, PortfolioItem>!

    // MARK: - UI
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(PortfolioItemCell.self, forCellReuseIdentifier: PortfolioItemCell.reuseID)
        return tv
    }()

    private let headerView: PortfolioHeaderView = {
        let v = PortfolioHeaderView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let emptyStateLabel: UILabel = {
        let l = UILabel()
        l.text = "No assets yet.\nTap + to add one."
        l.numberOfLines = 2
        l.textAlignment = .center
        l.textColor = .secondaryLabel
        l.font = .systemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.isHidden = true
        return l
    }()

    // MARK: - Init
    init(viewModel: PortfolioViewModel) {
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
        viewModel.loadPortfolio()
    }

    // MARK: - Setup
    private func setupUI() {
        title = "Portfolio"
        view.backgroundColor = .systemGroupedBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )

        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),

            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PortfolioItemCell.reuseID,
                for: indexPath
            ) as! PortfolioItemCell
            cell.configure(with: item)
            return cell
        }

        tableView.delegate = self
    }

    // MARK: - Binding
    private func bindViewModel() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.applySnapshot(items)
                self?.emptyStateLabel.isHidden = !items.isEmpty
            }
            .store(in: &cancellables)

        viewModel.$totalValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.headerView.configure(totalValue: value)
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                self?.showError(message)
            }
            .store(in: &cancellables)
    }

    // MARK: - Snapshot
    private func applySnapshot(_ items: [PortfolioItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, PortfolioItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Actions
    @objc private func addTapped() {
        // TODO: present AddAssetViewController
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension PortfolioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: navigate to AssetDetail
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, completion in
            guard let item = self?.dataSource.itemIdentifier(for: indexPath) else { return }
            self?.viewModel.removeItem(item)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
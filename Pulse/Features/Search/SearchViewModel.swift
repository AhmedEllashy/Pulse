//
//  SearchViewModel.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 27/03/2026.
//

import Combine
import Foundation

final class SearchViewModel {

    // MARK: - Output
    @Published private(set) var results: [Asset] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    // MARK: - Input
    let searchText = PassthroughSubject<String, Never>()

    // MARK: - Private
    private let repository: AssetRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?

    init(repository: AssetRepositoryProtocol) {
        self.repository = repository
        bindSearch()
    }

    // MARK: - Binding

    private func bindSearch() {
        searchText
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { $0.count >= 2 }
            .sink { [weak self] query in
                Task { @MainActor in
                    self?.performSearch(query: query)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Search
    private func performSearch(query: String) {
        searchTask?.cancel()

        searchTask = Task {
            isLoading = true
            errorMessage = nil

            do {
                let assets = try await repository.search(query: query)
                guard !Task.isCancelled else { return }
                results = assets
            } catch {
                guard !Task.isCancelled else { return }
                errorMessage = error.localizedDescription
                results = []
            }

            isLoading = false
        }
    }
}

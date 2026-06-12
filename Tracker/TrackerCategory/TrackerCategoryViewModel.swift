//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Максим on 03.06.2026.
//

import Foundation

final class TrackerCategoryViewModel {

    private let categoryStore: TrackerCategoryStore
    private var categories: [TrackerCategory] = []
    private var selectedCategoryTitle: String?

    var onCategoriesChanged: (() -> Void)?
    var onCategorySelected: ((String) -> Void)?

    init(
        categoryStore: TrackerCategoryStore = TrackerCategoryStore(),
        selectedCategoryTitle: String? = nil
    ) {
        self.categoryStore = categoryStore
        self.selectedCategoryTitle = selectedCategoryTitle

        do {
            try categoryStore.setupFetchedResultsController()
        } catch {
            assertionFailure("Failed to setup category store: \(error)")
        }

        categoryStore.onDataChanged = { [weak self] in
            self?.loadCategories()
        }
    }

    func loadCategories() {
        categories = categoryStore.fetchTrackerCategories()
        onCategoriesChanged?()
    }

    func numberOfRows() -> Int {
        categories.count
    }

    func categoryTitle(at index: Int) -> String {
        categories[index].title
    }
    
    func isCategorySelected(at index: Int) -> Bool {
        categories[index].title == selectedCategoryTitle
    }

    func selectCategory(at index: Int) {
        let title = categories[index].title
        selectedCategoryTitle = title
        onCategoriesChanged?()
        onCategorySelected?(title)
    }
    
    func addCategory(with title: String) {
        do {
            _ = try categoryStore.getOrCreateCategory(with: title)
            loadCategories()
        } catch {
            assertionFailure("Failed to add category: \(error)")
        }
    }
    
    func cellViewModel(at index: Int) -> TrackerCategoryCellViewModel {
        TrackerCategoryCellViewModel(
            title: categories[index].title,
            isSelected: isCategorySelected(at: index)
        )
    }
}

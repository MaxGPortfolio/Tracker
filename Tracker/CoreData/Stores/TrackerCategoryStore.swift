//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Максим on 16.05.2026.
//

import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Constants

    private enum Constants {
        static let alpha: CGFloat = 1
    }
    
    // MARK: - Private Properties

    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
    // MARK: - Public Properties

    var onDataChanged: (() -> Void)?
    
    // MARK: - Init

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
        super.init()
    }
    
    // MARK: - Public

    func setupFetchedResultsController() throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        fetchedResultsController = controller
        
        try controller.performFetch()
    }
    
    func fetchedCategories() -> [TrackerCategoryCoreData] {
        fetchedResultsController?.fetchedObjects ?? []
    }
    
    func getOrCreateCategory(with title: String) throws -> TrackerCategoryCoreData {
        let request = TrackerCategoryCoreData.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "title == %@",
            title
        )
        
        let categories = try context.fetch(request)
        
        if let category = categories.first {
            return category
        }
        
        let category = TrackerCategoryCoreData(context: context)
        category.title = title
        
        try context.save()
        
        return category
    }
    
    func fetchTrackerCategories() -> [TrackerCategory] {
        let categories = fetchedCategories()
        return categories.compactMap { categoryCoreData -> TrackerCategory? in
            guard let categoryTitle = categoryCoreData.title else {
                return nil
            }
            let trackersCoreData = categoryCoreData.trackers as? Set<TrackerCoreData> ?? []
            let trackers = trackersCoreData.compactMap { trackerCoreData -> Tracker? in
                guard
                    let id = trackerCoreData.id,
                    let title = trackerCoreData.title,
                    let emoji = trackerCoreData.emoji,
                    let scheduleString = trackerCoreData.schedule,
                    let creationDate = trackerCoreData.creationDate
                else {
                    return nil
                }
                return Tracker(
                    id: id,
                    title: title,
                    color: decodeColor(trackerCoreData.color),
                    emoji: emoji,
                    schedule: decodeSchedule(scheduleString),
                    creationDate: creationDate
                )
            }
            return TrackerCategory(
                title: categoryTitle,
                trackers: trackers
            )
        }
    }
    
    // MARK: - Private Helpers

    private func decodeSchedule(_ scheduleString: String) -> [Weekday] {
        scheduleString
            .split(separator: ",")
            .compactMap { Weekday(rawValue: String($0)) }
    }
    
    private func decodeColor(_ hexString: String?) -> UIColor {
        guard let hexString else {
            return .systemBlue
        }
        let hex = hexString.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        guard let value = Int(hex, radix: 16) else {
            return .systemBlue
        }
        let red = CGFloat((value >> 16) & 0xFF) / 255
        let green = CGFloat((value >> 8) & 0xFF) / 255
        let blue = CGFloat(value & 0xFF) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: Constants.alpha)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        onDataChanged?()
    }
}

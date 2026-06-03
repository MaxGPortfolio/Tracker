//
//  TrackerStore.swift
//  Tracker
//
//  Created by Максим on 16.05.2026.
//

import CoreData
import UIKit

final class TrackerStore: NSObject {
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    // MARK: - Public Properties
    
    var onDataChanged: (() -> Void)?
    
    // MARK: - Init
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
        super.init()
    }
    
    // MARK: - Public
    
    func addTracker(
        _ tracker: Tracker,
        to category: TrackerCategoryCoreData
    ) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = encodeColor(tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = encodeSchedule(tracker.schedule)
        trackerCoreData.creationDate = tracker.creationDate
        trackerCoreData.category = category
        
        try context.save()
    }
    
    func trackerCoreData(with id: UUID) throws -> TrackerCoreData? {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    func setupFetchedResultsController() throws {
        let request = TrackerCoreData.fetchRequest()
        
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
    
    func fetchedTrackers() -> [TrackerCoreData] {
        fetchedResultsController?.fetchedObjects ?? []
    }
    
    // MARK: - Private Helpers
    
    private func encodeSchedule(_ schedule: [Weekday]) -> String {
        schedule
            .map { $0.rawValue }
            .joined(separator: ",")
    }
    
    private func encodeColor(_ color: UIColor) -> String {
        guard let components = color.cgColor.components else {
            return "#000000"
        }
        
        let red = Int((components[0]) * 255)
        let green = Int((components[1]) * 255)
        let blue = Int((components[2]) * 255)
        
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        onDataChanged?()
    }
}

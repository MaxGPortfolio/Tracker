//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Максим on 16.05.2026.
//

import CoreData

final class TrackerRecordStore: NSObject {
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    
    // MARK: - Public Properties
    
    var onDataChanged: (() -> Void)?
    
    // MARK: - Init
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
        super.init()
    }
    
    // MARK: - Public
    
    func addRecord(
        for tracker: TrackerCoreData,
        date: Date
    ) throws {
        let record = TrackerRecordCoreData(context: context)

        record.date = date
        record.tracker = tracker

        try context.save()
    }
    
    func isTrackerCompleted(
        _ tracker: TrackerCoreData,
        on date: Date
    ) throws -> Bool {
        let request = TrackerRecordCoreData.fetchRequest()

        request.predicate = NSPredicate(
            format: "tracker == %@ AND date >= %@ AND date < %@",
            tracker,
            startOfDay(for: date) as NSDate,
            startOfNextDay(for: date) as NSDate
        )

        let count = try context.count(for: request)

        return count > 0
    }
    
    func setupFetchedResultsController() throws {
        let request = TrackerRecordCoreData.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
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
    
    func deleteRecord(
        for tracker: TrackerCoreData,
        date: Date
    ) throws {
        let request = TrackerRecordCoreData.fetchRequest()

        request.predicate = NSPredicate(
            format: "tracker == %@ AND date >= %@ AND date < %@",
            tracker,
            startOfDay(for: date) as NSDate,
            startOfNextDay(for: date) as NSDate
        )

        let records = try context.fetch(request)

        records.forEach { record in
            context.delete(record)
        }

        try context.save()
    }
    
    func fetchedRecords() -> [TrackerRecordCoreData] {
        fetchedResultsController?.fetchedObjects ?? []
    }
    
    func fetchTrackerRecords() -> [TrackerRecord] {
        fetchedRecords().compactMap { recordCoreData -> TrackerRecord? in
            guard
                let tracker = recordCoreData.tracker,
                let trackerId = tracker.id,
                let date = recordCoreData.date
            else {
                return nil
            }

            return TrackerRecord(
                trackerId: trackerId,
                date: date
            )
        }
    }
    
    // MARK: - Private Helpers
    
    private func startOfDay(for date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    private func startOfNextDay(for date: Date) -> Date {
        Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: startOfDay(for: date)
        ) ?? date
    }
}

 // MARK: - NSFetchedResultsControllerDelegate

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        onDataChanged?()
    }
}

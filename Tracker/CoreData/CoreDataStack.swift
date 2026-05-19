//
//  CoreDataStack.swift
//  Tracker
//
//  Created by Максим on 12.05.2026.
//

import CoreData

final class CoreDataStack {
    
    // MARK: - Shared
    static let shared = CoreDataStack()
    
    // MARK: - Public Properties
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Private Properties
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("Core Data store failed to load: \(error)")
            }
        }
        return container
    }()
    
    // MARK: - Public
    func saveContext() {
        guard context.hasChanges else {
            return
        }
        do {
            try context.save()
        } catch {
            assertionFailure("Core Data save failed: \(error)")
        }
    }
}

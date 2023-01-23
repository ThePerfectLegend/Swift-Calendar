//
//  Persistence.swift
//  Swift Calendar
//
//  Created by Nizami Tagiyev on 19.01.2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let databaseName = "Swift_Calendar.sqlite"
    
    var oldStoreURl: URL {
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent(databaseName)
    }
    
    var sharedStoreURL: URL {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.NizamiDev.Swift-Calendar")!
        return container.appendingPathComponent(databaseName)
    }

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Swift_Calendar")
        
        
        if !FileManager.default.fileExists(atPath: oldStoreURl.path) {
            print("🆕 old store doesn't exist use shared store")
            container.persistentStoreDescriptions.first!.url = sharedStoreURL
        }
        
        print("🕸 container URL = \(container.persistentStoreDescriptions.first!.url!)")

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        migrateStore(for: container)
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func migrateStore(for container: NSPersistentContainer) {
        print("➡️ went it to migration")
        let coordinator = container.persistentStoreCoordinator
        
        guard let oldStore = coordinator.persistentStore(for: oldStoreURl) else { return }
        print("🛡 old store no longer exist")
        
        do {
            let _ = try coordinator.migratePersistentStore(oldStore, to: sharedStoreURL, type: .sqlite)
            print("🏁 migration completed")
        } catch {
            fatalError("Unable to migrate to shared store")
        }
        
        do {
            try FileManager.default.removeItem(at: oldStoreURl)
            print("🗑 old store deleted")
        } catch {
            print("⚠️ unable to delete old store")
        }
    }
}

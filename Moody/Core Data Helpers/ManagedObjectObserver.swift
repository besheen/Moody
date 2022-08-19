//
//  ManagedObjectObserver.swift
//  Moody
//
//  Created by Carl on 2022/8/18.
//

import Foundation
import CoreData

final class ManagedObjectObserver {
    enum ChangeType {
        case delete
        case update
    }
    
    init?(object: NSManagedObject, changeHandler: @escaping (ChangeType) -> ()) {
        guard let moc = object.managedObjectContext else {
            return nil
        }
        
        token = moc.addObjectsDidChangeNotificationObserver { [weak self] note in
            guard let changeType = self?.changeType(of: object, in: note) else {
                return
            }
            changeHandler(changeType)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(token)
    }
    
    // MARK: Private
    fileprivate var token: NSObjectProtocol!
    
    fileprivate func changeType(of object: NSManagedObject, in note: ObjectsDidChangeNotification) -> ChangeType? {
        let deleted = note.deletedObjects.union(note.invalidatedObjects)
        if note.invalidatedAllObjects || deleted.containsObjectIdentical(to: object) {
            return .delete
        }
        let updated = note.updatedObjects.union(note.refreshedObjects)
        if updated.containsObjectIdentical(to: object) {
            return .update
        }
        return nil
    }
}

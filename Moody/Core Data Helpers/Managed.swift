//
//  Managed.swift
//  Moody
//
//  Created by Carl on 2022/8/11.
//

import Foundation
import CoreData

protocol Managed: AnyObject, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescription: [NSSortDescriptor] { get }
}

extension Managed {
    static var defaultSortDescription: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescription
        return request
    }
}

extension Managed where Self: NSManagedObject {
    static var entityName: String {
        return entity().name!
    }
    
    static func fetch(in context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<Self>) -> () = { _ in }) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configurationBlock(request)
        return try! context.fetch(request)
    }
    
    static func findOrCreate(in context: NSManagedObjectContext, matching predicate: NSPredicate, configure: (Self) -> ()) -> Self {
        // 如果对象存在于 coredata 里，那么将作为结果返回
        // 否则通过 insertObject 方法创建一个新的对象，并给 findOrCreate 方法的调用者一个配置这个新创建对象的机会
        guard let object = findOrFetch(in: context, matching: predicate) else {
            let newObject: Self = context.insertObject()
            configure(newObject)
            return newObject
        }
        return object
    }
    
    //
    // 检查我们要寻找的对象是否已经在上下文里注册过
    // 如果没有注册，会尝试使用一个获取请求来加载它
    static func findOrFetch(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        guard let object = materializedObject(in: context, matching: predicate) else {
            return fetch(in: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        return object
    }
    
    // 遍历上下文的 registeredObjects 集合，这个集合包含了上下文当前所知道的所有托管对象
    // 该方法会一直搜索，直到找到一个不是惰值（faulting）、类型正确、并且可以匹配给定谓词的对象
    // 惰值：指还未填充数据的托管对象实例
    static func materializedObject(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        for object in context.registeredObjects where !object.isFault {
            guard let result = object as? Self, predicate.evaluate(with: result) else { continue }
            return result
        }
        return nil
    }
}

//
//  MoodyStack.swift
//  Moody
//
//  Created by Carl on 2022/8/11.
//

import Foundation
import CoreData

func createMoodyContainer(completion: @escaping (NSPersistentContainer) -> ()) {
    // 通过指定名称创建持久化容器
    let container = NSPersistentContainer(name: "Moody")
    // 尝试打开底层的数据库文件，如果不存在，CoreData 会自动生成
    container.loadPersistentStores { _, error in
        guard error == nil else {
            fatalError("Failed to load store: \(error!)")
        }
        
        // 由于持久化存储是异步加载的，一旦存储被加载完成，我们的回调就会被执行
        DispatchQueue.main.async {
            completion(container)
        }
    }
}

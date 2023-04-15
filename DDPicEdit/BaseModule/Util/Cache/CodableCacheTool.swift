//
//  CodableCacheTool.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/13.
//

import UIKit

struct CodableCacheTool: Cacheable {
    
    let module: CacheModule
    let path: String
    let workQueue: DispatchQueue
    
    init(module: CacheModule, path: String = "") {
        self.module = module
        self.path = path.isEmpty ? module.path : path
        self.workQueue = DispatchQueue(label: "org.DDPicEdit.DispatchQueue.CacheTool.\(module.title).\(module.subTitle)")
        FileHelper.createDirectory(at: self.path)
    }
}

extension CodableCacheTool {
    
    /// 写入缓存
    /// - Parameters:
    ///   - model: 模型
    ///   - identifier: 标识符
    func store<T: Codable>(_ model: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(model)
            storeDataToDisk(data, forKey: key)
        } catch {
            _print(error.localizedDescription)
        }
    }
    
    /// 读取缓存
    /// - Parameters:
    ///   - identifier: 标识符
    ///   - cls: 类型
    ///   - deleteDiskStorage: 读取缓存后删除磁盘缓存
    func retrieveModel<T: Codable>(forKey key: String, deleteDiskStorage: Bool = false) -> T? {
        guard let data = retrieveDataInDisk(forKey: key) else { return nil }
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            if deleteDiskStorage {
                removeData(forKey: key)
            }
            return model
        } catch {
            _print(error.localizedDescription)
        }
        return nil
    }
}

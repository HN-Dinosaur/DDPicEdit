//
//  EditorPhotoResource.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/15.
//

import UIKit
import Photos

public protocol EditorPhotoResource {
    func loadImage(completion: @escaping (Result<UIImage, AnyImageError>) -> Void)
}

extension UIImage: EditorPhotoResource {
    
    public func loadImage(completion: @escaping (Result<UIImage, AnyImageError>) -> Void) {
        completion(.success(self))
    }
}

extension URL: EditorPhotoResource {
    
    public func loadImage(completion: @escaping (Result<UIImage, AnyImageError>) -> Void) {
        if self.isFileURL {
            do {
                let data = try Data(contentsOf: self)
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(.invalidImage))
                }
            } catch {
                _print(error.localizedDescription)
                completion(.failure(.invalidData))
            }
        } else {
            completion(.failure(.invalidURL))
        }
    }
}

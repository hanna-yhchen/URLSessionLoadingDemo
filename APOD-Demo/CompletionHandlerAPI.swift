//
//  CompletionHandlerAPI.swift
//  APOD-Demo
//
//  Created by Hanna Chen on 2022/5/13.
//

import Foundation
import UIKit

struct CompletionHandlerAPI {
    static func fetchPicture(from url: URL, completion: @escaping (Result<PictureInfo, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let info = try JSONDecoder().decode(PictureInfo.self, from: data)
                    completion(.success(info))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    static func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else if let error = error {
                print("Error loading image", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
}

//
//  AsyncFunctionAPI.swift
//  APOD-Demo
//
//  Created by Hanna Chen on 2022/5/13.
//

import Foundation
import UIKit

struct AsyncFunctionAPI {
    static func fetchPicture(from url: URL) async throws -> PictureInfo {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PictureInfo.self, from: data)
    }

    static func loadImage(from url: URL) async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
}

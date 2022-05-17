//
//  GenericService.swift
//  APOD-Demo
//
//  Created by Hanna Chen on 2022/5/17.
//

import UIKit

protocol APIService {
    associatedtype Response

    var url: URL { get }

    func fetch() async throws -> Response
}

struct PictureInfoService: APIService {
    var url: URL

    func fetch() async throws -> PictureInfo {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PictureInfo.self, from: data)
    }
}

struct ImageService: APIService {
    var url: URL

    func fetch() async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
}

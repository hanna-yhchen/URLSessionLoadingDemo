//
//  CombineAPI.swift
//  APOD-Demo
//
//  Created by Hanna Chen on 2022/5/13.
//

import Foundation
import Combine
import UIKit

struct CombineAPI {
    static func picturePublisher(from url: URL) -> AnyPublisher<PictureInfo, Error> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PictureInfo.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    static func imagePublisher(from url: URL) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .map{ UIImage(data: $0) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

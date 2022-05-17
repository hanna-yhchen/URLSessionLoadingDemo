//
//  PictureInfo.swift
//  APOD-Demo
//
//  Created by Hanna Chen on 2022/5/13.
//

import Foundation

struct PictureInfo: Decodable {
    let title: String
    let description: String
    let url: URL

    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
    }
}

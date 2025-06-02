//
//  DefaultEnvironment.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-02.
//

import Foundation
import SBNetworking

struct DefaultEnvironment: HttpClientProtocol {
    private static let scheme: String = {
        PlistReader.stringValue(for: "API_SCHEME")
    }()

    private static let baseURL: String = {
        PlistReader.stringValue(for: "API_BASE_URL")
    }()

    let environment = HTTPClientEnvironment(
        scheme: Self.scheme,
        baseURL: Self.baseURL
    )
}

// MARK: - Image URL

extension DefaultEnvironment {
    private static let imageScheme: String = {
        PlistReader.stringValue(for: "API_IMAGE_SCHEME")
    }()

    private static let imageBaseURL: String = {
        PlistReader.stringValue(for: "API_IMAGE_BASE_URL")
    }()

    private static let imagePath = "/dynamic/480x360c/"

    static func imageURL(for imageName: String) -> URL? {
        var components = URLComponents()
        components.scheme = Self.imageScheme
        components.host = self.imageBaseURL
        components.path = "\(Self.imagePath)\(imageName)"
        return components.url
    }
}

//
//  AdsEndpoint.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-02.
//

import Foundation
import SBNetworking

struct AdsEndpoint: Endpoint {
    typealias ResponseType = AdsResponseModel
    let path = "/baldermork/6a1bcc8f429dcdb8f9196e917e5138bd/raw/discover.json"
    let method: HTTPMethod = .get
}

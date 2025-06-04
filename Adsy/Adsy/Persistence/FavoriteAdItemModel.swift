//
//  FavoriteAdItemModel.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-04.
//

import Foundation
import SwiftData

@Model
final class FavoriteAdItemModel {
    var id: String
    var adType: String
    var desc: String?
    var location: String?
    var priceTotal: Double?
    var imageURL: String?
    
    init(
        id: String,
        adType: String,
        description: String?,
        location: String?,
        priceTotal: Double?,
        imageURL: String?
    ) {
        self.id = id
        self.adType = adType
        self.desc = description
        self.location = location
        self.priceTotal = priceTotal
        self.imageURL = imageURL
    }
}

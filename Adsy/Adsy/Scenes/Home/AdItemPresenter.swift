//
//  AdItemPresenter.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-04.
//

import Foundation

struct AdItemPresenter {
    let description: String
    let price: String
    let location: String
    let imageURL: URL?

    init(
        description: String?,
        price: String?,
        location: String?,
        imageURL: String?
    ) {
        self.description = description ?? "No description"
        self.price = price ?? "Contact Seller"
        self.location = location ?? "Unknown"
        self.imageURL = DefaultEnvironment.imageURL(for: imageURL ?? "")
    }
}

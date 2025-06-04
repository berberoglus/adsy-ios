//
//  AdsResponseModel.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-02.
//

import Foundation

struct AdsResponseModel: Decodable {
    let items: [AdItemModel]?
}

struct AdItemModel: Decodable {
    let id: String
    let adType: AdType
    let description: String?
    let location: String?
    let price: PriceModel?
    let image: ImageModel?

    enum CodingKeys: String, CodingKey {
        case id
        case adType = "ad-type"
        case description
        case location
        case price
        case image
    }
}

struct PriceModel: Decodable {
    let value: Double?
    let total: Double?
}

struct ImageModel: Decodable {
    let url: String?
    let height: Double?
    let width: Double?
}

enum AdType: String, Decodable {
    case realestate = "REALESTATE"
    case bap = "BAP"
    case b2b = "B2B"
    case car = "CAR"
    case other = "OTHER"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = AdType(rawValue: value) ?? .other
    }
}

extension AdItemModel {
    var presenter: AdItemPresenter {
        return AdItemPresenter(
            description: description,
            price: formattedPrice,
            location: location,
            imageURL: image?.url
        )
    }

    var formattedPrice: String {
        guard let value = price?.total,
              let priceString = NumberFormatter.priceFormatter.string(from: NSNumber(value: value)) else {
            return "Contact Seller"
        }

        return priceString
    }
}

// MARK: - Conversion

extension AdItemModel {
    static func fromFavoriteAdItemModel(_ favoriteAdItemModel: FavoriteAdItemModel) -> AdItemModel {
        return AdItemModel(
            id: favoriteAdItemModel.id,
            adType: AdType(rawValue: favoriteAdItemModel.adType)!,
            description: favoriteAdItemModel.desc,
            location: favoriteAdItemModel.location,
            price: nil,
            image: nil
        )
    }

    func toFavoriteAdItemModel() -> FavoriteAdItemModel {
        return FavoriteAdItemModel(
            id: id,
            adType: adType.rawValue,
            description: description,
            location: location,
            priceTotal: price?.total ?? 0,
            imageURL: image?.url
        )
    }
}

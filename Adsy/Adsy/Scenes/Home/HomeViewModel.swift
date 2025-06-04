//
//  HomeViewModel.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-02.
//

import Foundation
import Observation
import SwiftData

@Observable
class HomeViewModel: PersistenceProtocol {

    enum SegmentOption: String, CaseIterable {
        case all = "All"
        case favorites = "Favorites"
    }

    enum ViewState {
        case loading
        case error(_ errorMessage: String)
        case emptyFilteredAds
        case adsLoaded(_ ads: [AdItemModel])
    }

    var viewState: ViewState = .loading
    private var ads: [AdItemModel] = []

    var searchText = "" {
        didSet {
            filterAds()
        }
    }

    var selectedSegment: SegmentOption = .all {
        didSet {
            filterAds()
        }
    }

    private let httpClient = HTTPClientWrapper()
    private(set) var modelContext: ModelContext?

    func setModelContext(_ modelContext: ModelContext?) {
        self.modelContext = modelContext
    }

    func loadAds() {
        viewState = .loading
        selectedSegment = .all
        searchText = ""

        let endpoint = AdsEndpoint()
        Task { @MainActor in
            do {
                let response = try await httpClient.client.submitRequest(endpoint: endpoint)
                ads = response?.items ?? []
                viewState = ads.isEmpty ? .emptyFilteredAds : .adsLoaded(ads)
            } catch {
                viewState = .error(error.localizedDescription)
            }
        }
    }

    private func filterAds() {
        var filteredAds = [AdItemModel]()
        switch selectedSegment {
        case .all:
            filteredAds = ads
        case .favorites:
            let favoriteItems: [FavoriteAdItemModel] = fetchItems()
            filteredAds = favoriteItems.map { AdItemModel.fromFavoriteAdItemModel($0) }
        }

        if !searchText.isEmpty {
            filteredAds = filteredAds.filter { ad in
                let descriptionMatch = ad.description?.lowercased().contains(searchText.lowercased()) ?? false
                let locationMatch = ad.location?.lowercased().contains(searchText.lowercased()) ?? false
                return descriptionMatch || locationMatch
            }
        }
        viewState = filteredAds.isEmpty ? .emptyFilteredAds : .adsLoaded(filteredAds)
    }
}

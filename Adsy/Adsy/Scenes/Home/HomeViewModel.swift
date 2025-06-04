//
//  HomeViewModel.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-02.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

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
    private var favoriteIds: Set<String> = []

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
        loadFavoriteIds()
    }

    func loadAds() {
        viewState = .loading
        selectedSegment = .all
        searchText = ""
        loadFavoriteIds()

        let endpoint = AdsEndpoint()
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await self.httpClient.client.submitRequest(endpoint: endpoint)
                self.ads = response?.items ?? []
                self.viewState = self.ads.isEmpty == true ? .emptyFilteredAds : .adsLoaded(self.ads)
            } catch {
                self.viewState = .error(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Favorites Management
    
    func isFavorite(adId: String) -> Bool {
        return favoriteIds.contains(adId)
    }
    
    func toggleFavorite(for adId: String) {
        guard let ad = ads.first(where: { $0.id == adId }) else {
            return
        }

        if isFavorite(adId: adId) {
            guard let favoriteToRemove: FavoriteAdItemModel = fetchItems().first(where: { $0.id == adId }) else {
                return
            }

            removeItem(favoriteToRemove)
            favoriteIds.remove(adId)
        } else {
            let favoriteItem = ad.toFavoriteAdItemModel()
            addItem(favoriteItem)
            favoriteIds.insert(adId)
        }
    }
    
    private func loadFavoriteIds() {
        let favorites: [FavoriteAdItemModel] = fetchItems()
        favoriteIds = Set(favorites.map { $0.id })
    }

    // MARK: - Filtering

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

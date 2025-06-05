//
//  HomeViewModel.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-02.
//

import Foundation
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
        case emptyFilteredAds(_ state: EmptyState)
        case adsLoaded(_ ads: [AdItemModel])
    }

    enum EmptyState {
        case noResults
        case noResultForSearch
        case noFavorites
        case noAdsForSelectedAdFilterType
    }

    var viewState: ViewState = .loading
    private var ads: [AdItemModel] = []
    private var favoriteIds: Set<String> = []
    
    var selectedAdTypeFilter: AdType? {
        didSet {
            filterAds()
        }
    }

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

    var filterTypes: [(title: String, filter: AdType?)] {
        var filters: [(title: String, filter: AdType?)] = [(title: "All Types", filter: nil)]
        AdType.allCases.forEach { adType in
            filters.append((title: adType.title, filter: adType))
        }
        return filters
    }

    private let httpClient = HTTPClientWrapper()
    private(set) var modelContext: ModelContext?

    func setModelContext(_ modelContext: ModelContext?) {
        self.modelContext = modelContext
    }

    func fetchAds() {
        viewState = .loading
        selectedSegment = .all
        searchText = ""
        selectedAdTypeFilter = nil
        fetchFavorites()

        let endpoint = AdsEndpoint()
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let response = try await self.httpClient.client.submitRequest(endpoint: endpoint)
                self.ads = response?.items ?? []
                self.viewState = self.ads.isEmpty == true ? .emptyFilteredAds(.noResults) : .adsLoaded(self.ads)
            } catch {
                self.viewState = .error(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Favorites Management

    @discardableResult
    private func fetchFavorites() -> [FavoriteAdItemModel] {
        let favorites: [FavoriteAdItemModel] = fetchItems()
        favoriteIds = Set(favorites.map { $0.id })
        return favorites
    }

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

    // MARK: - Filtering
    
    func resetFilters() {
        selectedAdTypeFilter = nil
        searchText = ""
        filterAds()
    }

    private func filterAds() {
        var filteredAds = [AdItemModel]()

        switch selectedSegment {
        case .all:
            filteredAds = ads
        case .favorites:
            let favoriteItems = fetchFavorites()
            filteredAds = favoriteItems.map { AdItemModel.fromFavoriteAdItemModel($0) }
        }

        if let adTypeFilter = selectedAdTypeFilter {
            filteredAds = filteredAds.filter { $0.adType == adTypeFilter }
        }

        if !searchText.isEmpty {
            filteredAds = filteredAds.filter { ad in
                let descriptionMatch = ad.description?.lowercased().contains(searchText.lowercased()) ?? false
                let locationMatch = ad.location?.lowercased().contains(searchText.lowercased()) ?? false
                return descriptionMatch || locationMatch
            }
        }

        if !filteredAds.isEmpty {
            viewState = .adsLoaded(filteredAds)
            return
        }

        if !searchText.isEmpty {
            viewState = .emptyFilteredAds(.noResultForSearch)
        } else if selectedSegment == .favorites {
            viewState = .emptyFilteredAds(.noFavorites)
        } else if selectedAdTypeFilter != nil {
            viewState = .emptyFilteredAds(.noAdsForSelectedAdFilterType)
        }
    }
}

private extension AdType {
    var title: String {
        switch self {
        case .realestate:
            return "Real Estate"
        case .bap:
            return "BAP"
        case .b2b:
            return "Business"
        case .car:
            return "Vehicles"
        case .other:
            return "Other"
        }
    }
}

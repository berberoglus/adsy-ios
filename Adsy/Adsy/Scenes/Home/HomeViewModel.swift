//
//  HomeViewModel.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-02.
//

import Foundation
import Observation

@Observable
class HomeViewModel {
    enum FilterType {
        case all
        case favorites
    }

    enum ViewState {
        case loading
        case error(_ errorMessage: String)
        case emptyFilteredAds
        case adsLoaded(_ ads: [AdItemModel])
    }

    var viewState: ViewState = .loading
    private var ads: [AdItemModel] = []
//    var filteredAds: [AdItemModel] = []
//    var isLoading = false
//    var errorMessage: String?

    var searchText = "" {
        didSet {
            filterAds(searchText: searchText, filter: currentFilter)
        }
    }

    var currentFilter: FilterType = .all {
        didSet {
            filterAds(searchText: searchText, filter: currentFilter)
        }
    }
    
    private let httpClient = HTTPClientWrapper()
    
    func loadAds() {
        viewState = .loading
        currentFilter = .all
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
    
    private func filterAds(searchText: String, filter: FilterType) {
        var filtered = ads

        if !searchText.isEmpty {
            filtered = filtered.filter { ad in
                let descriptionMatch = ad.description?.lowercased().contains(searchText.lowercased()) ?? false
                let locationMatch = ad.location?.lowercased().contains(searchText.lowercased()) ?? false
                return descriptionMatch || locationMatch
            }
        }

        // TODO: 🔥 fix it later
        if filter == .favorites {
            filtered = filtered.filter { $0.id.hashValue % 25 == 0 }
        }

        viewState = filtered.isEmpty ? .emptyFilteredAds : .adsLoaded(filtered)
    }
}

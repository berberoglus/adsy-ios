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
            filterAds(searchText: searchText, filter: selectedSegment)
        }
    }

    var selectedSegment: SegmentOption = .all {
        didSet {
            filterAds(searchText: searchText, filter: selectedSegment)
        }
    }
    
    private let httpClient = HTTPClientWrapper()
    
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
    
    private func filterAds(searchText: String, filter: SegmentOption) {
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

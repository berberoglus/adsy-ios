//
//  HomeSceneView.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-02.
//

import SwiftUI
import Observation

struct HomeSceneView: View {

    enum SegmentOption: String, CaseIterable {
        case all = "All"
        case favorites = "Favorites"
    }

    @State private var viewModel = HomeViewModel()
    @State private var selectedSegment: SegmentOption = .all
    
    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                segmentedControlView
                containerView
            }
            .searchable(text: $viewModel.searchText, prompt: "Search Ads")
            .navigationTitle("Adsy")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedSegment) { _, newValue in
                viewModel.currentFilter = newValue == .all ? .all : .favorites
            }
            .onAppear {
                viewModel.loadAds()
            }
        }
    }
}

// MARK: - Subviews

private extension HomeSceneView {

    private var segmentedControlView: some View {
        return SegmentedControlView(
            selectedValue: $selectedSegment,
            options: SegmentOption.allCases.map { ($0.rawValue, $0) }
        )
        .padding(.horizontal, 16.0)
    }

    @ViewBuilder
    private var containerView: some View {
        switch viewModel.viewState {
        case .loading:
            loadingView
        case .error(let errorMessage):
            errorView(errorMessage)
        case .emptyFilteredAds:
            emptyFilterView
        case .adsLoaded(let ads):
            adsListView(ads)
        }
    }

    private var loadingView: some View {
        ProgressView("Loading ads...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyFilterView: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.sfProRegular(size: 48.0))
                .foregroundStyle(Color.sbSecondaryText)

            Text("No ads found")
                .font(.sfProSemibold(size: 17.0))
                .foregroundStyle(Color.sbPrimaryText)

            if !viewModel.searchText.isEmpty {
                Text("Try to search for another term")
                    .font(.sfProRegular(size: 15.0))
                    .foregroundColor(.sbSecondaryText)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(_ errorMessage: String) -> some View {
        VStack(spacing: 8.0) {
            Text("Error loading ads")
                .font(.sfProSemibold(size: 17.0))
                .foregroundStyle(Color.sbPrimaryText)
            
            Text(errorMessage)
                .font(.sfProRegular(size: 15.0))
                .foregroundStyle(Color.sbSecondaryText)
            
            Button {
                viewModel.loadAds()
            } label: {
                Text("Retry")
                    .foregroundStyle(Color.sbConstantText)
                    .font(.sfProSemibold(size: 15.0))
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func adsListView(_ ads: [AdItemModel]) -> some View {
        ScrollView {
            LazyVStack(spacing: 12.0) {
                ForEach(ads, id: \.id) { ad in
                    AdRowView(
                        presenter: ad.presenter
                    )
                    .padding(.horizontal, 16.0)
                }
            }
            .padding(.top, 12.0)
        }
    }
}

#Preview {
    HomeSceneView()
}

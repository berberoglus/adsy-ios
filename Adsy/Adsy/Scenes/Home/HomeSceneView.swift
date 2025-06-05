//
//  HomeSceneView.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-02.
//

import SwiftUI

struct HomeSceneView: View {

    private enum LayoutConstants {
        static let listSpacing: CGFloat = 12.0
        static let horizontalPadding: CGFloat = 16.0
        static let gridSpacing: CGFloat = 8.0
        static let gridColumns = 2
    }

    enum ViewMode {
        case list
        case grid
    }

    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = HomeViewModel()
    @State private var viewMode: ViewMode = .list
    @State private var shouldShowFilterView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                segmentedControlView
                containerView
            }
            .background(Color.sbMainBackground)
            .searchable(text: $viewModel.searchText, prompt: "Search Ads")
            .navigationTitle("Adsy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            viewMode = viewMode == .list ? .grid : .list
                        }
                    } label: {
                        Image(systemName: viewMode == .list ? "square.grid.2x2" : "list.bullet")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        shouldShowFilterView = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .onAppear {
                viewModel.setModelContext(modelContext)
                viewModel.fetchAds()
            }
            .sheet(isPresented: $shouldShowFilterView) {
                AdTypeFilterView(
                    selectedFilter: $viewModel.selectedAdTypeFilter,
                    isPresented: $shouldShowFilterView
                )
                .presentationDetents([.medium])
            }
        }
    }
}

// MARK: - Subviews

private extension HomeSceneView {

    private var segmentedControlView: some View {
        SegmentedControlView(
            selectedValue: $viewModel.selectedSegment,
            options: HomeViewModel.SegmentOption.allCases.map { ($0.rawValue, $0) }
        )
        .padding(.horizontal, LayoutConstants.horizontalPadding)
    }

    @ViewBuilder
    private var containerView: some View {
        switch viewModel.viewState {
        case .loading:
            loadingView
        case .error(let errorMessage):
            errorView(errorMessage)
        case .emptyFilteredAds(let state):
            emptyFilterView(for: state)
        case .adsLoaded(let ads):
            contentView(ads)
        }
    }

    @ViewBuilder
    private func contentView(_ ads: [AdItemModel]) -> some View {
        if viewMode == .list {
            adsListView(ads)
        } else {
            adsGridView(ads)
        }
    }

    private var loadingView: some View {
        ProgressView("Loading ads...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func emptyFilterView(for state: HomeViewModel.EmptyState) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.sfProRegular(size: 48.0))
                .foregroundStyle(Color.sbSecondaryText)

            Text("No ads found")
                .font(.sfProSemibold(size: 17.0))
                .foregroundStyle(Color.sbPrimaryText)

            Group {
                switch state {
                case .noResults:
                    EmptyView()
                case .noResultForSearch:
                    Text("Try to search for another term")
                case .noFavorites:
                    Text("Add items to your favorites")
                case .noAdsForSelectedAdFilterType:
                    Text("No ads in this category")
                    Button {
                        viewModel.resetFilters()
                    } label: {
                        Label("Clear Filters", systemImage: "xmark.circle")
                            .foregroundStyle(Color.sbConstantText)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .padding(.top, 8.0)
                }
            }
            .font(.sfProRegular(size: 15.0))
            .foregroundStyle(Color.sbSecondaryText)
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
                viewModel.fetchAds()
            } label: {
                Label("Retry", systemImage: "arrow.clockwise")
                    .foregroundStyle(Color.sbConstantText)
                    .font(.sfProSemibold(size: 15.0))
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func adsListView(_ ads: [AdItemModel]) -> some View {
        ScrollView {
            LazyVStack(spacing: LayoutConstants.listSpacing) {
                ForEach(ads, id: \.id) { ad in
                    AdRowView(
                        presenter: ad.presenter,
                        viewModel: viewModel
                    )
                    .padding(.horizontal, LayoutConstants.horizontalPadding)
                }
            }
            .padding(.top, LayoutConstants.listSpacing)
        }
    }

    private func adsGridView(_ ads: [AdItemModel]) -> some View {
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: LayoutConstants.gridSpacing),
            count: LayoutConstants.gridColumns
        )

        return ScrollView {
            LazyVGrid(columns: columns, spacing: LayoutConstants.gridSpacing) {
                ForEach(ads, id: \.id) { ad in
                    AdGridView(
                        presenter: ad.presenter,
                        viewModel: viewModel
                    )
                }
            }
            .padding(.horizontal, LayoutConstants.horizontalPadding)
        }
    }
}

#Preview {
    HomeSceneView()
}

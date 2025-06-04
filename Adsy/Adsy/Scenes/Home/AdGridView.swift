//
//  AdGridItemView.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-03.
//

import SwiftUI

struct AdGridView: View {

    let presenter: AdItemPresenter
    let viewModel: HomeViewModel
    
    private var isFavorite: Bool {
        viewModel.isFavorite(adId: presenter.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            imageView
            infoView
        }
        .padding(8.0)
        .background(Color.sbSecondaryContent)
        .cornerRadius(8.0)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color.sbBorder, lineWidth: 1.0)
        )
    }
}

// MARK: - Subviews

private extension AdGridView {
    
    private var imageView: some View {
        CachedAsyncImageView(url: presenter.imageURL)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(4.0 / 3.0, contentMode: .fit)
            .cornerRadius(4.0)
            .background(
                Rectangle()
                    .fill(Color.sbPrimaryContent)
            )
            .overlay(alignment: .topTrailing) {
                Button {
                    viewModel.toggleFavorite(for: presenter.id)
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.sfProSemibold(size: 20.0))
                        .foregroundStyle(isFavorite ? Color.red : Color.white)
                        .padding(8.0)
                        .background(
                            Circle()
                                .fill(Color.black.opacity(0.3))
                        )
                }
                .animation(.spring, value: isFavorite)
                .padding(8.0)
            }
    }
    
    private var infoView: some View {
        Group {
            Text(presenter.price)
                .font(.sfProSemibold(size: 16.0))
                .foregroundStyle(Color.sbPrimaryText)
            
            Text(presenter.description)
                .font(.sfProRegular(size: 12.0))
                .foregroundStyle(Color.sbSecondaryText)
            
            HStack(spacing: 2) {
                Image(systemName: "location.fill")
                    .font(.sfProRegular(size: 12.0))
                
                Text(presenter.location)
                    .font(.sfProRegular(size: 12.0))
            }
            .foregroundStyle(Color.sbSecondaryText)
        }
    }
}

#Preview {
    AdGridView(
        presenter: AdItemPresenter(
            id: "1",
            description: "Beautiful apartment in the city center",
            price: "4 000 000 kr",
            location: "Downtown",
            imageURL: "https://example.com/image.jpg"
        ),
        viewModel: HomeViewModel()
    )
    .padding(.horizontal, 32.0)
}

//
//  AdGridItemView.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-03.
//

import SwiftUI

struct AdGridItemView: View {
    let presenter: AdItemPresenter
    @State private var isFavorite: Bool = false
    
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

private extension AdGridItemView {
    
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
                    isFavorite.toggle()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.sfProSemibold(size: 20.0))
                        .foregroundColor(isFavorite ? .red : .white)
                        .padding(8.0)
                        .background(
                            Circle()
                                .fill(Color.black.opacity(0.3))
                        )
                }
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
    AdGridItemView(
        presenter: AdItemPresenter(
            description: "Beautiful apartment in the city center",
            price: "4 000 000 kr",
            location: "Downtown",
            imageURL: URL(string: "https://example.com/image.jpg")
        )
    )
    .padding(.horizontal, 32.0)
}

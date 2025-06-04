//
//  AdCardView.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-03.
//

import SwiftUI

struct AdRowView: View {

    @State private var isFavorite: Bool = false
    let presenter: AdItemPresenter

    var body: some View {
        HStack(alignment: .top, spacing: 8.0) {
            imageView
            infoView
        }
        .padding(.all, 8.0)
        .background(Color.sbSecondaryContent)
        .cornerRadius(4.0)
        .overlay(
            RoundedRectangle(cornerRadius: 4.0)
                .stroke(Color.sbBorder, lineWidth: 1.0)
        )
    }
}

// MARK: - Subviews

private extension AdRowView {

    private var imageView: some View {
        CachedAsyncImageView(url: presenter.imageURL)
            .frame(width: 120.0, height: 90.0)
            .background(
                Rectangle()
                    .fill(Color.sbPrimaryContent)
            )
    }

    private var infoView: some View {
        return VStack(alignment: .leading, spacing: 4.0) {
            HStack {
                Text(presenter.price)
                    .foregroundStyle(Color.sbPrimaryText)
                    .font(.sfProSemibold(size: 18.0))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button {
                    isFavorite.toggle()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.sfProSemibold(size: 24.0))
                        .foregroundColor(isFavorite ? .red : .sbPrimaryText)
                }
            }

            Text(presenter.description)
                .font(.sfProRegular(size: 13.0))
                .foregroundColor(.sbSecondaryText)

            HStack(spacing: 2.0) {
                Image(systemName: "location.fill")
                    .font(.sfProSemibold(size: 15.0))

                Text(presenter.location)
                    .font(.sfProSemibold(size: 15.0))
            }
            .foregroundStyle(Color.sbSecondaryText)
        }
    }
}

// MARK: - Preview

#Preview {
    AdRowView(
        presenter: AdItemPresenter(
            description: "Beautiful apartment in the city center",
            price: "4 500 000 SEK",
            location: "Arendal",
            imageURL: URL(string: "https://example.com/image.jpg")
        )
    )
    .padding()
}

//
//  CachedAsyncImageView.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-03.
//

import SwiftUI

struct CachedAsyncImageView: View {
    @State private var isLoading = false
    @State private var image: Image?
    @State private var isLoadFailed = false
    @State private var hasAttemptedLoad = false
    @State private var loadingTask: URLSessionDataTask?

    let url: URL?

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if isLoadFailed {
                placeholderImage
            } else if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                placeholderImage
            }
        }
        .onAppear {
            loadImage()
        }
        .onDisappear {
            cancelLoading()
        }
        .id(url?.absoluteString ?? "placeholder")
    }
}

// MARK: - Subviews

private extension CachedAsyncImageView {
    private var placeholderImage: some View {
        return Image(systemName: "photo")
            .font(.sfProRegular(size: 20.0))
    }
}

// MARK: - Helpers

private extension CachedAsyncImageView {

    private static var cache = NSCache<NSURL, UIImage>()
    private static var failedURLs = Set<String>()
    
    private func cancelLoading() {
        loadingTask?.cancel()
        loadingTask = nil
        if isLoading {
            isLoading = false
        }
    }

    private func loadImage() {
        cancelLoading()

        if image != nil || hasAttemptedLoad { return }
        hasAttemptedLoad = true

        guard let url = url else {
            isLoadFailed = true
            return
        }

        if Self.failedURLs.contains(url.absoluteString) {
            isLoadFailed = true
            return
        }

        if let cachedImage = Self.image(for: url) {
            setImage(cachedImage)
            return
        }

        isLoading = true

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                return
            }
            
            DispatchQueue.main.async {
                isLoading = false
                
                if error != nil {
                    Self.failedURLs.insert(url.absoluteString)
                    isLoadFailed = true
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let data = data,
                      let uiImage = UIImage(data: data) else {
                    Self.failedURLs.insert(url.absoluteString)
                    isLoadFailed = true
                    return
                }

                Self.insertImage(uiImage, for: url)
                setImage(uiImage)
            }
        }
        
        loadingTask = task
        task.resume()
    }

    private func setImage(_ uiImage: UIImage) {
        image = Image(uiImage: uiImage)
    }

    private static func image(for url: URL?) -> UIImage? {
        guard let url = url else { return nil }
        return cache.object(forKey: url as NSURL)
    }

    private static func insertImage(_ image: UIImage, for url: URL?) {
        guard let url = url else { return }
        cache.setObject(image, forKey: url as NSURL)
    }
}

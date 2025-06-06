//
//  AdsyApp.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-02.
//

import SwiftUI
import SwiftData

@main
struct AdsyApp: App {
    var body: some Scene {
        WindowGroup {
            HomeSceneView()
        }
        .modelContainer(for: FavoriteAdItemModel.self)
    }
}

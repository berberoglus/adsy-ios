//
//  Font+extensions.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-03.
//

import SwiftUI

extension Font {
    static func sfProSemibold(size: CGFloat) -> Font {
        return .system(size: size, weight: .semibold)
    }
    
    static func sfProRegular(size: CGFloat) -> Font {
        return .system(size: size, weight: .regular)
    }
} 

//
//  AdTypeFilterView.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-04.
//

import SwiftUI

struct AdTypeFilterView: View {
    @Binding var selectedFilter: AdType?
    @Binding var isPresented: Bool
    
    private let adTypes: [AdType?] = [nil, .realestate, .car, .bap, .b2b, .other]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(adTypes, id: \.self) { adType in
                    Button {
                        selectedFilter = adType
                        isPresented = false
                    } label: {
                        HStack {
                            Text(displayName(for: adType))
                                .foregroundStyle(Color.sbPrimaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if adType == selectedFilter {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        selectedFilter = nil
                    }
                }
            }
        }
    }
    
    private func displayName(for adType: AdType?) -> String {
        guard let adType = adType else {
            return "All Types"
        }
        
        switch adType {
        case .realestate:
            return "Real Estate"
        case .bap:
            return "BAP"
        case .b2b:
            return "Business"
        case .car:
            return "Vehicles"
        case .other:
            return "Other"
        }
    }
}

#Preview {
    AdTypeFilterView(
        selectedFilter: .constant(.car),
        isPresented: .constant(true)
    )
} 

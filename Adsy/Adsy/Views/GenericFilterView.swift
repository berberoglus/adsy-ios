//
//  GenericFilterView.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-04.
//

import SwiftUI

struct GenericFilterView<FilterValue: Hashable>: View {
    @Binding var selectedFilter: FilterValue?
    @Binding var isPresented: Bool
    
    let filterTypes: [(title: String, filter: FilterValue?)]

    var body: some View {
        NavigationStack {
            List {
                ForEach(filterTypes.indices, id: \.self) { index in
                    Button {
                        selectedFilter = filterTypes[index].filter
                        isPresented = false
                    } label: {
                        HStack {
                            Text(filterTypes[index].title)
                                .foregroundStyle(Color.sbPrimaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if filterTypes[index].filter == selectedFilter {
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
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    let filters = AdType.allCases.map {
        (title: $0.rawValue, filter: $0)
    }
    GenericFilterView(
        selectedFilter: .constant(filters[0].filter),
        isPresented: .constant(true),
        filterTypes: filters
    )
} 

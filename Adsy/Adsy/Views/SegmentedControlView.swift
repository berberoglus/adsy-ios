//
//  SegmentedControlView.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-02.
//

import SwiftUI

struct SegmentedControlView<SelectionValue: Hashable>: View {

    @Binding var selectedValue: SelectionValue
    let options: [(title: String, value: SelectionValue)]

    var body: some View {
        Picker("Segment", selection: $selectedValue) {
            ForEach(options.indices, id: \.self) { index in
                let option = options[index]
                Text(options[index].title)
                    .tag(option.value)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    struct PreviewWrapper: View {
        enum SegmentOption: String, CaseIterable {
            case first = "First"
            case second = "Second"
            case third = "Third"
            case fourth = "Fourth"
        }

        @State private var selectedFilter: SegmentOption = .first

        var body: some View {
            SegmentedControlView(
                selectedValue: $selectedFilter,
                options: SegmentOption.allCases.map { ($0.rawValue, $0) }
            )
            .padding()
        }
    }

    return PreviewWrapper()
}

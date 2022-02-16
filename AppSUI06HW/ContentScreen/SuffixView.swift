//
//  SuffixView.swift
//  AppSUI06HW
//
//  Created by Konstantin Zaharev on 28.01.2022.
//

import SwiftUI

struct SuffixView: View {
    @State private var selectedList: ListType = .all

    var body: some View {
        VStack {
            Picker("Choose suffix list type", selection: $selectedList) {
                ForEach(ListType.allCases, id: \.self) { listType in
                    Text(listType.label)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            Group{
                switch selectedList {
                case .all: SuffixAllListView()
                case .top: SuffixTopListView()
                }
            }
            
            Spacer()
        }
    }
}

struct SuffixAllListView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Picker("Sort type", selection: $viewModel.sortType) {
                ForEach(SortType.allCases, id: \.self) { sortType in
                    Text(sortType.label).tag(sortType)
                }
            }
            .onChange(of: viewModel.sortType, perform: { sortType in
                Task {
                    await viewModel.sortAllSuffixes()
                }
            })
            
            List {
                ForEach(viewModel.allSuffixes, id: \.0) { suffixAndOccurrences in
                    SuffixCellView(suffixAndOccurrences: suffixAndOccurrences)
                }
            }
        }
    }
}

struct SuffixTopListView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.topSuffixes, id: \.0) { suffixAndOccurrences in
                SuffixCellView(suffixAndOccurrences: suffixAndOccurrences)
            }
        }
    }
}

struct SuffixCellView: View {
    var suffixAndOccurrences: (String, Int)
    
    var body: some View {
        Text(suffixAndOccurrences.1 == 1 ? "\(suffixAndOccurrences.0)" : "\(suffixAndOccurrences.0) - \(suffixAndOccurrences.1)")
    }
}

private enum ListType: CaseIterable {
    case all
    case top

    var label: String {
        get {
            switch self {
            case .all:
                return "All"
            case .top:
                return "Top 10"
            }
        }
    }
}

struct SuffixView_Previews: PreviewProvider {
    static var previews: some View {
        SuffixView()
    }
}

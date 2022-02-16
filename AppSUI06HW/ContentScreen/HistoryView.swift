//
//  HistoryView.swift
//  AppSUI06HW
//
//  Created by Konstantin Zaharev on 16.02.2022.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.history.enumerated().reversed(), id: \.offset) { result in
                HistoryCellView(result: result.element)
            }
        }
    }
}

struct HistoryCellView: View {
    var result: (String, CFAbsoluteTime)
    
    var body: some View {
        Text("\(result.0) - \(result.1)")
    }
}

//
//  ContentView.swift
//  AppSUI06HW
//
//  Created by Konstantin Zaharev on 28.01.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel = ContentViewModel()
    @State private var tabType: TabType = .search
    
    var body: some View {
        TabView(selection: $tabType) {
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "text.magnifyingglass")
                }
                .tag(TabType.search)
            SuffixView()
                .tabItem {
                    Label("Suffix", systemImage: "a.magnify")
                }
                .tag(TabType.suffix)
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .tag(TabType.history)
        }
        .environmentObject(viewModel)
        .onOpenURL { url in
            tabType = url.absoluteString == "widget://suffix-view" ? .suffix : .search
            print("Received deep link: \(url)")
            Task {
                await viewModel.getSuffixes()
            }
        }
        .task {
            await viewModel.getSuffixes()
        }
    }
}

private enum TabType {
    case search
    case suffix
    case history
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

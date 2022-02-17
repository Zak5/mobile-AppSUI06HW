//
//  ContentViewModel.swift
//  AppSUI06HW
//
//  Created by Konstantin Zaharev on 29.01.2022.
//

import SwiftUI
import WidgetKit
import Combine

@MainActor
final class ContentViewModel: ObservableObject {
    
    @Published var allSuffixes = [(String, Int)]()
    @Published var topSuffixes = [(String, Int)]()
    @Published var sortType = SortType.asc
    @Published var userText = ""
    @Published var executionTime: CFAbsoluteTime?
    @Published var history = [(String, CFAbsoluteTime)]()
    @Published var searchText = "" {
        didSet {
            Task {
                executionTime = await searchQueue.run()
                guard let executionTime = executionTime else { return }
                history.append((searchText, executionTime))
                let time = Double(executionTime)
                if time > maxTime {
                    maxTime = time
                }
                if time < minTime || minTime == 0.0 {
                    minTime = time
                }
            }
        }
    }

    
    @AppStorage("statistics", store: UserDefaults(suiteName: "group.com.zakk.AppSUI06HW"))
    var statisticsData: Data = Data()
    
    var occurrences: Int?

    private var statistics = [SearchResult]()

    private var uniqueSuffixes = [String: Int]()
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var searchQueue = JobQueue()

    private var maxTime = 0.0, minTime = 0.0
    
    init() {
        searchQueue = JobScheduler.shared.queue(id: "searchQueue")
        searchQueue.jobs.append { [weak self] in
            guard let self = self else { return }
            self.search(self.searchText)
        }
    }

    func getSuffixes() async {
        await loadUserText()
        let suffixArray = userText.suffixArray(minLength: 3)
        for suffix in suffixArray {
            let occurrences = uniqueSuffixes[suffix.0] ?? 0
            uniqueSuffixes[suffix.0] = occurrences + 1
        }
        topSuffixes = Array(uniqueSuffixes.sorted(by: { $0.1 > $1.1 }).prefix(10))
        await sortAllSuffixes()
    }
    
    private func search(_ value: String) {
        occurrences = uniqueSuffixes[searchText] ?? 0
        let searchResult = SearchResult(suffix: searchText, occurrences: occurrences ?? 0)
        statistics.append(searchResult)
        passDataToWidget()
    }
    
    private func passDataToWidget() {
        let lastStatistics = Array(statistics.suffix(3).reversed())
        guard let statisticsData = try? JSONEncoder().encode(lastStatistics) else { return }
        self.statisticsData = statisticsData
    }
    
    func sortAllSuffixes() async {
        if  sortType == .asc {
            allSuffixes = uniqueSuffixes.sorted(by: { $0.0 < $1.0 })
        } else {
            allSuffixes = uniqueSuffixes.sorted(by: { $0.0 > $1.0 })
        }
    }
    
    func loadUserText() async {
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.zakk.AppSUI06HW")?.appendingPathComponent("userText") else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        userText = String(data: data, encoding: .utf8)!
    }
    
    func getColor() -> Color {
        
        let diff = maxTime - minTime
        guard diff != 0.0 else { return Color.green }
        
        guard let time = executionTime else { return Color.green }
        let perc = 100 - (Double(time) - minTime) / diff * 100
        
        var r = 0.0, g = 0.0, b = 0.0;
        r  = (perc > 50 ? 1-2*(perc-50)/100.0 : 1.0);
        g = (perc > 50 ? 1.0 : 2*perc/100.0);
        
        return Color(red: r, green: g, blue: b)
    }
}

enum SortType: CaseIterable {
    case asc
    case desc

    var label: String {
        get {
            switch self {
            case .asc:
                return "Ascending"
            case .desc:
                return "Descending"
            }
        }
    }
}

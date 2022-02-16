//
//  JobScheduler.swift
//  AppSUI06HW
//
//  Created by Konstantin Zaharev on 12.02.2022.
//

import Foundation

class JobScheduler {
    
    static let shared = JobScheduler()
    
    private var jobQueues = [String: JobQueue]()
    
    @MainActor func queue(id: String) -> JobQueue {
        if let findQueue = jobQueues[id] {
            return findQueue
        } else {
            let newQueue = JobQueue()
            jobQueues[id] = newQueue
            return newQueue
        }
    }

}

@MainActor
class JobQueue {
    
    var jobs = [() async -> ()]()
    
    func run() async -> CFAbsoluteTime {
        let start = CFAbsoluteTimeGetCurrent()
        for job in jobs {
           await job()
        }
        let diff = CFAbsoluteTimeGetCurrent() - start
        return diff
    }
    
}

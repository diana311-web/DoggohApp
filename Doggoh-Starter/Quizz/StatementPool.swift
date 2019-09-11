//
//  StatementPool.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 02/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct StatementPool {
    
    private var pool: [Statement]
    
    init(data: Dictionary<String, AnyObject>) {
        pool = [Statement]()
        if let statementsCollection = data["questions"] as? [[String: AnyObject]] {
            statementsCollection.forEach( {
                if let statementText = $0["question"] as? String, let options = $0["options"] as? [String], let answer = $0["answer"] as? String {
                    let statement = Statement(statementText: statementText, answer: answer, options: options)
                    pool.append(statement)
                }
            } )
        }
    }
    
    func getQuizQuestions() -> [Statement] {
        var results = [Statement]()
        if pool.count >= 10 {
            var poolCopy = pool
            while results.count < 10 {
                let selectedIndex = Int.random(in: 0..<poolCopy.count)
                results.append(poolCopy[selectedIndex])
                poolCopy.remove(at: selectedIndex)
            }
            return results
        }
        return pool
    }
}

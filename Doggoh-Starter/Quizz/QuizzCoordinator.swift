//
//  QuizzCoordinator.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 04/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

protocol QuizFlowDelegate: class {
    func willStartQuiz(insideNavigationController: UINavigationController)
    func didFinishQuiz()
}

class QuizCoordinator {
    
    private var statements: [Statement]
    private var currentStatementIndex: Int = 0
    private var score: Int = 0
    internal var navigationController: UINavigationController? = nil
    
    weak var flowDelegate: QuizFlowDelegate?
    
    init(statements: [Statement]) {
        self.statements = statements
    }
    
    func startQuiz() {
        if let firstStatement = statements.first,
            let firstQuizVC = getQuizViewController(forStatement: firstStatement, withIndex: 0, inTotal: statements.count) {
            navigationController = UINavigationController(rootViewController: firstQuizVC)
            navigationController?.navigationBar.isHidden = true
            currentStatementIndex = 0
            flowDelegate?.willStartQuiz(insideNavigationController: navigationController!)
        }
    }
    
    func getQuizViewController(forStatement statement: Statement, withIndex index: Int, inTotal total: Int) -> StatementViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "StatementVC") as? StatementViewController
        newViewController?.statement = statement
        newViewController?.itemIndex = index
        newViewController?.totalItems = total
        newViewController?.delegate = self
        return newViewController
    }
    
    func getResultViewController(withScore score: Int) -> ResultsViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "ResultsVC") as? ResultsViewController
        newViewController?.score = score
        newViewController?.maxScore = statements.count
        newViewController?.delegate = self as ResultsDelegate
        return newViewController
    }
}

extension QuizCoordinator: QuizDelegate {
    
    func userDidAnswerQuestions(atIndex: Int, withCorrectAnswer answer: Bool) {
        score += answer ? 1 : 0
        if currentStatementIndex < statements.count - 1 {
            currentStatementIndex += 1
            if let newQuizVC = getQuizViewController(forStatement: statements[currentStatementIndex], withIndex: currentStatementIndex, inTotal: statements.count) {
                navigationController?.pushViewController(newQuizVC, animated: true)
            }
        }
        else if let scoreVC = getResultViewController(withScore: score) {
            navigationController?.pushViewController(scoreVC, animated: true)
        }
    }
}

extension QuizCoordinator: ResultsDelegate {
    func userDidReset() {
        flowDelegate?.didFinishQuiz()
        
    }
}

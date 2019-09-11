//
//  ResultsViewController.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 02/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

protocol ResultsDelegate: class {
    func userDidReset()
}

class ResultsViewController: UIViewController {
    
    var score: Int!
    var maxScore: Int!
    weak var delegate: ResultsDelegate?
    
    @IBOutlet weak var resetButton: StatementButton!
    
    @IBOutlet weak var congratsLabel: UILabel!
    
    @IBAction func resetQuiz(_ sender: Any) {
        delegate?.userDidReset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateInterface()
    }
    
    private func updateInterface() {
        congratsLabel.text = "Congrats! You scored \(score ?? 0) out of \(maxScore!)"
        resetButton.configure(withButtonType: .reset)
    }
}

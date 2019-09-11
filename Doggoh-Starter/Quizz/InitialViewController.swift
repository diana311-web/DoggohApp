import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var startButton: StatementButton!
    
    var score: Int = 0
    var coordinator: QuizCoordinator!
    var myTabBarControler: UITabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func startQuiz(_ sender: Any) {
        if let json =  DogRepository.dataFromJSON(withName: DogRepository.statements2Filename) {
            let pool = StatementPool(data: json)
            let statements = pool.getQuizQuestions()
            coordinator = QuizCoordinator(statements: statements)
            coordinator.flowDelegate = self
            coordinator.startQuiz()
        }
    }
    
}

extension InitialViewController: QuizFlowDelegate {
    func didFinishQuiz(resultVC: UIViewController) {
        print("did finish quiz")
        dismiss(animated: true, completion: nil)
    }
    
    func didFinishQuiz() {
        print("did finish quiz")
        dismiss(animated: true, completion: nil)
    }
    func willStartQuiz(insideNavigationController: UINavigationController) {
        present(insideNavigationController, animated: true, completion: nil)
    }
}


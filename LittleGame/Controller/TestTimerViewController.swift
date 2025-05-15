import UIKit

class TestTimerViewController: UIViewController {
    private let timerView = TimerView(seconds: 14)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 16/255, green: 22/255, blue: 44/255, alpha: 1)
        view.addSubview(timerView)
        timerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timerView.widthAnchor.constraint(equalToConstant: 180),
            timerView.heightAnchor.constraint(equalToConstant: 180)
        ])
        timerView.onTimerEnd = {
            let alert = UIAlertController(title: "時間到！", message: "倒數結束", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        timerView.start()
    }
}

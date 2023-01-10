import UIKit

extension UITextField {
    func defaultUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.font = .systemFont(ofSize: 13)
        self.textColor = .black
        self.addLeftPadding()
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
    }
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
      }
}

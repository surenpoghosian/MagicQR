//
//  QRGeneratorDataView.swift
//  Magic QR
//
//  Created by Garik Hovsepyan on 12.01.24.
//

import UIKit

let urlTextField = UITextField()
let nextButton = UIButton(type: .system)
var dataURL = ""

var viewModel = QRCodeViewModel()


final class QRGeneratorDataView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        urlTextField.placeholder = "Enter URL, e-mail ..."
        urlTextField.borderStyle = .roundedRect
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(urlTextField)
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = UIColor(red: 0.76, green: 0.04, blue: 0.76, alpha: 1.00)
        nextButton.addAction(UIAction(handler: {[self] _ in
            self.nextButtonTapped()
        }), for: .touchUpInside)
        nextButton.layer.cornerRadius = 10
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        
        
        NSLayoutConstraint.activate([
            urlTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nextButton.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 30),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 150),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    private func nextButtonTapped() {
        guard let name = urlTextField.text else { return }
        viewModel.qrCodeData.name = name
        
        // Check if the name is valid
        if viewModel.validateName() {
            dataURL = urlTextField.text!
            let qrGeneratorDataView = QRGeneratorPromptView(urlString: dataURL) // Initialize your new view controller
            navigationController?.pushViewController(qrGeneratorDataView, animated: true)
        } else {
            // Show an error indicating that the name is not valid
        }
    }
}

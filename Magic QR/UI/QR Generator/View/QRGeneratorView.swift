//
//  QRGeneratorView.swift
//  Magic QR
//
//  Created by Garik Hovsepyan on 12.01.24.
//

import UIKit

class QRGeneratorView: UIViewController {
    
    let nameTextField = UITextField()
    let promptTextField = UITextField()
    let nextButton = UIButton(type: .system)
    let generateButton = UIButton()
    
    var viewModel = QRCodeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        
        nameTextField.placeholder = "Enter Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
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
            nameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nextButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 150),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func nextButtonTapped() {
        guard let name = nameTextField.text else { return }
        viewModel.qrCodeData.name = name
        
        if viewModel.validateName() {
            let qrGeneratorDataView = QRGeneratorDataView() // Initialize your new view controller
            navigationController?.pushViewController(qrGeneratorDataView, animated: true)
        } else {

        }
    }
    
    private func generateButtonTapped() {
        guard let url = urlTextField.text, let prompt = promptTextField.text else { return }
        viewModel.qrCodeData.url = url
        viewModel.qrCodeData.prompt = prompt
        
        if viewModel.validateURL() {
            _ = viewModel.generateQRCode()
        } else {

        }
    }
}


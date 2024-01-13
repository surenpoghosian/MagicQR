//
//  QRGeneratorPromptView.swift
//  Magic QR
//
//  Created by Garik Hovsepyan on 12.01.24.
//

import UIKit

class QRGeneratorPromptView: UIViewController {
    var urlString: String
    let promptTextField = UITextField()
    let generateButton = UIButton(type: .system)
    let imageView = UIImageView()
    var viewModel = QRCodeViewModel()
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        promptTextField.placeholder = "Enter a prompt"
        promptTextField.borderStyle = .roundedRect
        promptTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(promptTextField)
        
        generateButton.setTitle("Next", for: .normal)
        generateButton.setTitleColor(.white, for: .normal)
        generateButton.backgroundColor = UIColor(red: 0.76, green: 0.04, blue: 0.76, alpha: 1.00)
        generateButton.addAction(UIAction(handler: {[self] _ in
            self.generateButtonTapped()
        }), for: .touchUpInside)
        generateButton.layer.cornerRadius = 10
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(generateButton)
        
        NSLayoutConstraint.activate([
            promptTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            promptTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            promptTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            generateButton.topAnchor.constraint(equalTo: promptTextField.bottomAnchor, constant: 30),
            generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            generateButton.widthAnchor.constraint(equalToConstant: 150),
            generateButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func generateButtonTapped() {
        guard let name = promptTextField.text else { return }
        viewModel.qrCodeData.name = name

        guard let promptString = promptTextField.text else {
                // Handle the case when promptTextField text is nil
                return
            }

        let queryParams: [String: String] = [
            "url": urlString,
            "prompt": promptString,
            "u_id": "1bed90bf-d7a5-47df-9e4d-7c7744f59cb7"
        ]

        if let generatedURL = buildURL(baseUrl: "http://192.168.0.155:3000/content/generate", queryParams: queryParams) {
            print(generatedURL)
            let task = URLSession.shared.dataTask(with: generatedURL) { [weak self] data, response, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error: \(error)")
                    return
                }

                guard let data = data else {
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let imageURLs = try decoder.decode([String].self, from: data)
                    let url = URL(string: imageURLs.first!)
                 
                    if self.viewModel.validateName() {
                        DispatchQueue.main.async {
                            let outputView = OutputView(imageURL: url!) // Initialize your new view controller
                            self.navigationController?.pushViewController(outputView, animated: true)
                        }
                    } else {
                        // Show an error indicating that the name is not valid
                    }
                    print(imageURLs)

                    // Assuming you want to update the UI with the first image URL
                    if let firstImageURLString = imageURLs.first, let firstImageURL = URL(string: firstImageURLString) {
                        URLSession.shared.dataTask(with: firstImageURL) { imageData, _, _ in
                            if let imageData = imageData, let image = UIImage(data: imageData) {
                                DispatchQueue.main.async {
                                    // Update the UI on the main thread
                                    self.imageView.image = image
                                }
                            }
                        }.resume()
                    }
                } catch {
                    // Handle decoding error
                    print("Decoding error: \(error)")
                }
            }
            task.resume()
        } else {
            // Handle the case when URL construction fails
        }
    }
    
    private func buildURL(baseUrl: String, queryParams: [String: String]) -> URL? {
        var components = URLComponents(string: baseUrl)
        components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url
    }
}


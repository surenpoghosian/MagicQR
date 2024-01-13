//
//  OutputView.swift
//  Magic QR
//
//  Created by Garik Hovsepyan on 12.01.24.
//

import UIKit

class OutputView: UIViewController {

    let imageView = UIImageView()
    let saveButton = UIButton(type: .system)
    let imageURL: URL?

    init(imageURL: URL) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadImage(from: imageURL!)
    }

    private func setupUI() {
        view.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.backgroundColor = UIColor(red: 0.76, green: 0.04, blue: 0.76, alpha: 1.00)
        saveButton.layer.cornerRadius = 10
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 330),
            imageView.heightAnchor.constraint(equalToConstant: 330),

            saveButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }.resume()
    }

    @objc func saveButtonTapped() {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            showAlert(title: "Success", message: "Image saved successfully.")
        }
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

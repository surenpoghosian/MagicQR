//
//  AnalyticsCell.swift
//  Magic QR
//
//  Created by Garik Hovsepyan on 13.01.24.
//

import UIKit

class AnalyticsTableViewCell: UITableViewCell {
    private let circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let scanCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let eyeSymbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = UIColor(red: 0.76, green: 0.04, blue: 0.76, alpha: 1.00)
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    func configure(with analytics: AnalyticsData) {
        if let imageUrl = URL(string: analytics.img_url) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.circleImageView.image = image
                    }
                }
            }
        }

        idLabel.text = "ID: (analytics.q_id)"
        scanCountLabel.text = "\(analytics.scan_count)"
        eyeSymbolImageView.image = UIImage(systemName: "eye.fill")
    }

    private func setupUI() {
        contentView.addSubview(circleImageView)
        contentView.addSubview(idLabel)
        contentView.addSubview(eyeSymbolImageView)
        contentView.addSubview(scanCountLabel)

        circleImageView.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        scanCountLabel.translatesAutoresizingMaskIntoConstraints = false
        eyeSymbolImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            circleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            circleImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleImageView.widthAnchor.constraint(equalToConstant: 40), // Adjust size as needed
            circleImageView.heightAnchor.constraint(equalToConstant: 40),

            idLabel.leadingAnchor.constraint(equalTo: circleImageView.trailingAnchor, constant: 16),
            idLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            eyeSymbolImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            eyeSymbolImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            eyeSymbolImageView.widthAnchor.constraint(equalToConstant: 24), // Adjust size as needed
            eyeSymbolImageView.heightAnchor.constraint(equalToConstant: 24),

            scanCountLabel.leadingAnchor.constraint(equalTo: eyeSymbolImageView.leadingAnchor, constant: 30),
            scanCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
        ])
    }
}




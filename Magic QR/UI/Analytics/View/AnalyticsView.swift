//
//  AnalyticsView.swift
//  Magic QR
//
//  Created by Garik Hovsepyan on 12.01.24.
//

import UIKit

class AnalyticsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var analyticsData: [AnalyticsData] = []
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchAnalyticsData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analyticsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnalyticsCell", for: indexPath) as! AnalyticsTableViewCell
        let analytics = analyticsData[indexPath.row]
        cell.configure(with: analytics)
        return cell
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AnalyticsTableViewCell.self, forCellReuseIdentifier: "AnalyticsCell")
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchAnalyticsData() {
        NetworkManager.shared.fetchAnalyticsData { [weak self] analyticsData in
            guard let self = self, let analyticsData = analyticsData else { return }
            self.analyticsData = analyticsData
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}






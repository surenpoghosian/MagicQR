//
//  NetworkManager.swift
//  Magic QR
//
//  Created by Garik Hovsepyan on 12.01.24.
//
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            do {
                let imageData = try Data(contentsOf: url)
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    completion(image)
                }
            } catch {
                print("Error fetching image: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func fetchAnalyticsData(completion: @escaping ([AnalyticsData]?) -> Void) {
        guard let url = URL(string: "http://192.168.0.155:3000/storage/qr-list?u_id=fb975798-e9e3-4407-858d-52101b4fc295") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let analyticsData = try decoder.decode([AnalyticsData].self, from: data)
                completion(analyticsData)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
}

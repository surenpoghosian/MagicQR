//
//  NetworkManager.swift
//  Magic QR
//
//  Created by Garik Hovsepyan on 12.01.24.
//

import Foundation

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
}

class NetworkManager: NSObject {

    func requestQRCode(url: String, data: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let requestURL = URL(string: url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"  // or "GET" based on your API

        // Set the request body with your data
        let bodyString = "data=\(data)"
        request.httpBody = bodyString.data(using: .utf8)

        let session = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: .main)
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.requestFailed))
                    return
                }

                guard let data = data else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                completion(.success(data))
            }
        }

        task.resume()
    }
}

extension NetworkManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }
}

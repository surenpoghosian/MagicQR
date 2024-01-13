//
//  AnalyticsModel.swift
//  Magic QR
//
//  Created by Garik Hovsepyan on 12.01.24.
//

import Foundation

struct AnalyticsData: Decodable{
    let q_id: String
    let img_url: String
    let scan_count: Int
}

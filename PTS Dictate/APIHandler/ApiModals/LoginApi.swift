//
//  LoginApi.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 30/08/22.
//

import Foundation


// MARK: - LoginAPI
struct LoginAPI: Codable {
    let userID, userName, email, privilege: String?
    let responseCode, responseMsg: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case email, privilege
        case responseCode = "response_code"
        case responseMsg = "response_msg"
    }
}

// MARK: - UploadAPI
struct UploadAPI: Codable {
    let responseCode, responseMsg: String?
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case responseMsg = "response_msg"
    }
}

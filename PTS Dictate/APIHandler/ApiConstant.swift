//
//  ApiConstant.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 30/08/22.
//

import Foundation

//let BaseURL = "https://ios.etranscriptions.com.au/scripts/web_response.php?Case="
let BaseURL = "https://uat.etranscriptions.com.au/scripts/web_response.php?Case="
let MediaURL = ""

//MARK: - Api Paths
enum ApiPath: String{
    case login = "loginCheck"
    case upload = "UploadFile"
}

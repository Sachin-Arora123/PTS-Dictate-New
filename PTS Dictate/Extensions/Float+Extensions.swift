//
//  Float+Extensions.swift
//  PTS Dictate
//
//  Created by Swaraj Samanta on 07/06/23.
//

import Foundation

extension Float {
    
    enum DecimalType:String {
        case Default = "%.0f"
        case ONE = "%.1f"
        case TWO = "%.2f"
        case THREE = "%.3f"
    }
    

    func cleanValue(maxDigit:DecimalType) -> String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: maxDigit.rawValue, self)
    }
   
}



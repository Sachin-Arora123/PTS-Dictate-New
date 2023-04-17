//
//  Extension+AVURLAsset.swift
//  PTS Dictate
//
//  Created by Swaraj Samanta on 11/04/23.
//

import Foundation
import AVFoundation

extension AVURLAsset {
    var fileSize: Int? {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)

        return resourceValues?.fileSize ?? resourceValues?.totalFileSize
    }
}

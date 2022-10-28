//
//  AudioFiles.swift
//  PTS Dictate
//
//  Created by Mohit Soni on 25/10/22.
//

import Foundation


class AudioFiles {
    var audioFiles: [AudioFile] = []

    static var shared: AudioFiles{
        struct singleTon {
            static let instance = AudioFiles()
        }
        return singleTon.instance
    }
}

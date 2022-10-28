//
//  AudioFiles.swift
//  PTS Dictate
//
//  Created by Mohit Soni on 25/10/22.
//

import Foundation

enum UpdateAudioFile {
    case name(String)
    case comment(String)
    case isUploaded(Bool)
    case archivedDays(Int)
    case canEdit(Bool)
    case createdAt(Date)
    
    func update(audio: Int) {
        let instance = AudioFiles.shared
        switch self {
        case .name(let newValue):
            instance.audioFiles[audio].name = newValue
        case .comment(let newValue):
            instance.audioFiles[audio].fileInfo?.comment = newValue
        case .isUploaded(let newValue):
            instance.audioFiles[audio].fileInfo?.isUploaded = newValue
        case .archivedDays(let newValue):
            instance.audioFiles[audio].fileInfo?.archivedDays = newValue
        case .canEdit(let newValue):
            instance.audioFiles[audio].fileInfo?.canEdit = newValue
        case .createdAt(let newValue):
            instance.audioFiles[audio].fileInfo?.createdAt = newValue
        }
        instance.updateAudioFilesOnCoreData()
    }
}

class AudioFiles {
    
    var audioFiles: [AudioFile] = []

    static var shared: AudioFiles{
        struct singleTon {
            static let instance = AudioFiles()
        }
        return singleTon.instance
    }
    
    func deleteAudio(names: [String]) {
        for (index,audio) in audioFiles.enumerated() where names.contains(audio.name ?? "") {
            audioFiles.remove(at: index)
        }
        updateAudioFilesOnCoreData()
    }
    
    func saveNewAudioFile(name: String) {
        AudioFiles.shared.audioFiles.append(AudioFile(name: name, fileInfo: AudioFileInfo(comment: "", isUploaded: false, archivedDays: 1, canEdit: false, createdAt: Date())))
        updateAudioFilesOnCoreData()
    }
    
    func saveNewAudioFile(name: String, comment: String) {
        AudioFiles.shared.audioFiles.append(AudioFile(name: name, fileInfo: AudioFileInfo(comment: comment, isUploaded: false, archivedDays: 1, canEdit: false, createdAt: Date())))
        updateAudioFilesOnCoreData()
    }
    
    func updateAudioFilesOnCoreData() {
        CoreData.shared.audioFiles = audioFiles
        CoreData.shared.dataSave()
        CoreData.shared.getdata()
    }
    
}

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
    case uploadedAt(String)
    case uploadingInProgress(Bool)
    func update(audioName: String) {
        let instance = AudioFiles.shared
        var audio = 0
        for (index, audioFile) in instance.audioFiles.enumerated() where audioName == audioFile.name ?? "" {
            audio = index
        }
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
        case .uploadedAt(let newValue):
            instance.audioFiles[audio].fileInfo?.uploadedAt = newValue
        case .uploadingInProgress(let newValue):
            instance.audioFiles[audio].fileInfo?.uploadingInProgress = newValue
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
    
    func deleteAudio(name: String) {
        for (index, audio) in audioFiles.enumerated() where name == audio.name ?? "" {
            audioFiles.remove(at: index)
        }
        updateAudioFilesOnCoreData()
    }
    
    func saveNewAudioFile(name: String) {
        AudioFiles.shared.audioFiles.append(AudioFile(name: name, fileInfo: AudioFileInfo(comment: "", isUploaded: false, archivedDays: 1, canEdit: false, uploadedAt: nil, uploadingInProgress: false)))
        updateAudioFilesOnCoreData()
    }
    
    func saveNewAudioFile(name: String, comment: String) {
        AudioFiles.shared.audioFiles.append(AudioFile(name: name, fileInfo: AudioFileInfo(comment: comment, isUploaded: false, archivedDays: 1, canEdit: false, uploadedAt: nil, uploadingInProgress: false)))
        updateAudioFilesOnCoreData()
    }
    
    func getAudioComment(name: String) -> String {
        for (index,audio) in audioFiles.enumerated() where audio.name == name {
            let comment = audioFiles[index].fileInfo?.comment
            return comment ?? ""
        }
        return ""
    }
    func updateAudioFilesOnCoreData() {
        CoreData.shared.audioFiles = audioFiles
        CoreData.shared.dataSave()
        CoreData.shared.getdata()
    }
    
}

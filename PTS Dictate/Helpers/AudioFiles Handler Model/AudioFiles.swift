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
    case uploadedStatus(Bool)
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
        case .uploadedStatus(let newValue):
            instance.audioFiles[audio].fileInfo?.uploadedStatus = newValue
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
    private let archiveFile = CoreData.shared.archiveFile
    private var archiveFileDays = CoreData.shared.archiveFileDays
    
    static var shared: AudioFiles{
        struct singleTon {
            static let instance = AudioFiles()
        }
        return singleTon.instance
    }
    
    func deleteAudio(name: String) {
//        for (index, audio) in audioFiles.enumerated() where name == audio.name ?? "" {
//            audioFiles.remove(at: index)
//        }
        audioFiles.removeAll { audio in
            audio.name == name
        }
        updateAudioFilesOnCoreData()
    }
    
    func saveNewAudioFile(name: String, autoSaved: Bool = false) {
        saveFileUploadedDate()
        if self.checkIfAlreadyExists(name: name){
            //remove first and then save
            self.deleteAudio(name: name)
            self.proceedForSave(name: name, comment: nil, autoSaved: autoSaved)
        }else{
            self.proceedForSave(name: name, comment: nil, autoSaved: autoSaved)
        }
    }
    
    func saveNewAudioFile(name: String, comment: String?) {
        saveFileUploadedDate()
        if self.checkIfAlreadyExists(name: name){
            //remove first and then save
            self.deleteAudio(name: name)
            self.proceedForSave(name: name, comment: comment)
        }else{
            self.proceedForSave(name: name, comment: comment)
        }
    }
    
    func proceedForSave(name: String, comment: String?, autoSaved: Bool = false){
        //check if changedName existed for that file(the case when a file has changedName and it is saving again after edit)
        var changedName = ""
        if checkIfAlreadyExists(name: name){
            changedName = checkIfChangedName(name: name)
        }
        AudioFiles.shared.audioFiles.append(AudioFile(name: name, changedName: changedName, fileInfo: AudioFileInfo(comment: comment, isUploaded: false, uploadedStatus: false, archivedDays: archiveFile == 1 ? archiveFileDays : 0, canEdit: false, uploadedAt: nil, uploadingInProgress: false, autoSaved: autoSaved, uploadedBy: CoreData.shared.userId)))
        updateAudioFilesOnCoreData()
    }
    
    func checkIfAlreadyExists(name:String) -> Bool{
        for (_, audio) in audioFiles.enumerated() where audio.name == name {
            return true
        }
        return false
    }
    
    func checkIfChangedName(name:String) -> String{
        for (_, audio) in audioFiles.enumerated() where audio.changedName != nil {
            return audio.changedName ?? ""
        }
        return ""
    }
    
    func saveFileUploadedDate(){
        UserDefaults.standard.set(Date(), forKey: "FileUploadedDate")
        UserDefaults.standard.synchronize()
    }
    
    func getAudioComment(name: String) -> String {
        for (index,audio) in audioFiles.enumerated() where audio.name == name {
            let comment = audioFiles[index].fileInfo?.comment
            return comment?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        }
        return ""
    }
    func updateAudioFilesOnCoreData() {
        CoreData.shared.audioFiles = audioFiles
        CoreData.shared.dataSave()
        CoreData.shared.getdata()
    }
    
}

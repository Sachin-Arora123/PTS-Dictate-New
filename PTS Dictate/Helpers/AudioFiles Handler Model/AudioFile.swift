//
//  AudioFile.swift
//  PTS Dictate
//
//  Created by Mohit Soni on 25/10/22.
//

import Foundation

@objc(QuestionsValueTransformer)
class AudioFileTransformer: NSSecureUnarchiveFromDataTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: AudioFileTransformer.self))
 
    override static var allowedTopLevelClasses: [AnyClass] {
        return [AudioFile.self]
    }
    
    public static func register() {
            let transformer = AudioFileTransformer()
            ValueTransformer.setValueTransformer(transformer, forName: name)
        }
}

public class AudioFile: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    
    public var name: String?
    public var changedName: String?
    public var filePath: String?
    public var fileInfo: AudioFileInfo?
    
    enum CodingKeys:String {
        case name, changedName, filePath, fileInfo
    }
    
    init(name: String?, changedName: String?, filePath: String?, fileInfo: AudioFileInfo?) {
        self.name = name
        self.changedName = changedName
        self.filePath = filePath
        self.fileInfo = fileInfo
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(changedName, forKey: CodingKeys.changedName.rawValue)
        aCoder.encode(filePath, forKey: CodingKeys.filePath.rawValue)
        aCoder.encode(fileInfo, forKey: CodingKeys.fileInfo.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as? String
        let changedName = aDecoder.decodeObject(forKey: CodingKeys.changedName.rawValue) as? String
        let filePath = aDecoder.decodeObject(forKey: CodingKeys.filePath.rawValue) as? String
        let fileInfo = aDecoder.decodeObject(forKey: CodingKeys.fileInfo.rawValue) as? AudioFileInfo
        
        self.init(name: name, changedName: changedName, filePath: filePath, fileInfo: fileInfo)
    }
}

public class AudioFileInfo: NSObject, NSCoding {
    
    public var comment: String?
    public var isUploaded: Bool?
    public var uploadedStatus: Bool?
    public var archivedDays: Int?
    public var canEdit: Bool?
    public var uploadedAt: String?
    public var uploadingInProgress: Bool?
    public var autoSaved: Bool?
    public var uploadedBy: String?
    
    enum CodingKeys:String {
        case comment, isUploaded, uploadedStatus, archivedDays, canEdit, uploadedAt, uploadingInProgress, autoSaved, uploadedBy, meteringLevels
    }
    
    init(comment: String?, isUploaded: Bool?, uploadedStatus: Bool?, archivedDays: Int?, canEdit: Bool?, uploadedAt: String?, uploadingInProgress: Bool?, autoSaved: Bool?, uploadedBy:String?) {
        self.comment = comment
        self.isUploaded = isUploaded
        self.uploadedStatus = uploadedStatus
        self.archivedDays = archivedDays
        self.canEdit = canEdit
        self.uploadedAt = uploadedAt
        self.uploadingInProgress = uploadingInProgress
        self.autoSaved = autoSaved
        self.uploadedBy = uploadedBy
    }
    
    public override init() {
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(comment, forKey: CodingKeys.comment.rawValue)
        aCoder.encode(isUploaded, forKey: CodingKeys.isUploaded.rawValue)
        aCoder.encode(uploadedStatus, forKey: CodingKeys.uploadedStatus.rawValue)
        aCoder.encode(archivedDays, forKey: CodingKeys.archivedDays.rawValue)
        aCoder.encode(canEdit, forKey: CodingKeys.canEdit.rawValue)
        aCoder.encode(uploadedAt, forKey: CodingKeys.uploadedAt.rawValue)
        aCoder.encode(uploadingInProgress, forKey: CodingKeys.uploadingInProgress.rawValue)
        aCoder.encode(autoSaved, forKey: CodingKeys.autoSaved.rawValue)
        aCoder.encode(uploadedBy, forKey: CodingKeys.uploadedBy.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let comment = aDecoder.decodeObject(forKey: CodingKeys.comment.rawValue) as? String
        let isUploaded = aDecoder.decodeObject(forKey: CodingKeys.isUploaded.rawValue) as? Bool
        let uploadedStatus = aDecoder.decodeObject(forKey: CodingKeys.uploadedStatus.rawValue) as? Bool
        let archivedDays = aDecoder.decodeObject(forKey: CodingKeys.archivedDays.rawValue) as? Int
        let canEdit = aDecoder.decodeObject(forKey: CodingKeys.canEdit.rawValue) as? Bool
        let uploadedAt = aDecoder.decodeObject(forKey: CodingKeys.uploadedAt.rawValue) as? String
        let uploadingInProgress = aDecoder.decodeObject(forKey: CodingKeys.uploadingInProgress.rawValue) as? Bool
        let autoSaved = aDecoder.decodeObject(forKey: CodingKeys.autoSaved.rawValue) as? Bool
        let uploadedBy = aDecoder.decodeObject(forKey: CodingKeys.uploadedBy.rawValue) as? String
        
        self.init(comment: comment, isUploaded: isUploaded, uploadedStatus: uploadedStatus, archivedDays: archivedDays, canEdit: canEdit, uploadedAt: uploadedAt, uploadingInProgress: uploadingInProgress, autoSaved: autoSaved, uploadedBy: uploadedBy)
    }
}

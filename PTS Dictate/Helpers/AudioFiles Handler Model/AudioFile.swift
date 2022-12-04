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
    public var fileInfo: AudioFileInfo?
    
    enum CodingKeys:String {
        case name, fileInfo
    }
    
    init(name: String?, fileInfo: AudioFileInfo?) {
        self.name = name
        self.fileInfo = fileInfo
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(fileInfo, forKey: CodingKeys.fileInfo.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as? String
        let fileInfo = aDecoder.decodeObject(forKey: CodingKeys.fileInfo.rawValue) as? AudioFileInfo
        
        self.init(name: name, fileInfo: fileInfo)
    }
}

public class AudioFileInfo: NSObject, NSCoding {
    
    public var comment: String?
    public var isUploaded: Bool?
    public var archivedDays: Int?
    public var canEdit: Bool?
    public var uploadedAt: String?
    public var uploadingInProgress: Bool?
    public var autoSaved: Bool?
    
    enum CodingKeys:String {
        case comment, isUploaded, archivedDays, canEdit, uploadedAt, uploadingInProgress, autoSaved, meteringLevels
    }
    
    init(comment: String?, isUploaded: Bool?, archivedDays: Int?, canEdit: Bool?, uploadedAt: String?, uploadingInProgress: Bool?, autoSaved: Bool?) {
        self.comment = comment
        self.isUploaded = isUploaded
        self.archivedDays = archivedDays
        self.canEdit = canEdit
        self.uploadedAt = uploadedAt
        self.uploadingInProgress = uploadingInProgress
        self.autoSaved = autoSaved
    }
    
    public override init() {
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(comment, forKey: CodingKeys.comment.rawValue)
        aCoder.encode(isUploaded, forKey: CodingKeys.isUploaded.rawValue)
        aCoder.encode(archivedDays, forKey: CodingKeys.archivedDays.rawValue)
        aCoder.encode(canEdit, forKey: CodingKeys.canEdit.rawValue)
        aCoder.encode(uploadedAt, forKey: CodingKeys.uploadedAt.rawValue)
        aCoder.encode(uploadingInProgress, forKey: CodingKeys.uploadingInProgress.rawValue)
        aCoder.encode(autoSaved, forKey: CodingKeys.autoSaved.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let comment = aDecoder.decodeObject(forKey: CodingKeys.comment.rawValue) as? String
        let isUploaded = aDecoder.decodeObject(forKey: CodingKeys.isUploaded.rawValue) as? Bool
        let archivedDays = aDecoder.decodeObject(forKey: CodingKeys.archivedDays.rawValue) as? Int
        let canEdit = aDecoder.decodeObject(forKey: CodingKeys.canEdit.rawValue) as? Bool
        let uploadedAt = aDecoder.decodeObject(forKey: CodingKeys.uploadedAt.rawValue) as? String
        let uploadingInProgress = aDecoder.decodeObject(forKey: CodingKeys.uploadingInProgress.rawValue) as? Bool
        let autoSaved = aDecoder.decodeObject(forKey: CodingKeys.autoSaved.rawValue) as? Bool
        
        self.init(comment: comment, isUploaded: isUploaded, archivedDays: archivedDays, canEdit: canEdit, uploadedAt: uploadedAt, uploadingInProgress: uploadingInProgress, autoSaved: autoSaved)
    }
}

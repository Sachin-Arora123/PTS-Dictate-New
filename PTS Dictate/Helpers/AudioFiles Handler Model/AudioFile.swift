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
    public var createdAt: Date?
    
    enum CodinhKeys:String {
        case comment, isUploaded, archivedDays, canEdit, createdAt
    }
    
    init(comment: String?, isUploaded: Bool?, archivedDays: Int?, canEdit: Bool?, createdAt: Date?) {
        self.comment = comment
        self.isUploaded = isUploaded
        self.archivedDays = archivedDays
        self.canEdit = canEdit
        self.createdAt = createdAt
    }
    
    public override init() {
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(comment, forKey: CodinhKeys.comment.rawValue)
        aCoder.encode(isUploaded, forKey: CodinhKeys.isUploaded.rawValue)
        aCoder.encode(archivedDays, forKey: CodinhKeys.archivedDays.rawValue)
        aCoder.encode(canEdit, forKey: CodinhKeys.canEdit.rawValue)
        aCoder.encode(createdAt, forKey: CodinhKeys.createdAt.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let comment = aDecoder.decodeObject(forKey: CodinhKeys.comment.rawValue) as? String
        let isUploaded = aDecoder.decodeObject(forKey: CodinhKeys.isUploaded.rawValue) as? Bool
        let archivedDays = aDecoder.decodeObject(forKey: CodinhKeys.archivedDays.rawValue) as? Int
        let canEdit = aDecoder.decodeObject(forKey: CodinhKeys.canEdit.rawValue) as? Bool
        let createdAt = aDecoder.decodeObject(forKey: CodinhKeys.createdAt.rawValue) as? Date
        
        self.init(comment: comment, isUploaded: isUploaded, archivedDays: archivedDays, canEdit: canEdit, createdAt: createdAt)
    }
}

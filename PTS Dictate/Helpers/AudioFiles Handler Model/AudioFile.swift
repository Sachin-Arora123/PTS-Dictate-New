//
//  AudioFile.swift
//  PTS Dictate
//
//  Created by Mohit Soni on 25/10/22.
//

import Foundation

public class AudioFile: NSObject, NSCoding {
    
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
    
    enum CodinhKeys:String {
        case comment, isUploaded, archivedDays, canEdit
    }
    
    init(comment: String?, isUploaded: Bool?, archivedDays: Int?, canEdit: Bool?) {
        self.comment = comment
        self.isUploaded = isUploaded
        self.archivedDays = archivedDays
        self.canEdit = canEdit
    }
    
    public override init() {
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(comment, forKey: CodinhKeys.comment.rawValue)
        aCoder.encode(isUploaded, forKey: CodinhKeys.isUploaded.rawValue)
        aCoder.encode(archivedDays, forKey: CodinhKeys.archivedDays.rawValue)
        aCoder.encode(canEdit, forKey: CodinhKeys.canEdit.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        
        let comment = aDecoder.decodeObject(forKey: CodinhKeys.comment.rawValue) as? String
        let isUploaded = aDecoder.decodeBool(forKey: CodinhKeys.isUploaded.rawValue)
        let archivedDays = aDecoder.decodeInt32(forKey: CodinhKeys.archivedDays.rawValue)
        let canEdit = aDecoder.decodeBool(forKey: CodinhKeys.canEdit.rawValue)
        
        self.init(comment: comment, isUploaded: isUploaded, archivedDays: Int(archivedDays), canEdit: Bool(canEdit))
    }
}

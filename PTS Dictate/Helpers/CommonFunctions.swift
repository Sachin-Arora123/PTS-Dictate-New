//
//  CommonFunctions.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 30/08/22.
//

import Foundation
import Toaster
import SwiftEntryKit


class EntryAttributeWrapper {
    var attributes: EKAttributes
    init(with attributes: EKAttributes) {
        self.attributes = attributes
    }
}

class CommonFunctions {
    static func toster(_ txt : String){
        let attributesWrapper: EntryAttributeWrapper = {
            var attributes = EKAttributes()
            attributes.positionConstraints = .fullWidth
            attributes.hapticFeedbackType = .success
            attributes.positionConstraints.safeArea = .empty(fillSafeArea: false)
//            attributes.entryBackground = .visualEffect(style: .dark)
            attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor.init(red: 143, green: 37, blue: 27), EKColor.init(red: 143, green: 37, blue: 27)], startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 0, y: 0.5)))
            return EntryAttributeWrapper(with: attributes)
        }()
        let title = EKProperty.LabelContent(
            text: txt,
            style: EKProperty.LabelStyle(font: UIFont.boldSystemFont(ofSize: 16), color: EKColor.white, alignment: NSTextAlignment.center, displayMode: .light, numberOfLines: 0)
        )
        let description = EKProperty.LabelContent(
            text: "",
            style: EKProperty.LabelStyle(
                font: UIFont.systemFont(ofSize: 1, weight: .light),
                color: .black
            )
        )
        let simpleMessage = EKSimpleMessage(
            title: title,
            description: description
        )
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributesWrapper.attributes)
    }
    //Show alert
     static func alert(view: UIViewController, title: String, message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let defaultAction = UIAlertAction(title: "YES", style: .default, handler: { action in
           })
           let cancel = UIAlertAction(title: "NO", style: .default, handler: { action in
                  })
           alert.addAction(defaultAction)
           alert.addAction(cancel)
           DispatchQueue.main.async(execute: {
               view.present(alert, animated: true)
           })
       }
    static func showAlert(view: UIViewController, title:String, message:String, completion:@escaping (_ result:Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        view.present(alert, animated: true)

        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
            completion(false)
        }))

        alert.addAction(UIAlertAction(title: "YES", style: .cancel, handler: { action in
            completion(true)
        }))
      }
}

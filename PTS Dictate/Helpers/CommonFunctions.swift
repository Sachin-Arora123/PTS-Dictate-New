//
//  CommonFunctions.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 30/08/22.
//

import Foundation
import Toaster
import SwiftEntryKit
import iProgressHUD
import UIKit


class EntryAttributeWrapper {
    var attributes: EKAttributes
    init(with attributes: EKAttributes) {
        self.attributes = attributes
    }
}

class CommonFunctions: iProgressHUDDelegete {
    static func toster(_ title : String, titleDesc: String){
        let attributesWrapper: EntryAttributeWrapper = {
            var attributes = EKAttributes()
            attributes.positionConstraints = .fullWidth
            attributes.hapticFeedbackType = .success
            attributes.positionConstraints.safeArea = .empty(fillSafeArea: false)
//            attributes.entryBackground = .visualEffect(style: .dark)
            attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor.init(red: 153, green: 37, blue: 27), EKColor.init(red: 200, green: 69, blue: 49)], startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 0, y: 0.5)))
            return EntryAttributeWrapper(with: attributes)
        }()
        let title = EKProperty.LabelContent(
            text: title,
            style: EKProperty.LabelStyle(font: UIFont.boldSystemFont(ofSize: 20), color: EKColor.white, alignment: NSTextAlignment.left, displayMode: .light, numberOfLines: 0)
        )
        let description = EKProperty.LabelContent(
            text: titleDesc,
            style: EKProperty.LabelStyle(
                font: UIFont.systemFont(ofSize: 18, weight: .light),
                color: .white,alignment: NSTextAlignment.left,displayMode: .light,numberOfLines: 0
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
    static func getTopMostViewController() -> UIViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
            // topController should now be your topmost view controller
        }
        return nil
    }
    static func showLoader(title: String) {
        let view = CommonFunctions.getTopMostViewController()?.view
        let iProgress = iProgressHUD()
        iProgress.isShowModal = true
        iProgress.isShowCaption = true
        iProgress.isTouchDismiss = false
        iProgress.indicatorSize = 37
        iProgress.indicatorStyle = .ballScaleMultiple
        iProgress.alphaModal = 1
        iProgress.alphaBox = 0.5
        iProgress.boxCorner = 8
        iProgress.captionDistance = 5
        iProgress.modalColor = .clear
        iProgress.boxSize = 40
        iProgress.boxColor = .black
        iProgress.indicatorColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        iProgress.delegete = view.self as? iProgressHUDDelegete
        iProgress.attachProgress(toViews: view!, title: title)
        view!.showProgress()
    }
    
    static func hideLoader() {
        let view = CommonFunctions.getTopMostViewController()?.view
        view!.dismissProgress()
    }
        
    static func showHideViewWithAnimation(view: UIView, hidden: Bool, animation: UIView.AnimationOptions) {
        UIView.transition(with: view,
                                 duration: 0.50,
                                 options: [animation],
                                 animations: {
                      view.isHidden = hidden
               },
                                 completion: nil)
    }
}

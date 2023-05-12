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
//import SwiftToast

class EntryAttributeWrapper {
    var attributes: EKAttributes
    init(with attributes: EKAttributes) {
        self.attributes = attributes
    }
}

class CommonFunctions: iProgressHUDDelegete {
    static func toster(_ title : String, titleDesc: String, _ showImage:Bool, _ showGreenBackground:Bool){
        let attributesWrapper: EntryAttributeWrapper = {
            var attributes = EKAttributes()
            attributes.positionConstraints = .fullWidth
            attributes.hapticFeedbackType = .success
            attributes.positionConstraints.safeArea = .empty(fillSafeArea: false)
            if showGreenBackground{
                attributes.entryBackground = EKAttributes.BackgroundStyle.color(color: EKColor(red: 61, green: 126, blue: 37))
            }else{
                attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor.init(red: 153, green: 37, blue: 27), EKColor.init(red: 200, green: 69, blue: 49)], startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 0, y: 0.5)))
            }
//            attributes.entryBackground = .visualEffect(style: .dark)
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
                color: .white.with(alpha: 0.6),alignment: NSTextAlignment.left,displayMode: .light,numberOfLines: 0
            )
        )
        
        var simpleMessage : EKSimpleMessage!
        if showImage{
            simpleMessage = EKSimpleMessage(
                image: EKProperty.ImageContent(image: UIImage(named: "settings_info") ?? UIImage()),
                title: title,
                description: description
            )
        }else{
            simpleMessage = EKSimpleMessage(
                title: title,
                description: description
            )
        }
        
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributesWrapper.attributes)
    }
    static func showToast(view: UIViewController, title: String) {
        let toast =  SwiftToast(
                            text: title,
                            textAlignment: .right,
                            image: UIImage(named: "notice_error_icon@2x"),
                            backgroundColor: #colorLiteral(red: 0.5315770507, green: 0.03795098886, blue: 0.03016442619, alpha: 1),
                            textColor: .white,
                            font: .boldSystemFont(ofSize: 15.0),
                            duration: 2.0,
                            minimumHeight: CGFloat(100.0),
                            statusBarStyle: .lightContent,
                            aboveStatusBar: true,
                            target: nil,
                            style: .navigationBar)
            view.present(toast, animated: true)
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
    static func alertMessage(view: UIViewController, title: String, msg: String, btnTitle: String, completion:(() -> Void)?) {
        // Create new Alert
        let alertMessage = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: btnTitle, style: .default, handler: { (action) -> Void in
            completion?()
         })
        
        //Add OK button to a dialog message
        alertMessage.addAction(ok)
        // Present Alert to
        view.present(alertMessage, animated: true, completion: nil)
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
        iProgress.attachProgress(toViews: view!)
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

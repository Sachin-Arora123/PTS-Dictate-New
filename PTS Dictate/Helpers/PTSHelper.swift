//
//  PTSHelper.swift
//  PTS Dictate
//
//  Created by Priya Soni on 30/10/22.
//

import Foundation
class PTSHelper {
//
//    private var progressHud:MBProgressHUD!
//    private var listArray:NSMutableArray!
//
//
//    var sharedPTSHelper:PTSHelper! = nil
//
//    class func sharedPTSHelper() -> PTSHelper! {
//        $(SynchronizedStatement)
//        return nil
//    }
//
//    func resetUserDefaultsValues() {
//        //[[APPDELEGATE userDefaults] setBool:NO forKey:K_KEY_AUTO_SAVE_FILE];
//        APPDELEGATE.userDefaults().setObject(nil, forKey:K_KEY_IS_SEGMENT_SELECTED_INDEX)
//        APPDELEGATE.userDefaults().setObject(nil, forKey:K_KEY_IS_RECORDING) // FIRST TIME OR SECOND TIME
//        APPDELEGATE.userDefaults().setObject(nil, forKey:K_KEY_IS_PLAYER_FILE)
//        APPDELEGATE.userDefaults().setBool(false, forKey:K_KEY_IS_RECORD_STOPPED)
//        APPDELEGATE.userDefaults().setObject(nil, forKey:K_KEY_IS_EDITING)
//        //[[APPDELEGATE userDefaults] setObject:nil forKey:K_KEY_IS_FILE_NAME];
//        APPDELEGATE.userDefaults.setInteger(0, forKey:K_KEY_IS_TRIMCOUNT)
//        APPDELEGATE.userDefaults.setFloat(0, forKey:K_KEY_IS_PLAYER_CURRENT_TIME)
//        APPDELEGATE.userDefaults().setBool(false, forKey:K_KEY_EDIT_RECORD_FILE)
//        APPDELEGATE.userDefaults().synchronize()
//    }
//
//    func showTabBar() {
//        let frame:CGRect = APPDELEGATE.tabBar.frame
//
//        APPDELEGATE.tabBar.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
//
//        UIView.animateWithDuration(1.0,
//                              delay:0,
//                            options:UIViewAnimationOptionTransitionFlipFromTop,
//
//                         animations:{
//                             APPDELEGATE.tabBar.frame = CGRectMake(frame.origin.x, frame.origin.y - frame.size.height - 10, frame.size.width, frame.size.height)
//                         },
//                         completion:nil)
//
//    }
//
//    func showLoadingIndicator(controller:UIViewController!) {
//        self.hideLoadingIndicator(controller)
//
//        let spinner:RTSpinKitView! = RTSpinKitView(style:RTSpinKitViewStyleBounce, color:K_COLOR_PRIMARY_COLOR)
//
//        self.progressHud = MBProgressHUD.showHUDAddedTo(APPDELEGATE.window, animated:true)
//        self.progressHud.square = false
//        self.progressHud.mode = MBProgressHUDModeCustomView
//        self.progressHud.customView = spinner
//        self.progressHud.labelText = NSLocalizedString("Loading....", "Loading....")
//        spinner.startAnimating()
//
//        controller.view.userInteractionEnabled = false
//        controller.navigationController.navigationBar.userInteractionEnabled = false
//        APPDELEGATE.window.userInteractionEnabled = false
//        APPDELEGATE.tabBar.userInteractionEnabled = false
//
//    }
//
//    func showLoadingIndicatorWithStatus(status:String!, controller:UIViewController!) {
//        self.hideLoadingIndicator(controller)
//
//        let spinner:RTSpinKitView! = RTSpinKitView(style:RTSpinKitViewStyleBounce, color:K_COLOR_PRIMARY_COLOR)
//
//        self.progressHud = MBProgressHUD.showHUDAddedTo(APPDELEGATE.window, animated:true)
//        self.progressHud.square = false
//        self.progressHud.mode = MBProgressHUDModeCustomView
//        self.progressHud.customView = spinner
//        self.progressHud.labelText = NSLocalizedString(status, status)
//        spinner.startAnimating()
//
//        controller.view.userInteractionEnabled = false
//        controller.navigationController.navigationBar.userInteractionEnabled = false
//        APPDELEGATE.window.userInteractionEnabled = false
//        APPDELEGATE.tabBar.userInteractionEnabled = false
//
//    }
//
//    func hideLoadingIndicator(controller:UIViewController!) {
//        self.progressHud.hide(true)
//        controller.view.userInteractionEnabled = true
//        controller.navigationController.navigationBar.userInteractionEnabled = true
//        APPDELEGATE.window.userInteractionEnabled = true
//        APPDELEGATE.tabBar.userInteractionEnabled = true
//
//    }
//
//    func showSuccessNoticeView(aViewController:UIViewController!, message aStrMessage:String!) {
//        let notice:WBSuccessNoticeView! = WBSuccessNoticeView.successNoticeInView(aViewController.view, title:aStrMessage)
//        notice.show()
//    }
//    func showErrorNoticeView(aViewController:UIViewController!, title aStrTitle:String!, message aStrMessage:String!) {
//        let notice:WBErrorNoticeView! = WBErrorNoticeView.errorNoticeInView(aViewController.view, title:aStrTitle, message:aStrMessage)
//        notice.delay = 1
//        notice.scrollOffsetY = 0
//        notice.sticky = false
//        notice.show()
//    }
//
//    func checkNetworkConnection() -> Bool {
//
//        let reach:Reachability! = Reachability.reachabilityForInternetConnection()
//
//        let status:NetworkStatus = reach.currentReachabilityStatus()
//
//        switch (status) {
//            case NotReachable:
//                //NSLog(@"NotReachable ===>");
//                return false
//                break
//
//            case ReachableViaWWAN:
//
//                //NSLog(@"ReachableViaWWAN ===>");
//                return true
//                break
//
//
//            case ReachableViaWiFi:
//                //NSLog(@"ReachableViaWiFi ===>");
//                return true
//                break
//
//            default:
//                break
//        }
//
//        return false
//    }
//
//    func checkWifiConnection() -> Bool {
//        let reach:Reachability! = Reachability.reachabilityForInternetConnection()
//
//        let status:NetworkStatus = reach.currentReachabilityStatus()
//
//        switch (status) {
//            case NotReachable:
//                //NSLog(@"NotReachable ===>");
//                return false
//                break
//
//            case ReachableViaWiFi:
//                //NSLog(@"ReachableViaWiFi ===>");
//                return true
//                break
//
//            default:
//                break
//        }
//        return false
//    }
//
//    func colorWithHexString(hex:String!) -> UIColor! {
//        var cString:String! = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString()
//
//        // String should be 6 or 8 characters
//        if cString.length() < 6 {return UIColor.whiteColor()}
//
//        // strip 0X if it appears
//        if cString.hasPrefix("0X") {cString = cString.substringFromIndex(2)}
//
//        if cString.length() != 6 {return  UIColor.whiteColor()}
//
//        // Separate into r, g, b substrings
//        var range:NSRange
//        range.location = 0
//        range.length = 2
//        let rString:String! = cString.substringWithRange(range)
//
//        range.location = 2
//        let gString:String! = cString.substringWithRange(range)
//
//        range.location = 4
//        let bString:String! = cString.substringWithRange(range)
//
//        // Scan values
//        var r:UInt, g:UInt, b:UInt
//        NSScanner.scannerWithString(rString).scanHexInt(&r)
//        NSScanner.scannerWithString(gString).scanHexInt(&g)
//        NSScanner.scannerWithString(bString).scanHexInt(&b)
//
//        return UIColor(red:((r as! float) / 255.0),
//                               green:((g as! float) / 255.0),
//                                blue:((b as! float) / 255.0),
//                               alpha:1.0)
//    }
//
//    func showNetworkFailureAlert() {
//
//    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Network is no longer available. Please reconnect your network and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    //    [alertView show];
//
//        let notice:WBErrorNoticeView! = WBErrorNoticeView.errorNoticeInView(APPDELEGATE.window, title:"Network Error", message:"Network is no longer available. Please reconnect your network and try again")
//        notice.delay = 4
//        notice.scrollOffsetY = 64
//        notice.sticky = false
//        notice.show()
//
//    }
//    func showWebServiceFailedBlockAlert() {
//        let notice:WBErrorNoticeView! = WBErrorNoticeView.errorNoticeInView(APPDELEGATE.window, title:K_KEY_APP_TITLE, message:K_ALERT_FAILED_BLOCK)
//        notice.delay = 4
//        notice.scrollOffsetY = 64
//        notice.sticky = false
//        notice.show()
//    }
//
//    func showUploadingFailureAlert() {
//        let notice:WBErrorNoticeView! = WBErrorNoticeView.errorNoticeInView(APPDELEGATE.window, title:"Upload error", message:"Unable to upload, Please try again")
//        notice.delay = 4
//        notice.scrollOffsetY = 64
//        notice.sticky = false
//        notice.show()
//    }
//
//    func saveToUserDefaults(myArray:NSMutableArray!) {
//        let array:[AnyObject]! = [AnyObject](array:myArray)
//        let data:NSData! = NSKeyedArchiver.archivedDataWithRootObject(array)
//        if APPDELEGATE.userDefaults
//        {
//            APPDELEGATE.userDefaults.setObject(data, forKey:"upload_array")
//            APPDELEGATE.userDefaults.synchronize()
//        }
//    }
//
//    func retrieveFromUserDefaults() -> NSMutableArray! {
//
//        var val:NSMutableArray! = NSMutableArray()
//        if APPDELEGATE.userDefaults {
//            let data:NSData! = APPDELEGATE.userDefaults.objectForKey("upload_array")
//            let myarray:[AnyObject]! = NSKeyedUnarchiver.unarchiveObjectWithData(data)
//            val = NSMutableArray.arrayWithArray(myarray)
//        }
//
//        return val
//    }
//
//    func checkArchieve() {
//        NSLog("checkArchieve")
//
//        self.listArray = PTSDATAMANAGER.getUploadFiles()
//
//        if self.listArray.count > 0 {
//
//            for var i:Int=0 ; i < self.listArray.count ; i++ {
//
//                let tag:PTSTag! = self.listArray.objectAtIndex(i)
//
//                if tag.uploadedDate.length {
//
//                    let dateString:String! = tag.uploadedDate
//
//                    NSLog("dateString :%@", dateString)
//
//                    let dateFormatter:NSDateFormatter! = NSDateFormatter()
//
//                    //[dateFormatter setDateFormat:@"dd-MM-yyyy"];
//
//                    // Added HH:mm:ss to resolve PTS-95
//                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
//
//                    let uploadedDateValue:NSDate! = dateFormatter.dateFromString(dateString)
//
//                    let noOfDays:Int = APPDELEGATE.userDefaults().valueForKey("Value").integerValue()
//
//                    let today:NSDate! = NSDate.date()
//
//                    let seconds:NSTimeInterval = today.timeIntervalSinceDate(uploadedDateValue)
//
//                    if seconds > (noOfDays*24*60*60) {
//                        self.checkAndDeleteArchieveDateFiles(tag.fileName, fileId:tag.rowId)
//                    }
//
//    //                if ([self daysBetween:afterNDays and:now] > 0) {
//    //
//    //                    [self checkAndDeleteArchieveDateFiles:tag.fileName fileId:tag.rowId];
//    //
//    //                }
//
//
//                    /*
//                    NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//                    NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
//
//                    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:uploadedDateValue];
//                    NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:uploadedDateValue];
//
//                    NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
//
//                    NSDate* nowDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:uploadedDateValue];
//
//                    NSInteger value = [[[APPDELEGATE userDefaults] valueForKey:@"Value"] integerValue];
//
//                    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//
//                    [dateComponents setDay: + value];
//                    NSLog(@"Date Components : %@",dateComponents);
//
//                    NSDate * afterNDays = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:nowDate options:0];
//
//                    NSLog(@"[self daysBetween:afterNDays and:nowDate] :%d", [self daysBetween:afterNDays and:nowDate]);
//
//                    NSLog(@"afterNDays :%@", afterNDays);
//
//                    NSDate *now = [NSDate date];
//
//                    NSLog(@"nowDate :%@", nowDate);
//
//                    if ([self daysBetween:afterNDays and:now] > 0) {
//
//                        [self checkAndDeleteArchieveDateFiles:tag.fileName fileId:tag.rowId];
//
//                    }
//                     */
//
//                }
//             }
//        }
//
//    }
//
//    func checkAndDeleteArchieveDateFiles(fileName:String!, fileId:String!) {
//
//        NSNotificationCenter.defaultCenter().postNotificationName(K_NOTICATION_ARCHIVE_STARTED, object:self)
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
//
//            let filePath:String! = self.getExistingFolder().stringByAppendingPathComponent(fileName)
//
//            let fileManager:NSFileManager! = NSFileManager.defaultManager()
//
//            let isMyFileThere:Bool = NSFileManager.defaultManager().fileExistsAtPath(filePath)
//
//            if isMyFileThere
//            {
//                fileManager.removeItemAtPath(filePath, error:nil)
//            }
//
//            //Deleting file name row from database
//            PTSDATAMANAGER.deleteFile(fileId)
//
//            dispatch_async(dispatch_get_main_queue(), {
//
//                NSNotificationCenter.defaultCenter().postNotificationName(K_NOTICATION_ARCHIVE_END, object:self)
//
//                NSLog("<======= COMPLETED =========>")
//            })
//
//        })
//
//    }
//
//    func imageWithImage(image:UIImage!, scaledToSize newSize:CGSize) -> UIImage! {
//        //UIGraphicsBeginImageContext(newSize);
//        // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
//        // Pass 1.0 to force exact pixel size.
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
//        let newImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }
//
//    // BUTTON ANIMATION
//
//    func setButtonAnimation(sender:UIButton!) {
//        var theAnimation:CABasicAnimation!
//
//        theAnimation=CABasicAnimation.animationWithKeyPath("opacity")
//        theAnimation.duration = 0.1
//        theAnimation.repeatCount = 0
//        theAnimation.autoreverses = false
//        theAnimation.fromValue=NSNumber.numberWithFloat(1.0)
//        theAnimation.toValue=NSNumber.numberWithFloat(0.0)
//        sender.layer.addAnimation(theAnimation, forKey:"animateOpacity")
//
//    }
//
//    func setFloatingAnimation(view:UIView!, value:Float) {
//        let transf:CGAffineTransform = CGAffineTransformIdentity
//
//        UIView.animateWithDuration(0.6, delay:0.0, options:0, animations:{
//            view.transform = CGAffineTransformScale(transf, value, value)
//
//        },   completion:{ (finished:Bool) in
//
//            UIView.animateWithDuration(0.4, delay:0.0, options:0, animations:{
//                let transf:CGAffineTransform = CGAffineTransformIdentity
//                view.transform = CGAffineTransformScale(transf, TRANSFORM_END, TRANSFORM_END)
//            },   completion:{ (finished:Bool) in
//            })
//
//        })
//    }
//
//    func getExistingFolder() -> String! {
//        return self.getDocumentDirectory().stringByAppendingPathComponent("Existing")
//    }
//
//    func getDocumentDirectory() -> String! {
//        let paths:[AnyObject]! = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)
//        return paths.objectAtIndex(0)
//    }
//
//    func beginningOfDay(date:NSDate!) -> NSDate! {
//        let cal:NSCalendar! = NSCalendar.currentCalendar()
//        let components:NSDateComponents! = cal.components((NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit), fromDate:date)
//        components.hour = 0
//        components.minute = 0
//        components.second = 0
//        return cal.dateFromComponents(components)
//    }
//
//    func endOfDay(date:NSDate!) -> NSDate! {
//        let cal:NSCalendar! = NSCalendar.currentCalendar()
//        let components:NSDateComponents! = cal.components((NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit), fromDate:date)
//        components.hour = 23
//        components.minute = 59
//        components.second = 59
//        return cal.dateFromComponents(components)
//    }
//
//    func daysBetween(date1:NSDate!, and date2:NSDate!) -> Int {
//        let beginningOfDate1:NSDate! = self.beginningOfDay(date1)
//        let endOfDate1:NSDate! = self.endOfDay(date1)
//        let calendar:NSCalendar! = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)
//        let beginningDayDiff:NSDateComponents! = calendar.components(NSCalendarUnitDay, fromDate:beginningOfDate1, toDate:date2, options:0)
//        let endDayDiff:NSDateComponents! = calendar.components(NSCalendarUnitDay, fromDate:endOfDate1, toDate:date2, options:0)
//        if beginningDayDiff.day > 0
//            {return beginningDayDiff.day}
//        else if endDayDiff.day < 0
//            {return endDayDiff.day}
//        else {
//            return 0
//        }
//    }

    class func isiPad() -> Bool {
        let deviceType:String! = UIDevice.current.model

        if (deviceType == "iPhone")
        {
            //your code
            return false
        } else {
            return true
        }
    }
}

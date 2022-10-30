//
//  Constants.swift
//  PTS Dictate
//
//  Created by Rakesh Chakraborty on 28/10/22.
//

import Foundation

let HEIGHT_IPHONE_5 = 568.0
let HEIGHT_IPHONE_4 = 480.0

let IS_IPHONE = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone)
let IS_IPHONE_4 = (UIScreen.main.bounds.size.height == HEIGHT_IPHONE_4)
let IS_IPHONE_5 = (UIScreen.main.bounds.size.height == HEIGHT_IPHONE_5)

//let IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
let IS_RETINA = (UIScreen.main.scale >= 2.0)

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_MAX_LENGTH = (max(SCREEN_WIDTH, SCREEN_HEIGHT))
let SCREEN_MIN_LENGTH = (min(SCREEN_WIDTH, SCREEN_HEIGHT))

let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
let IS_IPHONE_6 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
let IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//let PTSHELPER [PTSHelper sharedPTSHelper]

let APPDELEGATE = UIApplication.shared.delegate

// ABOVE IOS 6
let IS_ABOVE_IOS6 = (UIDevice.current.systemVersion.hashValue >= 7)

let isIOS8SystemVersion = (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)

//let SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
//let SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
//let SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
//let SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
//let SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


let K_WEBSERVICE_LIVE_URL = "https://www.etranscriptions.com.au/scripts/web_response.php?"

let K_WEBSERVICE_LIVE_URL_UPLOADING = "https://ios.etranscriptions.com.au/scripts/web_response.php?"

let K_WEBSERVICE_LIVE_URL_UPLOADING_UAT = "https://uat.etranscriptions.com.au/scripts/web_response.php?"

//Beta link
//let K_WEBSERVICE_LIVE_URL = "https://beta.etranscriptions.com.au/scripts/web_response.php?"


//url for the fetching last update record
let K_WEBSERVICE_FOR_LAST_UPDATE = "https://www.etranscriptions.com.au/scripts/web_response.php?/lastAppUpdateDate"


let K_RESPONCE_CODE = "response_code"

// SWITCH
let K_SWITCH_ON = "ON"
let K_SWITCH_OFF = "OFF"

// TITLE
let K_KEY_APP_TITLE = "PTS Dictate"

let K_KEY_SWITCH_VOICE_ACTIVATION = "switch_voice_activation"
let K_KEY_SWITCH_RECORDING_FORMAT = "switch_recording_format"
let K_KEY_SWITCH_AUTO_SAVING = "switch_auto_saving"
let K_KEY_SWITCH_KEEP_FILE_AFTER_UPLOAD = "switch_keep_file_after_upload"
let K_KEY_SWITCH_UPLOAD_VIA_WIFI = "switch_upload_via_wifi"
let K_KEY_SWITCH_UPLOAD_EMAIL_NOTIFICATION = "switch_upload_email_notification"
let K_KEY_SWITCH_COMMENTS_SCREEN = "comments_screen"
let K_KEY_SWITCH_COMMENTS_SCREEN_MANDATORY = "comments_screen_mandatory"
let K_KEY_SWITCH_INDEXING = "indexing"
let K_KEY_SWITCH_STAND_BY_MODE = "standy_mode"
let K_KEY_SWITCH_DISABLE_POPUP = "disable_popup"

// KEYS
let K_KEY_AUTO_SAVING = "key_auto_saving"
let K_KEY_KEEP_FILE_AFTER_UPLOAD = "key_keep_file_after_upload"
let K_KEY_UPLOAD_VIA_WIFI = "key_upload_via-wifi"
let K_KEY_UPLOAD_EMAIL_NOTIFICATION = "key_upload_email_notification"
let K_KEY_MICROPHONE_SENSITIVITY = "key_microphone_sensitivity"

let K_KEY_USER_IS_LOGGED_IN = "key_user_is_logged_in"
let K_KEY_AUTO_SAVE_FILE = "key_is_auto_save"
let K_KEY_AUTO_SAVED_FILE_ARRAY = "key_is_auto_saved_file_array"
let K_KEY_IS_RECORDING = "key_is_recording"
let K_KEY_IS_EDITING = "key_is_editing"
let K_KEY_IS_FILE_NAME = "key_is_file_name"
let K_KEY_IS_ROW_ID = "key_is_row_id"
let K_KEY_IS_SEGMENT_SELECTED_INDEX = "key_is_segment_selected_index"
let K_KEY_IS_PLAYER_FILE = "key_is_player_file"
let K_KEY_IS_TRIMCOUNT = "key_is_trim_count"
let K_KEY_IS_PLAYER_CURRENT_TIME = "key_is_player_current_time"
let K_KEY_IS_RECORD_STOPPED = "key_is_record_stopped"
let K_KEY_EDIT_RECORD_FILE = "is_edit_recording"
let K_KEY_INSERT_AT_BEGINNING = "key_insert_at_beginning"

let K_KEY_FILE_FORMAT = "key_file_format"
let K_KEY_RECORD_FILE_COUNT = "key_record_file_count"
let K_KEY_RECORD_DATE = "key_record_date_key"
let K_KEY_RECORD_OVERWRITE_ALERT = "Overwrite - Cannot start at end of the audio file."

let K_KEY_LOGIN_ID = "login_id"
let K_KEY_LOGIN_USER_NAME = "login_user_name"
let K_KEY_LOGIN_EMAIL = "login_email"
let K_KEY_LOGIN_PASSWORD = "login_password"
let K_KEY_LOGIN_USER_ID = "login_user_id"
let K_KEY_LOGIN_PROFILE_NAME = "key_login_profile_name"

let K_KEY_IS_UPLOAD_STARTED = "is_upload_started"
let K_KEY_IS_RECORD_STARTED = "is_record_started"

let K_KEY_IS_WELCOME_USER = "welcome_user"

let K_KEY_IS_REMEMBER_ME = "remember_me"

let K_NOTICATION_RECORDING = NSNotification.Name(rawValue: "is_recording")
let K_NOTICATION_UPLOAD_STATUS = "upload_status-notification"
let K_NOTICATION_ARCHIVE_STARTED = "archive_started"
let K_NOTICATION_ARCHIVE_END = "archive_end"
let K_NOTICATION_RELOAD_PLAYER_SETTINGS = "player_settings"


let K_NOTICATION_LOGOUT = "is_logout"

// ALERTS
let K_ALERT_FAILED_BLOCK = "Could not connect to server. Please try again."



let FONT_NORMAL = "Arial"
let FONT_BOLD = "Arial-BoldMT"


//let K_SETIMAGE(r) [UIImage imageNamed:r]

let K_BACK_BUTTON_NORMAL_IMAGE = "shared_icon_navigation_back.png"
let K_BACK_BUTTON_HIGHLIGHTED_IMAGE = "shared_icon_navigation_back.png"

let K_FONT_NAVIGATION_TITLE_FONT_SIZE = 16.5
let K_TABBAR_HEIGHT = 60
let TRANSFORM_END = 1.00
let K_COLOR_WHITE_COLOR = UIColor.white

let K_COLOR_DARK_COLOR = UIColor.darkGray

// COMMON UI COLORS
let K_COLOR_CLEAR_COLOR = UIColor.clear
let K_COLOR_BLACK_COLOR = UIColor.black
let K_COLOR_GRAY_COLOR = UIColor.gray

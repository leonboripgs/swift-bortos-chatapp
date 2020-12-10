//
//  Constants.swift
//  ChatApp
//
//  Created by Chandresh Kachariya on 14/08/19.
//  Copyright © 2019 Chandresh Kachariya. All rights reserved.
//

import Foundation
import UIKit

// MARK: - API List
var BASEIMAGEURL:String                 = ""

let BASE_URL                            = "http://37.148.196.5:5000"
let BASE_API_URL                        = "http://37.148.196.5:5000/api/"
let BASE_URL_IMAGE                      = "https://portdemo.com/pindip/public/"
let BASE_URL_VIDEO                      = "https://portdemo.com/pindip/"

let _api_route_account                      = "account/"
let _api_route_message                      = "message/"
//--
let _api_check_uuid                         = "check-uuid"
let _api_get_all_users                      = "get-all"
let _api_get_contact_list                   = "get-contact-list"
let _api_get_convo                          = "get-convo"
let _api_send_message                       = "send-message"

let _api_check_mobile_number                = "mobile-number-check"
let _api_registerdata                       = "registerdata"
let _api_get_language_without_login         = "color-list-data"
let _api_get_language_with_login            = "color-list-data-login"
let _api_change_language                    = "change-language"
let _api_login                              = "login-form-data"
let _api_logout                             = "user-logout"
let _api_forgot_password                    = "forget-form-data"
let _api_change_password                    = "change-password"
let _api_send_help_feedback                 = "send-contact-feedback"
let _api_login_with_social_media            = "login-with-social-media"
let _api_register_via_social_media          = "registerviasocialmedia"
let _api_get_all_videos_list                = "get-all-videos-list"
let _api_get_all_videos_list_not_login_user = "get-all-videos-list-not-login-user"
let _api_like_unlike_video                  = "like-unlike-video"
let _api_get_single_video                   = "single-video"
let _api_get_single_video_not_login_user    = "single-video-for-not-login-user"
let _api_comment_video                      = "comment-video"
let _api_download_video                     = "download-video"
let _api_get_other_person_profile           = "get-other-person-profile"
let _api_get_other_person_profile_without_login = "get-other-person-profile-without-login"
let _api_get_video_list_according_user      = "get-videos-list-according-to-user"
let _api_get_video_list_according_user_without_login = "get-videos-list-according-to-user-without-login"
let _api_follow_and_unfollow_friend         = "follow-and-unfollow-friend"
let _api_get_gold_package_list              = "get-gold-package-list"
let _api_donate_video_gold                  = "donate-video-gold"
let _api_get_rose_package_list              = "get-rose-package-list"
let _api_donate_video_rose                  = "donate-video-rose"

let _api_how_pindip_works                   = "how-pindip-works"
let _api_terms_and_conditions               = "terms-and-conditions"


// MARK: - Storyboard name
let _storyboard_name = "Main"

let _vc_LoginVC = "LoginVC"
let _vc_PhoneRegisterVC = "PhoneRegisterVC"
let _vc_VerifyPhoneNumberVC = "VerifyPhoneNumberVC"
let _vc_SignUpVC = "SignUpVC"
let _vc_AddUserVC = "AddUserVC"

let _vc_SelectLanguageVC = "SelectLanguageVC"
let _vc_LanguageConfirmationVC = "LanguageConfirmationVC"
let _vc_CustomTabVC = "CustomTabVC"
let _vc_HomeVC = "HomeVC"
let _vc_SearchVC = "SearchVC"
let _vc_NotificationVC = "NotificationVC"
let _vc_ProfileVC = "ProfileVC"
let _vc_SearchListingVC = "SearchListingVC"
let _vc_ProfileViewVC = "ProfileViewVC"
let _vc_WalletVC = "WalletVC"
let _vc_MyWalletVC = "MyWalletVC"
let _vc_ChangePasswordVC = "ChangePasswordVC"
let _vc_AccountSettingVC = "AccountSettingVC"
let _vc_ContactUsVC = "ContactUsVC"
let _vc_HelpFeedbackVC = "HelpFeedbackVC"
let _vc_TermsCondtionsVC = "TermsCondtionsVC"
let _vc_CoinsPackageVC = "CoinsPackageVC"
let _vc_AddCoinsPackageVC = "AddCoinsPackageVC"
let _vc_WithdrawalVC = "WithdrawalVC"
let _vc_PaymentMethodsVC = "PaymentMethodsVC"
let _vc_CardInfoVC = "CardInfoVC"
let _vc_VideoCreatorVC = "VideoCreatorVC"
let _vc_AddVideoVC = "AddVideoVC"
let _vc_AddAudioVC = "AddAudioVC"
let _vc_ForgotPasswordVC = "ForgotPasswordVC"
let _vc_CommentsVC = "CommentsVC"
let _vc_SendGiftVC = "SendGiftVC"

let kURLTerms = "https://www.google.com"
let kURLPrivacyPolicy = "https://www.google.com"
let kURLCookiesPolicy = "https://www.google.com"

// MARK: - Font Name
let _font_Montserrat_Black = "Montserrat-Black"
let _font_Montserrat_BlackItalic = "Montserrat-BlackItalic"
let _font_Montserrat_Bold = "Montserrat-Bold"
let _font_Montserrat_BoldItalic = "Montserrat-BoldItalic"
let _font_Montserrat_ExtraBold = "Montserrat-ExtraBold"
let _font_Montserrat_ExtraBoldItalic = "Montserrat-ExtraBoldItalic"
let _font_Montserrat_ExtraLight = "Montserrat-ExtraLight"
let _font_Montserrat_ExtraLightItalic = "Montserrat-ExtraLightItalic"
let _font_Montserrat_Italic = "Montserrat-Italic"
let _font_Montserrat_Light = "Montserrat-Light"
let _font_Montserrat_LightItalic = "Montserrat-LightItalic"
let _font_Montserrat_Medium = "Montserrat-Medium"
let _font_Montserrat_MediumItalic = "Montserrat-MediumItalic"
let _font_Montserrat_Regular = "Montserrat-Regular"
let _font_Montserrat_SemiBold = "Montserrat-SemiBold"
let _font_Montserrat_SemiBoldItalic = "Montserrat-SemiBoldItalic"
let _font_Montserrat_Thin = "Montserrat-Thin"
let _font_Montserrat_ThinItalic = "Montserrat-ThinItalic"



// MARK: - Message
let _error_select_age = "Please select Age."
let _invalid_gender = "Please select Gender."
let _select_one_language = "Select at least one language."
let _password_not_match = "New password and confirm password do not match.."
let _empty_phone = "Phone number is required."
let _empty_message = "Message is required."

let _empty_full_name = "Full name is required."
let _empty_date = "Date is required."
let _empty_month = "Month is required."
let _empty_year = "Year is required."
let _invalid_date = "Please select valid Date."
let _empty_email = "Email is required."
let _error_invalid_email = "Email is not valid."
let _empty_password = "Password is required."
let _empty_verify_password = "Verify password is required."
let _error_not_match_confirm_password = "Password & Verify password is not match."
let _error_select_sport = "Please select sport."
let _empty_looking_for = "I'm Looking for is required."
let _empty_organization_name = "Organization name is required."
let _empty_address_name = "Address is required."
let _empty_city_name = "City is required."
let _empty_state_name = "State is required."
let _empty_zip_code_name = "Zip code is required."
let _empty_ein_name = "EIN code is required."
let _empty_country_name = "Country is required."
let _empty_current_password = "Current Password is required."
let _empty_new_password = "New Password is required."
let _error_not_match_confirm_passwd = "Password & Confiem password is not match."
let _empty_aboutme = "About me is required."
let _error_select_position_name = "Please select Position name."
let _error_select_club_name = "Please select Club name."
let _error_select_school_name = "Please select School name."


// MARK: - API Message
var NO_INTERNET_CONNECTION = "Please check your Internet connection."
var SOMTHING_WRONG = "Something went wrong, Please try again!"
var FAILED = "Failed"



// MARK: - USERDEFAULT KEY
var _key_UserDetails : String       = "UserDetails"
var _key_AlreadyLogin : String      = "AlreadyLogin"
var _key_token_auth : String        = "tokenAuth"
var _key_selected_language : String = "selectedLanguage"


// MARK: - Constant Text
var _text_gender_male = "Male"
var _text_gender_female = "Female"
var _text_gender_other = "Other"

var _text_email_notifications = "Email Notifications"
var _text_push_notifications  = "Push Notifications"
var _text_position = "POSITION"
var _text_club = "CLUB"
var _text_schools = "SCHOOLS"
var _text_selecct_position = "Select Position"
var _text_selecct_club = "Select Club"
var _text_selecct_schools = "Select School"

// MARK: - API_KEY
var id = "id"


struct ScreenSize{
    ///Width: *Screen width*
    static let Width = UIScreen.main.bounds.width
    ///Height: *Screen Height*
    static let Height = UIScreen.main.bounds.height

}

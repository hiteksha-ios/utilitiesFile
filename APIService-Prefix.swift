//
//  APIService-Prefix.swift
//  inTouch
//
//  Created by Admin on 8/18/21.
//

import Foundation

struct APIErrorLogConstants {
    static let NoInternet = "ParentNetwork requires a network connection to work properly. Please check your WiFi or internet connection."
    static let SomethingWrong = "Something went wrong. Please try after some time."
    static let NoResult = "No results found!"
}


struct APIServerConstants {
    //Dev
   // static let BaseURL = "http://3.138.229.235:8092/"
    //Production
    static let BaseURL = "https://api.intouchasap.com/"
    static let imageBaseURL = "https://intouch-profile-images.s3.us-west-1.amazonaws.com/"
}
/// Resource path
enum apiPath : String{
    case user = "user/"
    case onboarding = "onboarding/"
    case email = "email/"
    case photo = "photo/"
    case pet = "pet/"
    case notification = "notification/"
    case hopeOnDate = "hopeOnDate/"
    case likes = "likes/"
    case conversation = "conversation/"
    case message = "message/"
    case group = "group/"
    case groupMessage = "groupMessage/"
    case offer = "offer/"
    case invite = "invite/"
    case setting = "setting/"
    case common = "common/"
    case blockReport = "blockReport/"
    case subscription = "subscription/"
    case community = "community/"
    case communityMessage = "communityMessage/"
    case spotter = "spotter/"
}

/// Resource name
enum apiName : String{
    case userSignup
    case updateUserFNameLName
    case updateUserName
    case getOTPForPhoneNumber
    case sendEmailVerificationOTP
    case signUpUsingPhoneNumber
    case verifyPhoneNumber
    case verifyEmailOTP
    case verifyPhoneNumberOTP
    case userOnboarding
    case updateUserOnboardingByUserId
    case uploadProfilePhotos
    case getAllUserByUserId
    case getAllPetByUserId
    case getAllUserPhotoByUserId
    case uploadedPhotoSequence
    case getUserProfile
    case deletePhotoByPhotoId
    case petOnboarding
    case updatePetOnboardingByUserId
    case uploadPetProfilePhotos
    case uploadedPetPhotoSequence
    case setMyProfileType
    case getPetProfile
    case getPetProfileByPetOnboardingId
    case getAllOrientation
    case getAllPetPhotoByPetOnboardingId
    case deletePetPhotoByPhotoId
    case getAllExpressInterest
    case getAllCatBreed
    case getAllDogBreed
    case getAllProfileQuestion
    case getAllPetProfileQuestion
    case getUserSettingsByUserId
    case getNotificationSettingByUserId
    case updateNotificationSetting
    case updateUserSettingsByUserId
    case deleteAccountByUserId
    case searchReligion
    case searchLanguage
    case createOrUpdateDeviceToken
    case getConversationDetailsByConversationId
    case nearbyUsers
    case updateLocationVisibleByUserId  
    case onboarding
    
    
    //MARK: - Block
    case getAllBlockReportListByUserId
    case blockReportUser
    case unblockReportUser
    case blockReportUserPhotos
    
    //MARK: - Hope On dates
    case createHopeOnDate
    case createHopeOnDateForPet
    
    case updateHopeOnDate
    case updateHopeOnDateForPet
    
    case deleteHopeOnDates
    case deleteHopeOnDatesForPet
    
    case createOrRemoveHopeOnDateLikes
    case createOrRemoveHopeOnDateLikesForPet
    
    case getAllHopeOnDatesByUserId
    case getAllHopeOnDatesByPetOnboardingIdAndUserId
    
    case getAllHopeOnDatesRequestById
    case getAllHopeOnDatesRequestByPetHopeOnDateId
    
    case acceptOrRejectHopeOnDateRequest
    case acceptOrRejectHopeOnDateRequestForPet
    
    case getAllHopeOnDatesForRequestedUserByUserId
    case getAllHopeOnDatesForRequestedPetByPetOnboardingId
    
    case getAllHopeOnDateLikesSentByUserId
    case getAllHopeOnDateLikesSentByPetOnboardingId
    
    case getHopeOnDateDetailsByHopeOnDateId
    case getHopeOnDateDetailsByPetHopeOnDateId
    
    
    
    //MARK: - delete profile
    case deletePetProfile
    case deleteUserProfile
    
    case updateUserActiveTime
    case getUserAllProfilesByUserId
    
    //likes
    case sendLikeOrDislike
    case sendLikeOrDislikeForPet
    
    case getAllLikesByUserId
    case getAllLikesByPetOnBoardingId
    
    case getAllLikesSentByUserId
    case getAllLikesSentByPetOnboardingId
    
    case getUserLikeByuserId
    case getPetLikeByPetOnboardingId
    
    case getUserLikeMatchByUserId
    case getPetLikeMatchByPetOnboardingIdAndUserId
    
    case activateOrDeactivateUserProfile
    case activateOrDeactivatePetProfile
    case updatePriorityProfile
    
    //ChatAPI
    case getConversationByUserId
    case getGroupListByUserId
    case getAllUserListForGroupByUserId
    case createGroup
    case createConversation
    case getMessagesByConversationId
    case sendMessage
    case sendMessageAsPhoto
    case sendGroupMessage
    case getMessagesByGroupId
    case getGroupDetailsByGroupId
    case getGroupInfoByGroupId
    case removeUserFromGroup
    case deleteInviteByInviteId
    case updateGroupDescription
    case addUserToGroup
    case updateGroupName
    case sendGroupMessageAsPhoto
    case uploadGroupProfilePhoto
    case getInviteSentListByUserId
    case getInviteListByUserId
    case getPetInviteListByUserId
    case getAllConversationAndGroupListByUserId
    case deleteGroup
    
    //CommmunityAPI
    case getCommunityGroupDetailsByGroupId
    case createCommunity
    case editCommunity
    case getCommunityGroupListByUserId
    case deleteCommunityGroup
    case joinORrequestCommunityGroup
    case acceptOrRejectUserCommunityRequest
    case sendCommunityGroupMessage
    case getMessagesByCommunicateGroupId
    case sendCommunityGroupMessageAsPhoto
    case messageReadUpdate
    case communityGroupRequestList
    case removeUserFromCommunityByAdmin
    case makeOrRemoveUserToAdmin
    case leaveCommunityByUser
    case filterCommunityGroup
    case getAllUserList
    case addUserToGroupByAdmin
    case commonSearch
    case acceptOrRejectInvite
    case acceptOrRejectInviteForPet
    case checkConversationByUserIdAndReceiverUserId
    case getCustomInterestListByUserId
    case getInviteListSentByUserId
    case updateMessageForOfferAcceptOrReject
    
    case unmatchPet
    case unmatchUser
    
    //Offers
    case sendOffer
    case sendOfferForPet
    
    case getAllOfferReceivedByUserId
    case getAllOfferReceivedByPetOnboardingIdAndUserId
    
    case getAllOfferSentByUserId
    case getAllOfferSentByPetOnboardingIdAndUserId
    
    case acceptOrRejectOffer
    case acceptOrRejectOfferForPet
    
    case resendOffer
    
    case getAllCount
    case getNotificationBudgeCount
    case updateNotificationBudgeCount
    //Subscription
    case getUserSubscription
    case getAllSubscriptionType
    case verifyUserTransaction
    case verifyUserReceipt
    case createSubscriptionSignature
}

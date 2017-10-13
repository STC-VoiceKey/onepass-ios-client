//
//  OPCOManager.h
//  OnePassCoreOnline
//
//  Created by Soloshcheva Aleksandra on 23.05.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

//#import "OPCOV4Manager.h"
#import <OnePassCore/OnePassCore.h>
#import "NSObject+JSON.h"

///-------------------------------------------------------------
/// Static Strings
///-------------------------------------------------------------
/**
 The constant name for the server URL in .plist file
 */
static NSString * _Nonnull kOnePassServerURL   = @"kOnePassServerURL";

/**
 The constant name for the server name in the user defaults store
 */
static NSString * _Nonnull kOnePassUserIDKey   = @"kOnePassOnlineDemoKeyChainKey";
///-------------------------------------------------------------
/// URL Params
///-------------------------------------------------------------
static NSString * _Nonnull kUsernameURLParam   = @"username";
static NSString * _Nonnull kDomainIdURLParam   = @"domainId";
static NSString * _Nonnull kPersonIdURLParam   = @"personId";
static NSString * _Nonnull kSampleURLParam     = @"sample";
static NSString * _Nonnull kDataURLParam       = @"data";
static NSString * _Nonnull kPasswordURLParam   = @"password";
static NSString * _Nonnull kGenderURLParam     = @"gender";
static NSString * _Nonnull kLDFeaturesURLParam = @"ldFeatures";
static NSString * _Nonnull kFaceURLParam       = @"faceSample";
static NSString * _Nonnull kFeaturesURLParam   = @"features";

static NSString * _Nonnull kCreateSession   = @"%@/session";

/**
 The constant name for the read person GET request
 @code
 example https://onepass.tech/vkonepass/rest/v4/person/test@test.com
 @endcode
 */
static NSString * _Nonnull kReadPersonById     = @"%@/person/%@";

/**
 The constant name for the delete person DELETE request
 @code
 http://vkplatform.speechpro.com/vkonepass/rest/person/test@test.com
 @endcode
 */
static NSString * _Nonnull kDeletePersonById   = @"%@/person/%@";
/**
 The constant name for the adding data for the verification session POST request
 @code
 https://onepass.tech/vkonepass/rest/v4/verification/f72e1f12-7064-4267-a294-7c3858d0a3da/data
 @endcode
 @warning Uses only, if you use FaceSDK on the device
 */
static NSString * _Nonnull kAddData2VerificationSession = @"%@/verification/%@/data";

/**
 The constant name for the create person and starting registration POST request
 @code
 @""
 @endcode
 */
static NSString * _Nonnull kStartRegistration   = @"%@/registration/person/%@";

/**
 The constant name for the adding face sample for the enrollment reference  POST request
 @code
 http://vkplatform.speechpro.com/vkonepass/rest/registration/face/file
 @endcode
 */
static NSString * _Nonnull kAddRegistrationFaceFile  = @"%@/registration/face/file";

/**
 The constant name for the adding voice file for the enrollment reference POST request
 @code
 http://vkplatform.speechpro.com/vkonepass/rest/registration/voice/dynamic/file
 @endcode
 */
static NSString * _Nonnull kAddRegistrationVoiceFile = @"%@/registration/voice/dynamic/file";

/**
 The constant name for the start verification POST request
 @code
 http://vkplatform.speechpro.com/vkonepass/rest/verification/person/www%40qqq.aaa
 @endcode
 */
static NSString * _Nonnull kStartVerification        = @"%@/verification/person/%@";

/**
 The constant name for the adding video for the verification session POST request
 @code
 http://vkplatform.speechpro.com/vkonepass/rest/verification/video/dynamic/file
 @endcode
 */
static NSString * _Nonnull kVerificationVideo        = @"%@/verification/video/dynamic/file";

/**
 The constant name for the adding face for the verification session POST request
 @code
 http://vkplatform.speechpro.com/vkonepass/rest/verification/face/file
 @endcode
 */
static NSString * _Nonnull kVerificationFace        = @"%@/verification/face/file";

/**
 The constant name for the verifing the person ПУЕ request
 @code
 http://vkplatform.speechpro.com/vkonepass/rest/verification/result
 @endcode
 */
static NSString * _Nonnull KverificationResult       = @"%@/verification/result";

/**
 The constant name for the verification score GET request
 @code
 http://vkplatform.speechpro.com/vkonepass/rest/verification/score
 @endcode
 */
static NSString * _Nonnull KverificationResultScore  = @"%@/verification/score";

/**
 The constant name for closing the verification session DELETE request
 @code
 http://vkplatform.speechpro.com/vkonepass/rest/verification
 @endcode
 */
static NSString * _Nonnull kVerification             = @"%@/verification";

static NSString * _Nonnull kChannelURLParam   = @"channel";
/**
 Is the implementation of 'IOPCTransportProtocol' for the online version.\n
 Provides the transport service for the server communication.
 API help
 @see http://vkplatform.speechpro.com/vkonepass/help/
 */
@interface OPCOManager : NSObject<IOPCTransportProtocol>//OPCOV4Manager
/**
 The server USRL string
 */
@property (nonatomic,readonly) NSString * _Nonnull serverUrl;

/**
 Shows the host accessibility.
 Is the implementation of required protocol method.
 */
@property (nonatomic,readonly) BOOL isHostAccessable;

@property (nonatomic,readonly) BOOL isSessionStarted;

@end

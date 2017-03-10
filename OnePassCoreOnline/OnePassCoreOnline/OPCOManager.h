//
//  OPCOManager.h
//  OnePassCoreOnline
//
//  Created by Soloshcheva Aleksandra on 15.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>

/**
 Is the implementation of 'IOPCTransportProtocol' for the online version.\n
 Provides the transport service for the server communication.
 API help 
 @see https://onepass.tech/vkonepass/help/
 */

///-------------------------------------------------------------
/// Static Strings
///-------------------------------------------------------------
/**
 The constant name for the server URL in .plist file 
 */
static NSString *kOnePassServerURL   = @"kOnePassServerURL";

/**
 The constant name for the server name in the user defaults store
 */
static NSString *kOnePassUserIDKey   = @"kOnePassOnlineDemoKeyChainKey";

/**
 The constant name for the read person GET request
 @code
 example https://onepass.tech/vkonepass/rest/v4/person/test@test.com
 @endcode
 */
static NSString *kReadPersonById     = @"%@/person/%@";

/**
 The constant name for the create person POST request
 @code
 https://onepass.tech/vkonepass/rest/v4/person?personId=test@test.com
 @endcode
 */
static NSString *kCreatePersonById   = @"%@/person";

/**
 The constant name for the delete person DELETE request
 @code
 https://onepass.tech/vkonepass/rest/v4/person/test@test.com
 @endcode
 */
static NSString *kDeletePersonById   = @"%@/person/%@";

/**
 The constant name for the adding face sample for the enrollment reference POST request
 @code
 https://onepass.tech/vkonepass/rest/v4/person/test@test.com/face/sample
 @endcode
 */

static NSString *kAddFaceSample2EnrollmentReference = @"%@/person/%@/face/sample";

/**
 The constant name for the adding voice file for the enrollment reference POST request
 @code
 https://onepass.tech/vkonepass/rest/v4/person/test@test.com/voice/dynamic/file
 @endcode
 */
static NSString *kAddVoiceFile2EnrollmentReference = @"%@/person/%@/voice/dynamic/file";

/**
 The constant name for the start verification GET request
 @code
 https://onepass.tech/vkonepass/rest/v4/verification/start/test@test.com
 @endcode
 */
static NSString *kStartVerificationSession = @"%@/verification/start/%@";

/**
 The constant name for the adding video for the verification session POST request
 @code
 https://onepass.tech/vkonepass/rest/v4/verification/f72e1f12-7064-4267-a294-7c3858d0a3da/video/dynamic
 @endcode
 */
static NSString *kAddVideo2VerificationSession = @"%@/verification/%@/video/dynamic";

/**
 The constant name for the adding data for the verification session POST request
 @code
 https://onepass.tech/vkonepass/rest/v4/verification/f72e1f12-7064-4267-a294-7c3858d0a3da/data
 @endcode
 @warning Uses only, if you use FaceSDK on the device
 */
static NSString *kAddData2VerificationSession = @"%@/verification/%@/data";

/**
 The constant name for verifing the person GET request
 @code
 https://onepass.tech/vkonepass/rest/v4/verification/f72e1f12-7064-4267-a294-7c3858d0a3da
 @endcode
*/
static NSString *kVerifyPerson = @"%@/verification/%@";

/**
 The constant name for the verification score GET request
 @warning Usually used for debugging.
 @code
 https://onepass.tech/vkonepass/rest/v4/verification/f72e1f12-7064-4267-a294-7c3858d0a3da/score
 @endcode
 */
static NSString *kVerificationScore = @"%@/verification/%@/score";

/**
 The constant name for closing the verification session DELETE request
@code
https://onepass.tech/vkonepass/rest/v4/verification/f72e1f12-7064-4267-a294-7c3858d0a3da/
@endcode
*/
static NSString *kCloseVerificationSession = @"%@/verification/%@";

///-------------------------------------------------------------
/// URL Params
///-------------------------------------------------------------
static NSString *kPersonIdURLParam   = @"personId";
static NSString *kSampleURLParam     = @"sample";
static NSString *kDataURLParam       = @"data";
static NSString *kPasswordURLParam   = @"password";
static NSString *kGenderURLParam     = @"gender";
static NSString *kLDFeaturesURLParam = @"ldFeatures";
static NSString *kFaceURLParam       = @"faceSample";
static NSString *kFeaturesURLParam   = @"features";

@interface OPCOManager : NSObject<IOPCTransportProtocol>

/**
 Shows the host accessibility.
 Is the implementation of required protocol method.
 */
@property (nonatomic,readonly) BOOL isHostAccessable;


@end

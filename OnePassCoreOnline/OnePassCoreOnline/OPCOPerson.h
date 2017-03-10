//
//  OPCOPerson.h
//  OnePassCoreOnline
//
//  Created by Soloshcheva Aleksandra on 15.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>

/**
 Is the implementation of 'IOPCPersonProtocol' for the online version.\n
 The person model is recived from the server
 */
@interface OPCOPerson : NSObject<IOPCPersonProtocol>

///---------------------
/// @name Initialization
///---------------------
/**
 The unique identifier of the person./n
 Is the implementation of required protocol method.
 */
@property (nonatomic) NSString *userID;

/**
  Shows that the person enrolled completely./n
  Is the implementation of required protocol method.
 */
@property (nonatomic) BOOL isFullEnroll;

///---------------------
/// @name Initialization
///---------------------

/**
 * Creates and returns an `OPCOPerson` object with specific JSON.
 * @code
 * JSON example
 *
 * {
 *    id = "test@test.ru";
 *    isFullEnroll = 1;
 *    models =     (
 *        {
 *            id = 9625;
 *            passwordPhrases =             (
 *                "zero one two three four five six seven eight nine",
 *                "nine eight seven six five four three two one zero",
 *                "five four six nine two eight seven zero one three"
 *            );
 *            samplesCount = 3;
 *            type = "DYNAMIC_VOICE_KEY";
 *        },
 *        {
 *            id = 9624;
 *            samplesCount = 1;
 *            type = "FACE_VACS";
 *        }
 *    );
 * }
 * @endcode
 * @param json The JSON containing data
 * @return The newly-initialized 'IOPCPersonProtocol' instance
 */
-(id)initWithJSON:(NSDictionary *)json;

@end

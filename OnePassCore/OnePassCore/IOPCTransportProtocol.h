//
//  IOPCTransportProtocol.h
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPCVerificationSessionProtocol.h"

/**
 Is the block which is called when data is received
 
 @param responceObject Responce data.\nIf data received successfully, 'error' is nil
 @param error Data receiving error.
 */
typedef void (^ResponceBlock) (NSDictionary *responceObject, NSError *error);

/**
 Is the block which is called when verification data is received
 
 @param session Current verification session instance of 'IOPCVerificationSessionProtocol'
 @param error Data receiving error.
 */
typedef void (^ResponceVerifyBlock) (id<IOPCVerificationSessionProtocol> session, NSError *error);

/**
 * The 'IOPCTransportProtocol' is protocol which implements communication operation with server or local resources.
 */
@protocol IOPCTransportProtocol <NSObject>

@optional

/**
 * Checking the host accessibility
 * @return The host accessibility
 */
-(BOOL)isHostAccessable;

@required

///--------------------------------------------
/// @name Person service
///--------------------------------------------

/**
 * Creates a person with personId.
 * @param personId The unique identifier of the person
 * @param block The response block called when the result is received
 */
-(void)createPerson:(NSString *)personId withCompletionBlock:(ResponceBlock) block;

/**
 * Receives the person by personId.
 * @param personId The unique identifier of the person
 * @param block The response block called when the result is received
 */
-(void)readPerson:(NSString *)personId withCompletionBlock:(ResponceBlock) block;

/**
 * Deletes the person.
 * @param personId The unique identifier of the person
 * @param block The response block called when the result is received
 */
-(void)deletePerson:(NSString *)personId withCompletionBlock:(ResponceBlock) block;

///--------------------------------------------
/// @name Enrollment process
///--------------------------------------------

/**
 * Adds FaceSample for the person.
 * @param imageData The image data as jpeg
 * @param personId The unique identifier of the person
 * @param block The response block called when the result is received
 */
-(void)addFaceSample:(NSData *)imageData forPerson:(NSString *)personId withCompletionBlock:(ResponceBlock)block;

/**
 * Adds VoiceFile for the person.
 * @param voiceData The voice data as a file (voice samples with the header)
 * @param passphrase The passphrase associated with the voice file
 * @param personId The unique identifier of the person
 * @param block The response block called when the result is received
 */
-(void)addVoiceFile:(NSData *)voiceData withPassphrase:(NSString *)passphrase forPerson:(NSString *)personId withCompletionBlock:(ResponceBlock)block;

///--------------------------------------------
/// @name Verification process
///--------------------------------------------

/**
 * Starts a verification session for the person.
 * @param personId The unique identifier of the person
 * @param block The response block called when the result is received
 */
-(void)startVerificationSession:(NSString *)personId  withCompletionBlock:(ResponceVerifyBlock)block;

/**
 * Adds the verification video for the person.
 * @param video The video data as a file 
 * @param session The verification session id.
 * @param passcode The passphrase associated with the video file
 * @param block The response block called when the result is received
 */
-(void)addVerificationVideo:(NSData *)video
                 forSession:(NSString *)session
               withPasscode:(NSString *)passcode
        withCompletionBlock:(ResponceBlock)block;

/**
 * Verifies the person authenticity.
 * @param session The verification session id.
 * @param block The response block called when the result is received
 */
-(void)verify:(NSString *)session withCompletionBlock:(ResponceBlock)block;

/**
 * Gets the verification session score.
 * @warning Usually used for debugging.
 * @param session The verification session id.
 * @param block The response block called when the result is received
 *
 * @see -verify:withCompletionBlock:
 */
-(void)verifyScore:(NSString *)session withCompletionBlock:(ResponceBlock)block;

/**
 * Closes the verification session.
 * @param session The verification session id.
 * @param block The response block called when the result is received
 */
-(void)closeVerification:(NSString *)session withCompletionBlock:(ResponceBlock)block;

///--------------------------------------------------------
/// @name Verification process with Liveness (additional)
///--------------------------------------------------------

/**
 * Adds verification data for the verification session.
 * @warning You can use this method only if you use FaceSDK on the device. In common use @see -addVerificationVideo:forSession:withPasscode:withCompletionBlock:
 * @param imageData The image data as jpeg
 * @param voiceFeatures The voice features (VSDK)
 * @param ldFeatures The LD features (FaceSDK)
 * @param session The verification session id.
 * @param passcode The passphrase associated with the data
 * @param block The response block called when the result is received
 */
-(void)addVerificationData:(NSData *)imageData
         withVoiceFeatures:(NSData *)voiceFeatures
            withLdFeatures:(NSData *)ldFeatures
                forSession:(NSString *)session
              withPasscode:(NSString *)passcode
       withCompletionBlock:(ResponceBlock)block;

@end



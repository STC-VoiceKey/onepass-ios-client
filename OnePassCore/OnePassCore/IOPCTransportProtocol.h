//
//  IOPCTransportProtocol.h
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPCVerificationSessionProtocol.h"
#import "IOPCSession.h"

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

/**
 * Shows the security session started
 */
-(BOOL)isSessionStarted;

@required

-(void)setSessionData:(id<IOPCSession>)sessionData;

-(void)setServerURL:(NSString *)url;

-(void)setSessionServerURL:(NSString *)url;

///--------------------------------------------
/// @name Session service
///--------------------------------------------

/**
 * Creates a a security session.
 * @param block The response block called when the result is received
 */
-(void)createSessionWithCompletionBlock:(ResponceBlock) block;

/**
* Closes and deletes the security session.
* @param block The response block called when the result is received
*/
-(void)deleteSessionWithCompletionBlock:(ResponceBlock) block;

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
 * @param block The response block called when the result is received
 */
-(void)addFaceSample:(NSData *)imageData withCompletionBlock:(ResponceBlock)block;

/**
 * Adds VoiceFile for the person.
 * @param voiceData The voice data as a file (voice samples with the header)
 * @param passphrase The passphrase associated with the voice file
 * @param block The response block called when the result is received
 */
-(void)addVoiceFile:(NSData *)voiceData withPassphrase:(NSString *)passphrase withCompletionBlock:(ResponceBlock)block;

/**
 * Adds Static VoiceFile for the person.
 * @param voiceData The voice data as a file (voice samples with the header)
 * @param block The response block called when the result is received
 */
-(void)addStaticVoiceFile:(NSData *)voiceData withCompletionBlock:(ResponceBlock)block;


///--------------------------------------------
/// @name Verification process
///--------------------------------------------

/**
 * Starts a verification session for the person.
 * @param personId The unique identifier of the person
 * @param block The response block called when the result is received
 */
-(void)startVerificationSession:(NSString *)personId withCompletionBlock:(ResponceVerifyBlock)block;

/**
 * Adds the verification video for the person.
 * @param video The video data as a file
 * @param passphrase The passphrase associated with the video file
 * @param block The response block called when the result is received
 */
-(void)addVerificationVideo:(NSData *)video
             withPassphrase:(NSString *)passphrase
        withCompletionBlock:(ResponceBlock)block;

/**
 * Adds the verification face for the person.
 * @param face The face data as a file
 * @param block The response block called when the result is received
 */
-(void)addVerificationFace:(NSData *)face
       withCompletionBlock:(ResponceBlock)block;

/**
 * Adds the verification voice for the person.
 * @param voice The voice data as a file
 * @param block The response block called when the result is received
 */
-(void)addVerificationVoice:(NSData *)voice
             withPassphrase:(NSString *)passphrase
        withCompletionBlock:(ResponceBlock)block;

/**
 * Adds the verification static voice for the person.
 * @param voice The voice data as a file
 * @param block The response block called when the result is received
 */
-(void)addVerificationStaticVoice:(NSData *)voice
        withCompletionBlock:(ResponceBlock)block;

/**
 * Verifies the person authenticity.
 * @param block The response block called when the result is received
 */
-(void)verifyResultWithCompletionBlock:(ResponceBlock)block;

/**
 * Gets the verification session score.
 * @warning Usually used for debugging.
 * @param block The response block called when the result is received
 *
 * @see -verify:withCompletionBlock:
 */
-(void)verifyScoreWithCompletionBlock:(ResponceBlock)block;

/**
 * Closes the verification session.
 * @param block The response block called when the result is received
 */
-(void)closeVerificationWithCompletionBlock:(ResponceBlock)block;

@end



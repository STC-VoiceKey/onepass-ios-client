//
//  ITransport.h
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVerifySession.h"

typedef void (^ResponceBlock) (NSDictionary *responceObject, NSError *error);
typedef void (^ResponceVerifyBlock) (id<IVerifySession> session, NSError *error);
/*
 * The interface which implements communication operation with server or local resources.
 * You can use all operations from person and verification scenario.
 */
@protocol ITransport <NSObject>

@optional

-(BOOL)isHostAccessable;

@required

/*
 * Creates person with personId as id.
 */
-(void)createPerson:(NSString *)personId withCompletionBlock:(ResponceBlock) block;

/*
 * Retrieves person with personId.
 */
-(void)readPerson:(NSString *)personId withCompletionBlock:(ResponceBlock) block;

/*
 * Deletes person.
 */
-(void)deletePerson:(NSString *)personId withCompletionBlock:(ResponceBlock) block;

/*
 * Adds FaceSample for the person.
 */
-(void)addFaceSample:(NSData *)imageData forPerson:(NSString *)personId withCompletionBlock:(ResponceBlock)block;

/*
 * Adds VoiceSample for the person.
 */
-(void)addVoiceFile:(NSData *)voiceData withPassphrase:(NSString *)passphrase forPerson:(NSString *)personId withCompletionBlock:(ResponceBlock)block;


/*
 * Starts verification session for the person.
 */
-(void)startVerificationSession:(NSString *)personId  withCompletionBlock:(ResponceVerifyBlock)block;
//-(void)startVerificationSession:(NSString *)personId  withCompletionBlock:(ResponceBlock)block;


/*
* Adds FaceSample for the verification.
*/
-(void)addVerificationFaceSample:(NSData *)imageData
                      forSession:(NSString *)session
             withCompletionBlock:(ResponceBlock)block;

/*
 * Adds Video to server.
 * This method may be used instead {@link #addVerificationFaceSample(VerificationSession, byte[])}
 * and {@link #addVerificationFaceModel(VerificationSession, byte[])}, but only it is used for liveness.
 */
-(void)addVerificationVideo:(NSData *)video
                 forSession:(NSString *)session
               withPasscode:(NSString *)passcode
        withCompletionBlock:(ResponceBlock)block;

/*
 * Verifies the person authenticity.
 */
-(void)verify:(NSString *)session withCompletionBlock:(ResponceBlock)block;

-(void)verifyScore:(NSString *)session withCompletionBlock:(ResponceBlock)block;

/*
 * Closes verification session.
 */
-(void)closeVerification:(NSString *)session withCompletionBlock:(ResponceBlock)block;

@end


/*
 * Adds VoiceSample for the person.
 *
 void addVoiceSample(String personId, byte[] voiceSample, String passphrase, boolean isDynamic) throws CoreException;
 
 * Adds VoiceSample for the person with gender.
 *
 void addVoiceSample(String personId, byte[] voiceSample, String passphrase, int gender, boolean isDynamic) throws CoreException;
 
 * Adds VoiceFeature for the person.
 *
 void addVoiceFeature(String personId, byte[] voiceFeature, boolean isDynamic) throws CoreException;
 
 * Adds VoiceFeature for the person without password.
 *
 void addVoiceFeature(String personId, byte[] voiceFeature, int gender, boolean isDynamic) throws CoreException;
 
 * Adds VoiceFeature for the person with gender.
 *
 void addVoiceFeature(String personId, byte[] voiceFeature, String password, int gender, boolean isDynamic) throws CoreException;
 
 * Deletes voice for the person.
 *
 void deleteVoice(String personId) throws CoreException;
 
 * Adds FaceModel for the person.
 *
 void addFaceModel(String personId, byte[] faceModel) throws CoreException;
 
 * Adds FaceSample for the person.
 *
 void addFaceSample(String personId, byte[] faceSample) throws CoreException;
 
 * Deletes face for the person.
 *
 void deleteFace(String personId) throws CoreException;
 
 * Starts verification session for the person.
 *
 VerificationSession startVerificationSession(String personId) throws CoreException;
 
 * Adds VoiceSample for the verification with gender.
 *
 void addVerificationVoiceSample(VerificationSession session, byte[] voiceSample, int gender, boolean isDynamic) throws CoreException;
 
 * Adds VoiceFeature for the verification with gender.
 *
 void addVerificationVoiceFeature(VerificationSession session, byte[] voiceFeature, int gender, boolean isDynamic) throws CoreException;
 
 * Adds FaceModel for the verification.
 *
 void addVerificationFaceModel(VerificationSession session, byte[] faceModel) throws CoreException;
 
 * Adds FaceSample for the verification with gender.
 *
 void addVerificationFaceSample(VerificationSession session, byte[] faceSample) throws CoreException;

 
 * Checks liveness.
 *
 boolean liveness(VerificationSession session) throws CoreException;
 
 * Checks liveness.
 *
 void addLivenessData(VerificationSession session, byte[] voiceSample, String passphrase, int gender, boolean isDynamic, byte[] videoSample) throws CoreException;

 
 */
//
//  OPCRCaptureManager.m
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 27.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCRCaptureManager.h"
#import "OPCRFaceView.h"
#import "OPCRPreviewView.h"

@interface OPCRCaptureManager()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong)  AVCaptureSession *session;
@property (nonatomic) dispatch_queue_t sessionQueue;

@property (nonatomic,weak) OPCRPreviewView *viewForRelay;

@property (strong, nonatomic) AVCaptureDevice  *device;

@property (strong, nonatomic) AVCaptureMetadataOutput *metadataOutput;
@property (strong, nonatomic) NSMutableDictionary     *faceViews;

@property (nonatomic,strong)  AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic) BOOL isReady;

@end

@implementation OPCRCaptureManager

-(id)initWithView:(OPCRPreviewView *)view{
    self = [super init];
    if(self){
        self.viewForRelay = view;
        [self setupAVCapture];
    }
    return self;
}

- (void) setupAVCapture
{
    self.session = [[AVCaptureSession alloc] init];
    
    [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    self.viewForRelay.session = self.session;
    [self updateCameraSelection];
    
    // For displaying live feed to screen
    self.previewLayer = (AVCaptureVideoPreviewLayer *)self.viewForRelay.layer;
    [self.previewLayer setMasksToBounds:YES];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    
    // For receiving AV Foundation face detection
    [self setupAVFoundationFaceDetection];
    
    self.sessionQueue = dispatch_queue_create( "CaptureDataOutputQueue", DISPATCH_QUEUE_SERIAL );
    
    self.isReady = NO;
    
}


-(void)startRunning{
    [self.session startRunning];
}

-(void)stopRunning{
    [self.session stopRunning];
}

- (void) updateCameraSelection
{
    [self.session beginConfiguration];
    
    // have to remove old inputs before we test if we can add a new input
    NSArray* oldInputs = [self.session inputs];
    for (AVCaptureInput *oldInput in oldInputs)
        [self.session removeInput:oldInput];
    
    AVCaptureDeviceInput* input = [self pickCamera];
    if ( ! input ) {
        // failed, restore old inputs
        for (AVCaptureInput *oldInput in oldInputs)
            [self.session addInput:oldInput];
    } else {
        // succeeded, set input and update connection states
        [self.session addInput:input];
        self.device = input.device;
        
        NSError* err;
        if ( ! [self.device lockForConfiguration:&err] ) {
            NSLog(@"Could not lock device: %@",err);
        }
        [self updateAVFoundationFaceDetection];
    }
    
    [self.session commitConfiguration];
}

- (AVCaptureDeviceInput*) pickCamera
{
    AVCaptureDevicePosition desiredPosition = AVCaptureDevicePositionFront;
    BOOL hadError = NO;
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            NSError *error = nil;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:&error];
            if (error) {
                hadError = YES;
                //displayErrorOnMainQueue(error, @"Could not initialize for AVMediaTypeVideo");
            } else if ( [self.session canAddInput:input] ) {
                return input;
            }
        }
    }
    if ( ! hadError ) {
        //displayErrorOnMainQueue(nil, @"No camera found for requested orientation");
    }
    return nil;
}

#pragma mark - Face Detection
- (void) setupAVFoundationFaceDetection
{
    self.faceViews = [NSMutableDictionary new];
    
    self.metadataOutput = [AVCaptureMetadataOutput new];
    if ( ! [self.session canAddOutput:self.metadataOutput] ) {
        self.metadataOutput = nil;
        return;
    }
    
    // Metadata processing will be fast, and mostly updating UI which should be done on the main thread
    // So just use the main dispatch queue instead of creating a separate one
    [self.metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:self.metadataOutput];
    
    if ( ! [self.metadataOutput.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeFace] ) {
        // face detection isn't supported via AV Foundation
        [self teardownAVFoundationFaceDetection];
        return;
    }
    self.metadataOutput.metadataObjectTypes = @[ AVMetadataObjectTypeFace ];
    [self updateAVFoundationFaceDetection];
}

- (void) updateAVFoundationFaceDetection
{
    if ( self.metadataOutput )
        [[self.metadataOutput connectionWithMediaType:AVMediaTypeMetadata] setEnabled:YES];
}

- (void) teardownAVFoundationFaceDetection
{
    if ( self.metadataOutput )
        [self.session removeOutput:self.metadataOutput];
    self.metadataOutput = nil;
    self.faceViews = nil;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate <NSObject>

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)faces fromConnection:(AVCaptureConnection *)connection
{
    NSMutableSet* unseen = [NSMutableSet setWithArray:self.faceViews.allKeys];
    NSMutableSet* seen = [NSMutableSet setWithCapacity:faces.count];
    
    // Begin display updates
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    for ( AVMetadataFaceObject * object in faces )
    {
        NSNumber* faceID = @(object.faceID);
        [unseen removeObject:faceID];
        [seen addObject:faceID];
        
        OPCRFaceView * view = self.faceViews[faceID];
        if ( ! view )
        { // new face, create a layer
            view = [OPCRFaceView new];
//            view.layer.cornerRadius = 10;
//            view.layer.borderWidth = 3;
//            view.layer.borderColor = [[UIColor greenColor] CGColor];
//            
//            [self.viewForRelay addSubview:view];
            
            self.faceViews[faceID] = view;
            view.faceID = [faceID integerValue];
        }
        
        AVMetadataFaceObject * adjusted = (AVMetadataFaceObject*)[(AVCaptureVideoPreviewLayer*)self.viewForRelay.layer transformedMetadataObjectForMetadataObject:object];
        [view setFrame:adjusted.bounds];
    }
    
    // remove the faces that weren't detected
    for ( NSNumber* faceID in unseen ) {
        OPCRFaceView* view = self.faceViews[faceID];
        [view removeFromSuperview];
        [self.faceViews removeObjectForKey:faceID];
    }
    
    //STC Face Detector Functionality
    if(self.faceViews.count!=1){
        [self.viewForRelay failBorder];
        if (self.isReady) {
            self.isReady = NO;
        }
    }else
    {
        [self.viewForRelay failBorder];
        
        if ([UIDevice currentDevice].orientation==UIDeviceOrientationPortrait )
        {
            OPCRPreviewView *view = [self.faceViews.allValues objectAtIndex:0];
        
            CGRect screenRect = self.viewForRelay.bounds;
            CGRect faceRect   = view.frame;
            float deltaWidth = screenRect.size.width - (faceRect.size.width - faceRect.origin.x);
            float deltaWidthPercent = deltaWidth / screenRect.size.width;
            
            if(deltaWidthPercent < 0.7)//проверка что лицо вписывается по ширине
            {
                float deltaVerticalCenter = (screenRect.size.height/2) - (faceRect.origin.y+faceRect.size.height/2);
                float deltaVerticalCenter20Percent = screenRect.size.height * 0.3;
                if(deltaVerticalCenter < deltaVerticalCenter20Percent)//проверяем что центр лица совпадает с центром экрана
                {
                    [self.viewForRelay successBorder];
                    if (!self.isReady) {
                        self.isReady = YES;
                    }

                    [self update];
                }
            }
        
        }
    }
    
    [CATransaction commit];
    
}

-(void)update{
    
}


@end

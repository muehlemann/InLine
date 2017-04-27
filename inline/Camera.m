//
//  Camera.m
//  inline
//
//  Created by Matti Muehlemann on 1/16/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import "Camera.h"

@implementation Camera

/**
 * Initializes the class
 *
 * @return self
 */
- (id)init
{
    self = [super self];
    if (self)
    {
        // Configure things here
        // Initialize the session
        session = [[AVCaptureSession alloc] init];
        [session setAutomaticallyConfiguresCaptureDeviceForWideColor:YES];
        
        if ([session canSetSessionPreset:AVCaptureSessionPresetHigh])
            [session setSessionPreset:AVCaptureSessionPresetHigh];
        else
            [session setSessionPreset:AVCaptureSessionPresetMedium];
        
        // Add video inputs
        videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
        
        flash = false;
        
        if (videoDevice)
        {
            NSError *error;
            AVCaptureDeviceInput *videoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
            if (!error)
            {
                if ([session canAddInput:videoInputDevice])
                    [session addInput:videoInputDevice];
                else
                    NSLog(@"Couldn't add video input");
            }
            else
            {
                NSLog(@"Couldn't create video input");
            }
        }
        else
        {
            NSLog(@"Couldn't create video capture device");
        }
        
        // Add video preview
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        [previewLayer setFrame:CGRectMake(0, 0, _VW, _VH)];
        [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        // Add video output
        photoOutput = [[AVCapturePhotoOutput alloc] init];
        [photoOutput setLivePhotoCaptureEnabled:NO];
        [photoOutput setHighResolutionCaptureEnabled:YES];
        [session addOutput:photoOutput];
        
        // Start the session
        [session startRunning];
        
        // Display video preview
        cameraPreviewView = [[UIView alloc] init];
        [cameraPreviewView.layer addSublayer:previewLayer];
    }
    
    return self;
}

/**
 * Get the camera feed of the preview layer
 *
 */
- (UIView *)getFeed
{
    return cameraPreviewView;
}

/**
 * Takes the photo
 *
 */
- (void)takePhoto
{
    AVCapturePhotoSettings *settings = [[AVCapturePhotoSettings alloc] init];
    [settings setHighResolutionPhotoEnabled:YES];
    [settings setAutoStillImageStabilizationEnabled:YES];
    [settings setFlashMode:(flash ? AVCaptureFlashModeOn : AVCaptureFlashModeOff)];
    
    // Take a photo
    [photoOutput capturePhotoWithSettings:settings delegate:self];
}

/**
 * Enables the flash
 *
 */
- (void)enableFlash
{
    // Change the flash
    flash = !flash;
}

/**
 * Flip the camera
 *
 */
- (void)flipCamera
{
    if ([videoDevice position] == AVCaptureDevicePositionFront) {
        videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    } else {
        videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    }
    
    // Add video device to the session
    if (videoDevice)
    {
        NSError *error;
        AVCaptureDeviceInput *videoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        for (AVCaptureDeviceInput *input in session.inputs)
            [session removeInput:input];
        
        if (!error)
        {
            if ([session canAddInput:videoInputDevice])
                [session addInput:videoInputDevice];
            else
                NSLog(@"Couldn't add video input");
            // TODO: display error
        }
        else
        {
            // TODO: display error
            NSLog(@"Couldn't create video input");
        }
    }
    else
    {
        // TODO: display error
        NSLog(@"Couldn't create video capture device");
    }
}

/**
 * Process the buffer from the photoOutput when an image is captured
 *
 * @p captureOutput
 * @p photoSampleBuffer
 * @p previewPhotoSampleBuffer
 * @p resolvedSettings
 * @p bracketSettings
 * @p error
 */
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error
{
    // Capture the output and convert into data from stream.
    // Take that data and covert into image
    NSData *imgData = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *img = [UIImage imageWithData:imgData];
    
    // Adjust image if its a selfie.
    if ([videoDevice position] == AVCaptureDevicePositionFront) {
        img = [UIImage imageWithCGImage:[img CGImage]
                                  scale:[img scale]
                            orientation:UIImageOrientationLeftMirrored];
    }

    // Send notification for image taken.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photo_taken" object:img];
}

@end

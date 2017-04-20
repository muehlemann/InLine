//
//  Camera.h
//  inline
//
//  Created by Matti Muehlemann on 1/16/17.
//  Copyright © 2017 Matt Mühlemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"

@interface Camera : NSObject <AVCapturePhotoCaptureDelegate>
{
    UIView *cameraPreviewView;
    
    AVCaptureSession *session;
    AVCapturePhotoOutput *photoOutput;
    AVCaptureDevice *videoDevice;
    BOOL flash;
}

- (id)init;
- (UIView *)getFeed;
- (void)takePhoto;
- (void)enableFlash;
- (void)flipCamera;

@end

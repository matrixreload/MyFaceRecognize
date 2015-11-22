//
//  CaptureImageViewController.h
//  MyFaceRecognize
//
//  Created by air on 15/11/22.
//  Copyright © 2015年 matrix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceDetector.h"
#import "OpenCVData.h"
#import "rootViewController.h"
#import <opencv2/highgui/cap_ios.h>
#import "CustomFaceRecognizer.h"

@interface CaptureImageViewController :rootViewController  <CvVideoCameraDelegate,UITextViewDelegate>
@property (nonatomic, strong) UILabel               *instructionsLabel;
@property (nonatomic, strong) UITextView            *nameTextView;
@property (nonatomic, strong) UIButton              *cameraButton;
@property (nonatomic, strong) UIImageView           *previewImage;
@property (nonatomic, strong) NSString              *personName;
@property (nonatomic, strong) NSNumber              *personID;
@property (nonatomic, strong) FaceDetector          *faceDetector;
@property (nonatomic, strong) CustomFaceRecognizer  *faceRecognizer;
@property (nonatomic, strong) CvVideoCamera         *videoCamera;
@property (nonatomic, strong) CALayer               *featureLayer;
@property (nonatomic) NSInteger                     frameNum;
@property (nonatomic) NSInteger                     numPicsTaken;



- (void)btnsave:(id)sender;

@end

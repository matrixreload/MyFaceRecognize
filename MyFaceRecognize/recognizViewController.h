//
//  recognizViewController.h
//  MyFaceRecognize
//
//  Created by air on 15/11/21.
//  Copyright © 2015年 matrix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/cap_ios.h>
#import "rootViewController.h"
#import "CustomFaceRecognizer.h"
#import "FaceDetector.h"
#import "OpenCVData.h"

@interface recognizViewController : rootViewController <CvVideoCameraDelegate>

@property(nonatomic, strong) UIImageView            *imageView;
@property(nonatomic, strong) UILabel                *instructionLabel;
@property(nonatomic, strong) UILabel                *confidenceLabel;
@property(nonatomic, strong) FaceDetector           *faceDetector;
@property(nonatomic, strong) CustomFaceRecognizer   *faceRecognizer;
@property(nonatomic, strong) CvVideoCamera          *videoCamera;
@property(nonatomic, strong) CALayer                *featureLayer;
@property(nonatomic) NSInteger                      frameNum;
@property(nonatomic) BOOL                           modelAvailable;

@end

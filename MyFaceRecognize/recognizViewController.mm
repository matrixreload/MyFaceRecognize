//
//  recognizViewController.m
//  MyFaceRecognize
//
//  Created by air on 15/11/21.
//  Copyright © 2015年 matrix. All rights reserved.
//

#import "recognizViewController.h"
#import "CustomFaceRecognizer.h"
#import "FaceDetector.h"
#import "OpenCVData.h"


#define WIDTH   288
#define HEIGHT  352
#define FPS     30

@interface recognizViewController ()

@end

@implementation recognizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faceDetector = [[FaceDetector alloc] init];
    self.faceRecognizer = [[CustomFaceRecognizer alloc] initWithEigenFaceRecognizer];//
    
    //draw the UI
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.y += 30;
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-WIDTH)/2, frame.origin.y+20,  WIDTH,HEIGHT)];
    frame.origin.y += self.imageView.frame.size.height + 20;
    
    self.instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-100)/2, frame.origin.y+10, 300, 20)];
    frame.origin.y += self.instructionLabel.frame.size.height + 20;
    
    self.confidenceLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-100)/2, frame.origin.y+10, 300, 20)];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.instructionLabel];
    [self.view addSubview:self.confidenceLabel];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.modelAvailable = [self.faceRecognizer trainModel];
    
    if (!self.modelAvailable) {
        self.instructionLabel.text = @"add people first";
    }
    
    [self setupCamera];
    [self.videoCamera start];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.videoCamera stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupCamera{
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset  = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = FPS;
    self.videoCamera.grayscaleMode = NO;
}

- (void)processImage:(cv::Mat&)image{
    
    if (self.frameNum == FPS) {
        [self parseFaces:[self.faceDetector facesFromImage:image] forImage:image];
        self.frameNum = 0;
    }
    
    self.frameNum++;

}

- (void)parseFaces:(const std::vector<cv::Rect> &)faces forImage:(cv::Mat&)image
{
    // No faces found
    if (faces.size() != 1) {
        [self noFaceToDisplay];
        return;
    }
    
    // We only care about the first face
    cv::Rect face = faces[0];
    
    // By default highlight the face in red, no match found
    CGColor *highlightColor = [[UIColor redColor] CGColor];
    NSString *message = @"No match found";
    NSString *confidence = @"";
    
    // Unless the database is empty, try a match
    if (self.modelAvailable) {
        NSDictionary *match = [self.faceRecognizer recognizeFace:face inImage:image];
        
        // Match found
        if ([match objectForKey:@"personID"] != [NSNumber numberWithInt:-1]) {
            message = [match objectForKey:@"personName"];
            highlightColor = [[UIColor greenColor] CGColor];
            
            NSNumberFormatter *confidenceFormatter = [[NSNumberFormatter alloc] init];
            [confidenceFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            confidenceFormatter.maximumFractionDigits = 2;
            
            confidence = [NSString stringWithFormat:@"Confidence: %@",
                          [confidenceFormatter stringFromNumber:[match objectForKey:@"confidence"]]];
        }
    }
    
    // All changes to the UI have to happen on the main thread
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.instructionLabel.text = message;
        self.confidenceLabel.text = confidence;
        [self highlightFace:[OpenCVData faceToCGRect:face] withColor:highlightColor];
    });
}


- (void)noFaceToDisplay
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.instructionLabel.text = @"No face in image";
        self.confidenceLabel.text = @"";
        self.featureLayer.hidden = YES;
    });
}

- (void)highlightFace:(CGRect)faceRect withColor:(CGColor *)color
{
    if (self.featureLayer == nil) {
        self.featureLayer = [[CALayer alloc] init];
        self.featureLayer.borderWidth = 4.0;
    }
    
    [self.imageView.layer addSublayer:self.featureLayer];
    
    self.featureLayer.hidden = NO;
    self.featureLayer.borderColor = color;
    self.featureLayer.frame = faceRect;
}

@end

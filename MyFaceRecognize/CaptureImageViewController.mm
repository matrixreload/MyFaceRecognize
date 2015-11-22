//
//  CaptureImageViewController.m
//  MyFaceRecognize
//
//  Created by air on 15/11/22.
//  Copyright © 2015年 matrix. All rights reserved.
//

#import "CaptureImageViewController.h"

#define WIDTH   288
#define HEIGHT  352
#define FPS     30

@interface CaptureImageViewController ()

@end

@implementation CaptureImageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faceDetector = [[FaceDetector alloc] init];
    self.faceRecognizer = [[CustomFaceRecognizer alloc] init];
    
    
    //[self setupCamera];
    
    //draw the UI
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.y += 30;
    
    self.previewImage = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-WIDTH)/2, frame.origin.y+20,  WIDTH,HEIGHT)];
    frame.origin.y += self.previewImage.frame.size.height + 20;
    
    self.instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-100)/2, frame.origin.y+10, 300, 20)];
    frame.origin.y += self.instructionsLabel.frame.size.height + 20;
    
    self.cameraButton = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-100)/2, frame.origin.y+10, 300, 20)];
    frame.origin.y += self.cameraButton.frame.size.height + 20;
    self.cameraButton.backgroundColor = [UIColor blueColor];
    [self.cameraButton setTitle:@"save" forState:UIControlStateNormal];
    [self.cameraButton addTarget:self action:@selector(btnsave:) forControlEvents:UIControlEventTouchDown];
    
    self.nameTextView = [[UITextView alloc] initWithFrame:CGRectMake((frame.size.width-100)/2, frame.origin.y+10, 100, 20)];
    
    
    [self.view addSubview:self.previewImage];
    [self.view addSubview:self.instructionsLabel];
    [self.view addSubview:self.cameraButton];
    [self.view addSubview:self.nameTextView];
}

- (void)btnsave:(id)sender{
    if (self.nameTextView.text.length > 0) {
        self.personID =[NSNumber numberWithInt:[self.faceRecognizer newPersonWithName:self.nameTextView.text]];
        [self setupCamera];
        
        [self.videoCamera start];
    }
    else
    {
        self.instructionsLabel.text = @"请输入姓名";
    }
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    [self.videoCamera start];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.videoCamera stop];
}


- (void)setupCamera
{
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.previewImage];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
}


- (void)processImage:(cv::Mat&)image
{
    // Only process every 60th frame (every 2s)
    if (self.frameNum == 60) {
        [self parseFaces:[self.faceDetector facesFromImage:image] forImage:image];
        self.frameNum = 1;
    }
    else {
        self.frameNum++;
    }
}

- (void)parseFaces:(const std::vector<cv::Rect> &)faces forImage:(cv::Mat&)image
{
    if (faces.size() != 1) {
        [self noFaceToDisplay];
        return;
    }
    
    // We only care about the first face
    cv::Rect face = faces[0];
    
    // Learn it
    [self.faceRecognizer learnFace:face ofPersonID:[self.personID intValue] fromImage:image];
    
    self.numPicsTaken++;
    
    NSMutableArray* arry = [self.faceRecognizer getAllPeople];
    
    NSLog(@"all the people  %d", [arry count]);
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self highlightFace:[OpenCVData faceToCGRect:face]];
        self.instructionsLabel.text = [NSString stringWithFormat:@"Taken %ld of 10", (long)self.numPicsTaken];
        
        
        
        if (self.numPicsTaken == 10) {
            self.featureLayer.hidden = YES;
            [self.videoCamera stop];
            
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done"
//                                                            message:@"10 pictures have been taken."
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
            
            
            
            //[self.navigationController popViewControllerAnimated:YES];
        }
    });
}

- (void)noFaceToDisplay
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.featureLayer.hidden = YES;
    });
}

- (void)highlightFace:(CGRect)faceRect
{
    if (self.featureLayer == nil) {
        self.featureLayer = [[CALayer alloc] init];
        self.featureLayer.borderColor = [[UIColor redColor] CGColor];
        self.featureLayer.borderWidth = 4.0;
        [self.previewImage.layer addSublayer:self.featureLayer];
    }
    
    self.featureLayer.hidden = NO;
    self.featureLayer.frame = faceRect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationAddButton:(id)sender{
    
}

- (void)navigationBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nameTextView resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

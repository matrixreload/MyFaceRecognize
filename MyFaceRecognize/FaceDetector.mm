//
//  FaceDetector.m
//  MyFaceRecognize
//
//  Created by matrix on 15/11/20.
//  Copyright © 2015年 matrix. All rights reserved.
//

#import "FaceDetector.h"

NSString *const KfaceCascadeFilename= @"haarcascade_frontalface_alt2";

const int kHaarOptions = CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH ;



@implementation FaceDetector


- (id)init
{
    self = [super init];
    if (self) {
        
        NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:KfaceCascadeFilename ofType:@"xml"];
        
        if (!_faceCascade.load([faceCascadePath UTF8String])) {
            
            NSLog(@"counld not load face cascade: %@", faceCascadePath);
        }
    }
    
    return self;
}

- (std::vector<cv::Rect>)facesFromImage:(cv::Mat &)image{
    
    std::vector<cv::Rect> faces;
    
    _faceCascade.detectMultiScale(image, faces, 1.1, 2, kHaarOptions,cv::Size(30,30));
    
    return faces;
}

@end

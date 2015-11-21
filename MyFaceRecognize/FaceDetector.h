//
//  FaceDetector.h
//  MyFaceRecognize
//
//  Created by matrix on 15/11/20.
//  Copyright © 2015年 matrix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/objdetect/objdetect.hpp>


@interface FaceDetector : NSObject
{
    cv::CascadeClassifier _faceCascade;
}

- (std::vector<cv::Rect>) facesFromImage:(cv::Mat&)image;

@end

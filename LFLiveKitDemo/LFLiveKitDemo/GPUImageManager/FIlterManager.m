//
//  FIlterManager.m
//  视频功能开发
//
//  Created by mac on 2019/7/23.
//  Copyright © 2019 cc. All rights reserved.
//

#import "FIlterManager.h"
#import "GPUImageBeautifyFilter.h"

@implementation FIlterManager

- (GPUImageOutput*)addFilter_Sketch{
    
    GPUImageSketchFilter *filter = [[GPUImageSketchFilter alloc] init];
    [filter useNextFrameForImageCapture];
    return filter;
}

- (GPUImageOutput*)addFilter_Beautify{
    
    GPUImageBeautifyFilter *filter = [[GPUImageBeautifyFilter alloc] init];
    return filter;
}

- (GPUImageOutput*)addFilter_Gamma{
    
    GPUImageGammaFilter * filter = [[GPUImageGammaFilter alloc] init];
    [filter setGamma:3.0];
    [filter useNextFrameForImageCapture];
    return filter;
}

- (GPUImageOutput*)addFilter_ColorInvert{
    
    GPUImageColorInvertFilter * filter = [[GPUImageColorInvertFilter alloc] init];
    [filter useNextFrameForImageCapture];
    return filter;
}

- (GPUImageOutput*)addFilter_Sepia{
    
    GPUImageSepiaFilter * filter = [[GPUImageSepiaFilter alloc] init];
    [filter useNextFrameForImageCapture];
    return filter;
}

- (GPUImageOutput*)addFilter_Grayscale{
    
    GPUImageGrayscaleFilter * filter = [[GPUImageGrayscaleFilter alloc] init];
    [filter useNextFrameForImageCapture];
    return filter;
}

- (GPUImageFilter*)addFilter_HistogramGenerator{
    
    GPUImageHistogramGenerator * filter = [[GPUImageHistogramGenerator alloc] init];
    [filter useNextFrameForImageCapture];
    return filter;
}

- (GPUImageOutput*)addFilter_RGB{
    
    GPUImageRGBFilter * filter = [[GPUImageRGBFilter alloc] init];
    [filter setRed:0.8];
    [filter setGreen:0.3];
    [filter setBlue:0.5];
    [filter useNextFrameForImageCapture];
    return filter;
}

- (GPUImageOutput*)addFilter_Monochrome{
    
    GPUImageMonochromeFilter * filter = [[GPUImageMonochromeFilter alloc] init];
    [filter setColorRed:0.3 green:0.5 blue:0.8];
    [filter useNextFrameForImageCapture];
    return filter;
}

- (GPUImageOutput*)addFilter_SobelEdgeDetection{
    
    GPUImageSobelEdgeDetectionFilter * filter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
    [filter useNextFrameForImageCapture];
    return filter;
}

- (GPUImageOutput*)addFilter_XYDerivative{
    
    GPUImageXYDerivativeFilter * filter = [[GPUImageXYDerivativeFilter alloc] init];
    [filter useNextFrameForImageCapture];
    return filter;
}

- (GPUImageOutput*)addFilter_SmoothToon{
    
    GPUImageSmoothToonFilter * filter = [[GPUImageSmoothToonFilter alloc] init];
    [filter useNextFrameForImageCapture];
    return filter;
}

- (GPUImageOutput*)addFilter_ColorPacking{
    
    GPUImageColorPackingFilter * filter = [[GPUImageColorPackingFilter alloc] init];
    [filter useNextFrameForImageCapture];
    return filter;
}

@end

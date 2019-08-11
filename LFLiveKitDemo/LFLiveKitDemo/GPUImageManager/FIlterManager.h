//
//  FIlterManager.h
//  视频功能开发
//
//  Created by mac on 2019/7/23.
//  Copyright © 2019 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface FIlterManager : NSObject

- (GPUImageOutput*)addFilter_Sketch;//素描

- (GPUImageOutput*)addFilter_Beautify;//美颜

- (GPUImageOutput*)addFilter_Gamma;//伽马线

- (GPUImageOutput*)addFilter_ColorInvert;//反色

- (GPUImageOutput*)addFilter_Sepia;//褐色（怀旧）

- (GPUImageOutput*)addFilter_Grayscale;//灰度

- (GPUImageOutput*)addFilter_HistogramGenerator;//色彩直方图

- (GPUImageOutput*)addFilter_RGB;//RGB颜色

- (GPUImageOutput*)addFilter_Monochrome;//单色

- (GPUImageOutput*)addFilter_SobelEdgeDetection;//Sobel边缘检测算法(白边，黑内容，有点漫画的反色效果)

- (GPUImageOutput*)addFilter_XYDerivative;//XYDerivative边缘检测，画面以蓝色为主，绿色为边缘，带彩色

- (GPUImageOutput*)addFilter_SmoothToon;//漫画

- (GPUImageOutput*)addFilter_ColorPacking;//监控

@end

NS_ASSUME_NONNULL_END

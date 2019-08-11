//
//  ViewController.m
//  LFLiveKitDemo
//
//  Created by mac on 2019/8/8.
//  Copyright © 2019 cc. All rights reserved.
//

#import "ViewController.h"
#import "LFLiveKit.h"
#import "Masonry.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "filterView.h"
#import "FIlterManager.h"
#import <AVKit/AVKit.h>

#define rtmpUrl @"rtmp://localhost:1935/rtmplive/room"
#define localVideoPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/demo.mp4"]
// 屏幕尺寸
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<LFLiveSessionDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) LFLiveSession *session;

@property (nonatomic,strong) UIButton *circleBtn;
@property (nonatomic,strong) UIButton *cameraPositionBtn;
@property (nonatomic,strong) UIButton *flashBtn;
@property (nonatomic,strong) UILabel *liveStateLabel;
@property (nonatomic, strong) UIImageView* focusImage;

@property (nonatomic, strong) filterView *filterConfigView;
@property (nonatomic, strong) FIlterManager *filterManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSFileManager defaultManager] removeItemAtPath:localVideoPath error:nil];
    
    [self.view addSubview:self.circleBtn];
    [self.view addSubview:self.cameraPositionBtn];
    [self.view addSubview:self.flashBtn];
    [self.view addSubview:self.liveStateLabel];
    [self.view addSubview:self.focusImage];
    [self.view addSubview:self.filterConfigView];
    
    self.focusImage.hidden = YES;
    self.session.running = YES;//开始采集
    
    [self callBack];
}

-(void)viewWillLayoutSubviews{
    [self.circleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@(70));
        make.bottom.equalTo(self.view).offset(-40);
    }];
    
    [self.cameraPositionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-22);
        make.width.height.equalTo(@(44));
        make.centerY.equalTo(self->_circleBtn);
    }];
    
    [self.flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(22);
        make.top.equalTo(self.view).offset(24);
        make.width.height.equalTo(@(32));
    }];
    
    [self.liveStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self.view);
        make.height.equalTo(@(40));
        make.top.equalTo(@(60));
    }];
}

- (void)callBack{
    
    //是否推流
    [[self.circleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if (x.isSelected) {
            [self stopLive];
        }else{
            [self startLive];
        }
        [x setBackgroundImage:[UIImage imageNamed: x.isSelected?@"ic_shutter":@"ic_button"] forState:UIControlStateNormal];
        x.selected = !x.selected;
    }];
    
    //前后置切换
    [[self.cameraPositionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
        self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    }];
    
    //闪光灯切换
    [[self.flashBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.session.torch =!self.session.torch;//闪光灯开关
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    tapGesture.delegate = self;
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        
        //前置不可点
        if (self.session.captureDevicePosition == AVCaptureDevicePositionFront) return;
        
        CGPoint point = [x locationInView:self.view];
        self.focusImage.bounds = CGRectMake(0, 0, 70, 70);
        self.focusImage.center = point;
        self.focusImage.hidden = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.focusImage.bounds = CGRectMake(0, 0, 50, 50);
        } completion:^(BOOL finished) {
            self.focusImage.hidden = YES;
            self.session.focusPoint = point;
        }];
    }];
    [self.view addGestureRecognizer:tapGesture];
    
    UIPinchGestureRecognizer *doubleTapGesture = [[UIPinchGestureRecognizer alloc] init];
    doubleTapGesture.delaysTouchesBegan = YES;
    [[doubleTapGesture rac_gestureSignal] subscribeNext:^(UIPinchGestureRecognizer* x) {
        CGFloat scale = x.scale;
        x.scale = MAX(1.0, scale);
        
        if (scale < 1.0f || scale > 3.0)
            return;
        NSLog(@"捏合%f",scale);
        self.session.zoomScale = scale;
        
    }];
    [self.view addGestureRecognizer:doubleTapGesture];
    
    //切换滤镜
    self.filterConfigView.selectBlock = ^(NSInteger index) {
        self.session.beautyFace = NO;//取消自带美颜
        self.session.currentFilter =  [self addFilterWithIndex:index];
    };
}

- (id)addFilterWithIndex:(NSInteger)index{
    id filter;
    if (index == 1){filter = [self.filterManager addFilter_Sketch];}
    if (index == 2){filter = [self.filterManager addFilter_Beautify];}
    if (index == 3){filter = [self.filterManager addFilter_Gamma];}
    if (index == 4){filter = [self.filterManager addFilter_ColorInvert];}
    if (index == 5){filter = [self.filterManager addFilter_Sepia];}
    if (index == 6){filter = [self.filterManager addFilter_Grayscale];}
    if (index == 7){filter = [self.filterManager addFilter_HistogramGenerator];}
    if (index == 8){filter = [self.filterManager addFilter_RGB];}
    if (index == 9){filter = [self.filterManager addFilter_Monochrome];}
    if (index == 10){filter = [self.filterManager addFilter_SobelEdgeDetection];}
    if (index == 11){filter = [self.filterManager addFilter_XYDerivative];}
    if (index == 12){filter = [self.filterManager addFilter_SmoothToon];}
    if (index == 13){filter = [self.filterManager addFilter_ColorPacking];}
    
    return filter;
}

//开始直播
- (void)startLive {
    
    LFLiveStreamInfo *streamInfo = [LFLiveStreamInfo new];
    streamInfo.url = rtmpUrl;
    [self.session startLive:streamInfo];
}

//结束直播
- (void)stopLive {
    [self.session stopLive];
    
    //播放本地视频
    dispatch_async(dispatch_get_main_queue(), ^{
        AVPlayerViewController* vc = [[AVPlayerViewController alloc] init];
        vc.player = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:localVideoPath]];
        [self presentViewController:vc animated:YES completion:nil];
    });
}

#pragma mark -------------- UIGestureRecognizerDelegate --------------
//防止手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"GPUImageView"]) {
        return YES;
    }
    return  NO;
}

#pragma mark -------------- LFLiveSessionDelegate --------------
//推流状态改变
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange: (LFLiveState)state{
    
    NSString* stateStr;
    switch (state) {
        case LFLiveReady:
            stateStr = @"准备";
            break;
            
        case LFLivePending:
            stateStr = @"连接中";
            break;
            
        case LFLiveStart:
            stateStr = @"已连接";
            break;
            
        case LFLiveStop:
            stateStr = @"已断开";
            break;
            
        case LFLiveError:
            stateStr = @"连接出错";
            break;
            
        case LFLiveRefresh:
            stateStr = @"正在刷新";
            break;
            
        default:
            break;
    }
    
    self.liveStateLabel.text = stateStr;
}

//推流信息
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
}

//推流错误信息
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    switch (errorCode) {
        case LFLiveSocketError_PreView:
             NSLog(@"预览失败");
            break;
        case LFLiveSocketError_GetStreamInfo:
            NSLog(@"获取流媒体信息失败");
            break;
        case LFLiveSocketError_ConnectSocket:
            NSLog(@"连接socket失败");
            break;
        case LFLiveSocketError_Verification:
            NSLog(@"验证服务器失败");
            break;
        case LFLiveSocketError_ReConnectTimeOut:
            NSLog(@"重新连接服务器超时");
            break;
        default:
            break;
    }
}

- (LFLiveSession*)session {
    if (!_session) {
        //默认音视频配置
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
        _session.reconnectCount = 5;//重连次数
        _session.saveLocalVideo = YES;
        _session.saveLocalVideoPath = [NSURL fileURLWithPath:localVideoPath];
        _session.preView = self.view;
        _session.delegate = self;
    }
    return _session;
}

-(UIButton *)circleBtn{
    if (!_circleBtn) {
        _circleBtn = [[UIButton alloc] init];
        [_circleBtn setBackgroundImage:[UIImage imageNamed:@"ic_shutter"] forState:UIControlStateNormal];
    }
    return _circleBtn;
}
-(UIButton *)cameraPositionBtn{
    if (!_cameraPositionBtn) {
        _cameraPositionBtn = [[UIButton alloc] init];
        [_cameraPositionBtn setBackgroundImage:[UIImage imageNamed:@"ic_change"] forState:UIControlStateNormal];
    }
    return _cameraPositionBtn;
}

-(UIButton *)flashBtn{
    if (!_flashBtn) {
        _flashBtn = [[UIButton alloc] init];
        [_flashBtn setBackgroundImage:[UIImage imageNamed:@"ic_iight-close"] forState:UIControlStateNormal];
    }
    return _flashBtn;
}

-(UIImageView *)focusImage{
    if (!_focusImage) {
        _focusImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"对焦"]];
    }
    return _focusImage;
}


-(UILabel *)liveStateLabel{
    if (!_liveStateLabel) {
        _liveStateLabel = [[UILabel alloc] init];
        _liveStateLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
        _liveStateLabel.textColor = [UIColor blackColor];
        _liveStateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _liveStateLabel;
}

-(filterView *)filterConfigView{
    if (!_filterConfigView) {
        _filterConfigView = [[filterView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, 0, 100, 300)];
    }
    return _filterConfigView;
}

-(FIlterManager *)filterManager{
    if (!_filterManager) {
        _filterManager = [[FIlterManager alloc] init];
    }
    return _filterManager;
}

@end

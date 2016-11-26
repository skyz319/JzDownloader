//
//  ViewController.m
//  JzDownloaderDemo
//
//  Created by 张恋 on 2016/11/24.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "ViewController.h"
#import "JzDownloader.h"

@interface ViewController () <JzDownloaderDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showImage:) name: QRImageKey object: nil];
    
    /**
        方式1
     */
//    [[JzDownloader sharedInstance] loadFileWithUrl: @"http://7vihpo.com1.z0.glb.clouddn.com/112aa.jpg" andKey: QRImageKey];
    
    /**
     方式1
     */
    JzDownloader *downloader = [[JzDownloader alloc] init];
    downloader.delegate = self;
    [downloader loadFileWithUrl: @"http://7vihpo.com1.z0.glb.clouddn.com/112aa.jpg" andKey: QRImageKey];
}

- (void)showImage:(NSNotification *)noti {
    
    NSLog( @"%@", noti.object);
    
    self.imageView.image = [UIImage imageWithContentsOfFile: noti.object];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - JzDownloader Delegate
- (void)downloadSuccessWithFilePath:(NSString *)filePath andKey:(NSString *)fileKey {
    
    self.imageView.image = [UIImage imageWithContentsOfFile: filePath];
}


@end

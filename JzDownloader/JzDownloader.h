//
//  JzDownloader.h
//  JzDownloaderDemo
//
//  Created by 张恋 on 2016/11/24.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const QRImageKey       = @"QRImage";
static NSString *const ConfigFileKey   = @"ConfigFile";

@protocol JzDownloader;

@interface JzDownloader : NSObject

@property (nonatomic, weak) id<JzDownloader> delegate;

+ (instancetype)sharedInstance;


/**
 Load File with URL and File's Key.

 @param urlString URL
 @param fileKey key for File's save name
 */
- (void)loadFileWithUrl:(NSString *)urlString andKey:(NSString *)fileKey;

@end

@protocol JzDownloader <NSObject>

@optional
- (void)downloadSuccessWithFilePath:(NSString *)filePath andKey:(NSString *)fileKey;

@end

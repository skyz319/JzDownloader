//
//  JzDownloader.m
//  JzDownloaderDemo
//
//  Created by 张恋 on 2016/11/24.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JzDownloader.h"

#define kDLUserDefaults [NSUserDefaults standardUserDefaults]
#define kDLPostNotification(name, obj) [[NSNotificationCenter defaultCenter] postNotificationName: name object: obj]

#pragma mark - NSString 扩展
//  为防止重名 使用JzDownloaderExtension为扩展名
@interface NSString (JzDownloaderExtension)

+ (NSString *)JzDownloaderGetFilePathWithFileName:(NSString *)fileName;

+ (BOOL)JzDownloaderIsFileExistWithFilePath:(NSString *)filePath;
@end

@implementation NSString (JzDownloaderExtension)

+ (NSString *)JzDownloaderGetFilePathWithFileName:(NSString *)fileName {
    if (fileName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent: fileName];
        
        return filePath;
    }
    
    return nil;
}

+ (BOOL)JzDownloaderIsFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

@end

#pragma mark - JzDownloader

@implementation JzDownloader

+ (instancetype)sharedInstance {
    
    static JzDownloader *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JzDownloader new];
    });
    
    return instance;
}

- (void)loadFileWithUrl:(NSString *)urlString andKey:(NSString *)fileKey {
    
    //  取对应 Key 中的存储
    NSString *filePath = [NSString JzDownloaderGetFilePathWithFileName: [kDLUserDefaults valueForKey: fileKey]];
    
    //  判断文件是否存在
    BOOL isExist = [NSString JzDownloaderIsFileExistWithFilePath: filePath];
    
    if (isExist) {
        
        //  文件存在
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector: @selector(downloadSuccessWithFilePath:andKey:)]) {
                //  使用代理传递
                [self.delegate downloadSuccessWithFilePath: filePath andKey: fileKey];
            } else {
                //  将路径以消息的形式发送出去
                kDLPostNotification(fileKey, filePath);
            }
            
        });
    } else {
        //  文件不存在 需下载文件
        
    }
    
}

- (void)downladFileWithUrl:(NSString *)urlString andKey:(NSString *)fileKey {
    
    //  从 URL 中取文件名
    NSArray *stringArray = [urlString componentsSeparatedByString: @"/"];
    NSString *fileName = stringArray.lastObject;
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak __typeof(self) weakSelf = self;
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest: request
                                                            completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                
                                                                //  请求出错
                                                                if (error) {
                                                                    
                                                                    NSLog(@"File Download Error: %@", error.localizedDescription);
                                                                    return ;
                                                                }
                                                                
                                                                //默认存储到临时文件夹 tmp 中，需要剪切文件到 cache
                                                                NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
                                                                
                                                                
                                                                NSError *saveError = nil;
                                                                
                                                                //  存储文件
                                                                [[NSFileManager defaultManager]
                                                                 moveItemAtURL: location
                                                                 toURL: [NSURL URLWithString: filePath]
                                                                 error: &saveError];
                                                                
                                                                if (saveError) {
                                                                    //  存储失败
                                                                    NSLog( @"文件存储失败: %@", saveError.localizedDescription);
                                                                } else {
                                                                    //  保存成功并删除老文件
                                                                    [weakSelf deleteOldImageWithKey: fileKey];
                                                                    //  保存新图片
                                                                    [kDLUserDefaults setValue: fileName forKey: fileKey];
                                                                    [kDLUserDefaults synchronize];
                                                                    
                                                                    //  下载并保存成功 通知调用方
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        
                                                                        if ([self.delegate respondsToSelector: @selector(downloadSuccessWithFilePath:andKey:)]) {
                                                                            //  使用代理传递
                                                                            [self.delegate downloadSuccessWithFilePath:  filePath andKey: fileKey];
                                                                        } else {
                                                                            //  将路径以消息的形式发送出去
                                                                            kDLPostNotification(fileKey, filePath);
                                                                        }
                                                                    });
                                                                }
                                                                
                                                            }];
    
    [downloadTask resume];
    
}

- (void)deleteOldImageWithKey:(NSString *)fileKey
{
    NSString *imageName = [kDLUserDefaults valueForKey: fileKey];
    if (imageName) {
        
        NSString *filePath = [NSString JzDownloaderGetFilePathWithFileName: imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

@end

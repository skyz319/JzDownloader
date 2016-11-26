# **JzDownloader**

## **简介**
文件下载器，可下载图片、文件等

## **使用方法**
在 `Podfile` 中进行如下导入：
    
     pod 'JzDownloader', '~> 0.0.1'
     
然后使用 `cocoaPods` 进行安装：

如果尚未安装 CocoaPods, 运行以下命令进行安装:

    gem install cocoapods
 
安装成功后就可以安装依赖了：

建议使用如下方式：

     # 禁止升级CocoaPods的spec仓库，否则会卡在 Analyzing dependencies ，非常慢 
     pod update --verbose --no-repo-update

如果提示找不到库，则可去掉 --no-repo-update

    pod update

##调用##
支持通知及代码调用。
Key 定义在JzDownloader.h中，也可以直接传入其它自定义的 Key 或是字符串。

使用方式1：

    1. 使用消息通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(显示图片或操作文件的方法) name:  object: nil];
    
    2. 调用
    [[JzDownloader sharedInstance] loadFileWithUrl: @"图片/文件地址" andKey: @"文件存储的 Key"];

使用方式2：

    1.使用代理方式
    JzDownloader *downloader = [[JzDownloader alloc] init];
    downloader.delegate = self;
    [downloader loadFileWithUrl: @"图片/文件地址"" andKey: @"文件存储的 Key"];
    
    2.代理方法中操作文件
    - (void)downloadSuccessWithFilePath:(NSString *)filePath andKey:(NSString *)fileKey {
    
    //  TODO
    }


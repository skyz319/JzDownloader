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






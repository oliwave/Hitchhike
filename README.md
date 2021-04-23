# Hitchhike 

## 事前準備

所有 Google 的服務都會經過手機內的 **Google Play Services** 來傳輸資料。我們可以從下圖得知應用程式是只要使用到 Google 的服務都會透過 **[IPC](https://en.wikipedia.org/wiki/Inter-process_communication)** 與 Google Play Services 做溝通的（認證、取得資訊...）

![](https://i.imgur.com/3yZCj4y.png)

因此記得在 **Android studio** 中安裝 **Google Play services** 不然是無法取得地圖的任何資訊喔！！！

    
![](https://i.imgur.com/shqRqoM.png)

### Android 環境設置

設定 `google map` 的 **`API key`** 在 `AndroidManifest.xml` 檔案中

在該路徑底下 android/app/src/main/AndroidManifest.xml

```xml=
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
```

### iOS 環境設置

#### Step 1
在 cmd 建立 Flutter 專案時把預設 iOS 開發語言設定成 swift
> flutter create -i swift <專案名字>

#### Step 2
設定 `google map` 的 **`API key`** 在 `Appdelegate.swift` 檔案中

在該路徑底下 ios/Runner/AppDelegate.swift

```swift=
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR KEY HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```
#### Step 3

確保 iOS 裝置可以支援地圖渲染還需要加入以下設定在該檔案中

在該路徑底下ios/Runner/Info.plist

```plist=
<key>io.flutter.embedded_views_preview</key>
<true/>
```
### [套件自定義修改](https://hackmd.io/z0H-ESBKR1OU3cA4D1Ta8A)

## 架構圖

- 前端狀態管理架構圖
  - ![](https://i.imgur.com/KfvEqUO.png)



- 系統架構圖
- ![](https://i.imgur.com/T0E9LH2.png)

## 介面

<img src="https://i.imgur.com/zEM5uQb.png" alt="drawing" width="250"/> <img src="https://i.imgur.com/Dl7MikM.png" alt="drawing" width="250"/> <img src="https://i.imgur.com/bR98OOa.png" alt="drawing" width="250"/>
<img src="https://i.imgur.com/lxGAZZu.png" alt="drawing" width="250"/>
<img src="https://i.imgur.com/1RtXFlR.png" alt="drawing" width="250"/>
<img src="https://i.imgur.com/9kxr3en.png" alt="drawing" width="250"/>
<img src="https://i.imgur.com/9j7Z1QR.png" alt="drawing" width="250"/>
<img src="https://i.imgur.com/DN1WDeL.png" alt="drawing" width="250"/>
<img src="https://i.imgur.com/Bw7NhKQ.png" alt="drawing" width="250"/>
<img src="https://i.imgur.com/lWvqIzS.png" alt="drawing" width="250"/>
<img src="https://i.imgur.com/gbpnbix.png" alt="drawing" width="250"/>
<img src="https://i.imgur.com/72yiTaH.png" alt="drawing" width="250"/>
<img src="https://i.imgur.com/FDvF6M6.png" alt="drawing" width="250"/>
<img src="https://i.imgur.com/nKhD1sq.png" alt="drawing" width="250"/>





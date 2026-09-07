# TnkPpiHyb — 하이브리드 오퍼월 SDK (iOS)

TnkFactory 하이브리드 오퍼월 SDK 의 **배포 저장소**입니다.
컴파일된 바이너리(`TnkPpiHyb.xcframework`)와 패키지 매니페스트만 들어 있습니다.

📖 **연동 가이드 전문: https://tnkfactory.gitbook.io/sdk-docs/ios**

- 최소 지원: **iOS 14.0** (ATT 사용) · Swift 5.9
- 샘플 코드: [tnkad/ios-ppi-hyb-sample](https://github.com/tnkad/ios-ppi-hyb-sample)
- 릴리스 노트: https://tnkfactory.gitbook.io/sdk-docs/ios/changelog

---

## 설치

### Swift Package Manager

Xcode → **File → Add Package Dependencies** 에 아래 URL 을 입력합니다.

```
https://github.com/tnkad/ios-ppi-hyb-sdk
```

### CocoaPods

```ruby
platform :ios, '14.0'

target 'YourApp' do
  use_frameworks!
  pod 'TnkPpiHyb'
end
```

---

## 최소 코드

```swift
import TnkPpiHyb

let sdk = TnkPpiHybSdk.shared
sdk.configure(appId: "발급받은-앱-아이디")
sdk.setUserName("개발사-사용자-식별값")
sdk.applicationStarted()

sdk.openOfferwall(from: self)
```

`Info.plist` 설정(ATT 문구 등), ATT 동의 요청 시점, 보상 수신, 딥링크, 서버 콜백 규격은
**[연동 가이드](https://tnkfactory.gitbook.io/sdk-docs/ios)** 를 참고하세요.

---

문의: tech@tnkfactory.com

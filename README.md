# TnkPpiHyb — 하이브리드 오퍼월 SDK 연동 가이드 (iOS)

TnkFactory 하이브리드 오퍼월 SDK 입니다. 네이티브는 기기 컨텍스트 수집과 WKWebView 호스팅,
JS 브릿지를 담당하고 **오퍼월 화면과 보상 로직은 WebView 안의 웹(FE)이 처리**합니다.
그래서 오퍼월 UI 개선이나 매체별 커스터마이징은 **앱 업데이트 없이** 반영됩니다.

- 최소 지원: **iOS 14.0** (ATT 사용)
- Swift 5.9 / xcframework 바이너리 배포

> 이 문서는 매체사 배포용 진입점입니다. 배포 저장소에 그대로 복사해 사용합니다.

---

## 1. 설치

### Swift Package Manager

Xcode → File → Add Package Dependencies 에 아래 URL 을 입력하고 버전을 선택합니다.

```
https://github.com/tnkad/ios-ppi-hyb-sdk
```

`Package.swift` 를 직접 쓰는 경우:

```swift
dependencies: [
    .package(url: "https://github.com/tnkad/ios-ppi-hyb-sdk", from: "0.1.0")
]
```

### CocoaPods

```ruby
pod 'TnkPpiHyb', '~> 0.1.0'
```

```sh
pod install
```

CocoaPods 워크스페이스를 쓰면서 SPM 으로 이 SDK 를 추가해도 됩니다. 둘 중 편한 쪽을 고르세요.

---

## 2. Info.plist 설정

| 키 | 필수 | 용도 |
| --- | :-: | --- |
| `NSUserTrackingUsageDescription` | ✅ | ATT 동의 팝업 문구. IDFA 수집에 필요 |
| `NSPhotoLibraryUsageDescription` | ✅ | 광고 참여 시 이미지 첨부 |
| `NSCameraUsageDescription` | ✅ | 광고 참여 시 사진 촬영 |
| `NSMicrophoneUsageDescription` | ○ | 동영상 촬영형 광고 |
| `tnkad_app_id` | ○ | 앱 ID. 코드로 `configure` 하면 생략 가능 |

문구 예시 — `NSUserTrackingUsageDescription`:
> 맞춤형 광고 제공을 위해 기기 광고 식별자(IDFA)를 사용합니다.

**ATT 동의를 받지 않으면 참여 가능한 광고가 크게 줄어듭니다.**

---

## 3. 초기화

앱 시작 시 1회 호출합니다.

```swift
import TnkPpiHyb

let sdk = TnkPpiHybSdk.shared
sdk.configure(appId: "발급받은-앱-아이디")   // Info.plist 에 tnkad_app_id 가 있으면 생략 가능
sdk.setUserName("매체측-사용자-식별값")       // 보상 지급 대상을 식별하는 값
sdk.applicationStarted()
```

`setUserName` 에 넣는 값이 **보상 지급의 기준**입니다. 매체사 회원 ID 등 사용자를 고유하게
식별할 수 있는 값을 넣으세요. (샘플 앱은 편의상 IDFA 를 사용합니다.)

### ATT 동의 요청

**앱이 활성 상태일 때만** 팝업이 뜹니다. `sceneDidBecomeActive` 에서 1회 호출하세요.

```swift
func sceneDidBecomeActive(_ scene: UIScene) {
    guard !didRequestATT else { return }
    didRequestATT = true
    TnkPpiHybSdk.shared.requestTrackingAuthorization { granted in
        // 동의 후 IDFA 실값이 확정된다
    }
}
```

> `willConnectTo`(활성 이전)에서 부르면 팝업이 뜨지 않고 상태가 `.notDetermined` 로 남습니다.

---

## 4. 오퍼월 띄우기

### 풀스크린 (권장)

```swift
TnkPpiHybSdk.shared.openOfferwall(from: self)
```

매체 파라미터를 붙일 수 있습니다.

```swift
TnkPpiHybSdk.shared.openOfferwall(from: self, extraParams: ["hideHeader": "1"])
```

| 파라미터 | 효과 |
| --- | --- |
| `hideHeader=1` | 오퍼월 상단 헤더(X · 타이틀) 숨김. 매체가 자체 헤더를 쓸 때 |

### 화면 안에 삽입

`TnkOfferwallView` 는 `UIView` 라 원하는 위치에 넣을 수 있습니다.

```swift
let offerwall = TnkOfferwallView(frame: .zero)
offerwall.onCloseRequested = { [weak self] in /* 탭 전환 등 */ }
// 웹이 상태바 색을 요청하면 호스트가 반영한다
offerwall.onStatusBarStyleChanged = { [weak self] _ in
    self?.setNeedsStatusBarAppearanceUpdate()
}
view.addSubview(offerwall)   // 오토레이아웃으로 배치
offerwall.loadOfferwall(TnkPpiHybSdk.shared.buildOfferwallURL())

// 화면이 사라질 때
offerwall.cleanup()
```

> ⚠️ **삽입해도 표시되는 것은 오퍼월 전체 화면입니다.**
> 특정 카테고리만, 또는 광고 상세만 노출하는 **플레이스먼트 뷰는 제공하지 않습니다.**
> 레거시 보상형 SDK(`TnkRwdSdk2`)의 `AdPlacementView` 를 쓰고 계시다면 문의해 주세요.

---

## 5. 보상 지급 수신

FE 가 서버 지급에 성공하면 호출됩니다. **항상 메인 스레드**입니다.

```swift
TnkPpiHybSdk.shared.setRewardListener { reward in
    print(reward.appId, reward.payPoint, reward.pointUnit ?? "")
    // 자체 포인트 잔액 갱신 / 토스트 등
}
```

| 필드 | 의미 |
| --- | --- |
| `appId` | 광고(앱) ID |
| `appName` | 광고명 |
| `payPoint` | 지급 포인트 |
| `pointUnit` | 포인트 단위 (예: "캐시") |
| `payType` | 지급 유형 |
| `actionId` | 참여 액션 ID |

브릿지 이벤트 원본이 필요하면:

```swift
TnkPpiHybSdk.shared.setEventListener { type, rawJson in }
```

---

## 6. 딥링크 (`tnkscheme://`)

푸시 알림 등에서 오퍼월의 특정 지점으로 보낼 때 사용합니다.

`Info.plist` 에 스킴을 등록하고,

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key><string>com.example.app.tnk</string>
    <key>CFBundleURLSchemes</key><array><string>tnkscheme</string></array>
  </dict>
</array>
```

진입점에서 SDK 에 넘깁니다.

```swift
// SceneDelegate
func scene(_ scene: UIScene, openURLContexts contexts: Set<UIOpenURLContext>) {
    contexts.forEach { TnkPpiHybSdk.shared.handleScheme($0.url) }
}

// 콜드스타트(딥링크로 앱이 처음 뜨는 경우)
func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
           options connectionOptions: UIScene.ConnectionOptions) {
    // ... 초기화 및 화면 구성 후
    connectionOptions.urlContexts.forEach { TnkPpiHybSdk.shared.handleScheme($0.url) }
}
```

- 오퍼월이 떠 있으면 바로 전달하고, 없으면 오퍼월을 열어 전달합니다.
- 앱 부팅 중 도착한 딥링크는 큐에 담았다가 웹이 준비되면 한 번에 전달합니다.
- `tnkscheme` 이 아니면 `false` 를 돌려주므로, 매체 자체 딥링크와 함께 써도 됩니다.

---

## 7. 개인정보 · 사용자 속성 (선택)

```swift
let sdk = TnkPpiHybSdk.shared
sdk.setAgreePrivacy(true)   // 매체가 이미 동의를 받았다면 웹의 동의 게이트를 건너뛴다
sdk.setUserAge(25)
sdk.setUserGender(TnkCode.MALE)   // MALE / FEMALE
sdk.setCOPPA(0)
sdk.setGDPR(0)
```

---

## 8. 디버깅

```swift
TnkPpiHybSdk.shared.enableLogging(true)   // [TnkPpiHyb] 접두어로 콘솔 출력
```

| 증상 | 확인할 것 |
| --- | --- |
| 오퍼월이 비어 있음 | `configure` 의 앱 ID, `setUserName` 설정 여부 |
| 참여 가능한 광고가 적음 | ATT 동의 여부 (`requestTrackingAuthorization`) |
| 이미지 첨부 실패 | 사진/카메라 권한 문구가 `Info.plist` 에 있는지 |
| 딥링크 무반응 | `CFBundleURLTypes` 등록, `handleScheme` 호출 여부 |

---

## 9. 지원 범위

| 기능 | 상태 |
| --- | :-: |
| 전체 오퍼월 (풀스크린 / 뷰 삽입) | ✅ |
| 보상 지급 콜백 | ✅ |
| `tnkscheme` 딥링크 | ✅ |
| 헤더 숨김 등 매체 파라미터 | ✅ |
| 플레이스먼트 뷰 (특정 광고만 노출) | ❌ 제공하지 않음 |

문의: tech@tnkfactory.com

// swift-tools-version:5.9
//
//  Package.swift — TnkPpiHyb iOS SDK (매체사 배포용)
//
//  archive.sh 가 생성한 파일이다. 직접 수정하지 말 것.
//  버전 1.0.0 · 생성 대상 zip: TnkPpiHyb.xcframework.zip
//
import PackageDescription

let package = Package(
    name: "TnkPpiHyb",
    platforms: [
        // ATT(App Tracking Transparency) 사용으로 iOS 14 최소.
        .iOS(.v14)
    ],
    products: [
        .library(name: "TnkPpiHyb", targets: ["TnkPpiHyb"])
    ],
    targets: [
        .binaryTarget(
            name: "TnkPpiHyb",
            url: "https://github.com/tnkad/ios-ppi-hyb-sdk/releases/download/v1.0.0/TnkPpiHyb.xcframework.zip",
            checksum: "a10bd662ba27291aac18ba8020143dc301316f8ba6eebb052a2cccf1863821e9"
        )
    ]
)

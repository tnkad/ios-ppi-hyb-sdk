// swift-tools-version:5.9
//
//  Package.swift — TnkPpiHyb iOS SDK (매체사 배포용)
//
//  archive.sh 가 생성한 파일이다. 직접 수정하지 말 것.
//  버전 1.0.7 · 생성 대상 zip: TnkPpiHyb.xcframework.zip
//
import PackageDescription

let package = Package(
    name: "TnkPpiHyb",
    platforms: [
        // 최소 지원 iOS 15.0 (Xcode 27 deployment target 하한). ATT 는 iOS 14+ 라 충족.
        .iOS(.v15)
    ],
    products: [
        .library(name: "TnkPpiHyb", targets: ["TnkPpiHyb"])
    ],
    targets: [
        .binaryTarget(
            name: "TnkPpiHyb",
            url: "https://github.com/tnkad/ios-ppi-hyb-sdk/releases/download/v1.0.7/TnkPpiHyb.xcframework.zip",
            checksum: "c8c7a95c7c90ddf4c7ce8f1df6b2512527d378fdf7c795df6ae74e35376f3245"
        )
    ]
)

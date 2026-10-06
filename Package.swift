// swift-tools-version:5.9
//
//  Package.swift — TnkPpiHyb iOS SDK (매체사 배포용)
//
//  archive.sh 가 생성한 파일이다. 직접 수정하지 말 것.
//  버전 1.0.3 · 생성 대상 zip: TnkPpiHyb.xcframework.zip
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
            url: "https://github.com/tnkad/ios-ppi-hyb-sdk/releases/download/v1.0.3/TnkPpiHyb.xcframework.zip",
            checksum: "ef81008bc650dd48fe007263469e89fa4c78e0a840d55600983d4dc9bf7b1eb6"
        )
    ]
)

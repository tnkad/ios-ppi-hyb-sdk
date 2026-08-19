// swift-tools-version:5.9
//
//  Package.swift — TnkPpiHyb iOS SDK (매체사 배포용)
//
//  archive.sh 가 생성한 파일이다. 직접 수정하지 말 것.
//  버전 0.1.0 · 생성 대상 zip: TnkPpiHyb.xcframework.zip
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
            url: "https://github.com/tnkad/ios-ppi-hyb-sdk/releases/download/v0.1.0/TnkPpiHyb.xcframework.zip",
            checksum: "4846f8ed67bcea25735430360524aa257292dc1f57a6e7e92869fa414a1c5b1c"
        )
    ]
)

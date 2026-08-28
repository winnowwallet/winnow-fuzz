// swift-tools-version: 6.0
import Foundation
import PackageDescription

// The fuzzer lives beside the library, not inside it: it consumes
// btc-swift's public products only, so it exercises exactly the parsing
// surface an attacker reaches. By default it tracks btc-swift `main`;
// btc-swift's security workflow overrides the dependency with WINNOW_PATH
// to fuzz the commit under test rather than whatever `main` was when this
// ran; the explicit name pins the identity regardless of checkout dir.
let winnow: Package.Dependency
if let path = ProcessInfo.processInfo.environment["WINNOW_PATH"] {
    winnow = .package(name: "btc-swift", path: path)
} else {
    winnow = .package(url: "https://github.com/winnowwallet/btc-swift", branch: "main")
}

let package = Package(
    name: "winnow-fuzz",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "WinnowFuzz", targets: ["WinnowFuzz"]),
    ],
    dependencies: [winnow],
    targets: [
        .executableTarget(
            name: "WinnowFuzz",
            dependencies: [
                .product(name: "BitcoinCore", package: "btc-swift"),
                .product(name: "BitcoinP2P", package: "btc-swift"),
                .product(name: "WalletCore", package: "btc-swift"),
            ]
        ),
    ]
)

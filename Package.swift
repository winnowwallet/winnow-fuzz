// swift-tools-version: 6.0
import Foundation
import PackageDescription

// The fuzzer lives beside the wallet, not inside it: it consumes winnow's
// public library products only, so it exercises exactly the parsing surface
// an attacker reaches. By default it tracks winnow's `main`; winnow's own
// security workflow overrides the dependency with WINNOW_PATH to fuzz the
// commit under test rather than whatever `main` was when this ran.
let winnow: Package.Dependency
if let path = ProcessInfo.processInfo.environment["WINNOW_PATH"] {
    winnow = .package(name: "winnow", path: path)
} else {
    winnow = .package(url: "https://github.com/winnowwallet/winnow.git", branch: "main")
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
                .product(name: "BitcoinCore", package: "winnow"),
                .product(name: "BitcoinP2P", package: "winnow"),
                .product(name: "WalletCore", package: "winnow"),
            ]
        ),
    ]
)

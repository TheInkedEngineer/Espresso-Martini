<p align="center">
<img src="logo-github.png" alt="Espresso Martini logo" width="400">
</p>

[![Twitter](https://img.shields.io/twitter/url/https/theinkedgineer.svg?label=TheInkedgineer&style=social)](https://twitter.com/inkedengineer)
![SwiftLang badge](https://img.shields.io/badge/language-Swift%205.7-orange.svg)

# Espresso Martini

`Espresso Martini` is a vapor-powered mock server. It allows you you to mock HTTP requests easily, so you worry about the things that matter, and not have to wait on APIs to be live.

The library is fully tested and documented.


# 1. Requirements and Compatibility

- Xcode 13+
- Swift 5.5+

# 2. Installation

## Swift Package Manager

#### Package.swift

Open your `Package.swift` file and add the following as your dependency. 

```swift
dependencies: [
  .package(url: "https://github.com/TheInkedEngineer/Espresso-Martini", from: "0.1.0")
]
```

Then add the following to your target's dependency:

```swift
targets: [
  .target(
    name: "MyTarget", 
    dependencies: [
      .product(name: "https://github.com/TheInkedEngineer/Espresso-Martini", package: "Espresso-Martini")
    ]
  )
]
```

#### Xcode

1. Open your app in Xcode
1. In the **Project Navigator**, click on the project
1. in the Project panel, click on the project
1. Go to the **Package Dependencies** tab
1. Click on the `+` button
1. Insert the `https://github.com/TheInkedEngineer/Espresso-Martini` url in the search bar and press **Enter**
1. Click on the `Add Package` button
1. Follow the Xcode's dialog to install the SDK

# 3. Documentation

The code for `Espresso-Martini` is fully documented. An DocC documentation will follow :).

# 4. How to use

- Download the project
- Open Package.swift
- Add your requests to `try? server.configure(using: ServerConfiguration(networkExchanges: Demo.networkExchanges))` inside of `main.swift`.
- Hit run


# 5. Contribution

**Working on your first Pull Request?** You can learn how from this *free* series [How to Contribute to an Open Source Project on GitHub](https://egghead.io/series/how-to-contribute-to-an-open-source-project-on-github)

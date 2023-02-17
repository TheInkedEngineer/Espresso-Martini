# Documentation

- [General Overview](#general-overview)
- [Main Concepts](#main-concepts)
  - [NetWork Exchange](#network-exchange)
  - [Request](#request)
  - [Response](#response)
    - [Type of response](#type-of-response) 
- [Espresso Martini for iOS & macOS](#espressomartini-for-ios--macos)
  - [Installation](#installation)
  - [Configuring the Mock Server](#configuring-the-mock-server)
  - [Interacting with the server](#interacting-with-the-server)
  - [Building a network exchange](#building-a-network-exchange)
- [EspressoMartini CLI](#espressomartini-cli)
  - [Installing the CLI](#installing-the-cli)
  - [Using the CLI](#using-the-cli)
  - [Setting up the network exchanges](#setting-up-the-network-exchanges)
  - [Configuring the CLI](#configuring-the-cli)

## General Overview

`EspressoMartini` is an `HTTP` mock server powered by [Vapor](https://github.com/vapor/vapor) that allows to simulate full `HTTP` responses including custom headers, status codes and various type of `Data`. It is built with the goal of integrating in in your iOS and macOS applications, but provides a CLI that allows running the server locally so you can have all the benefits regardless of what application or service you are trying to build.

## Main Concepts

### Network Exchange

A `NetworkExchange` object is the main entity in `EspressoMartini`. Each `NetworkExchange` represents a pair of [Request](#request) object and an array of desired [Response](#response) objects.

### Request

A `Request` is an object that represents the request that the server should intercept. It is made of a path and method. 

### Response

A `Response` is an object that represents the response that the server should return. It contains the status code the server should return, the headers you want returned, the [type of response](#type-of-response) data, and the delay the server should wait before returning the response.

#### Type of response

The server can return different types of responses. Specifically:

1. `empty`: Suitable for HTTP requests with no responses, like `HTTPResponseStatus.noContent`
1. `data(_ data: Data)`: The response is some `Data` you would like to return. In this case the `Content-Type` header should be set manually. 
1. `string(_ value: String)`: The response is a simple `String`.
1. `json(_ value: Encodable, encoder: JSONEncoder = JSONEncoder())`: A helper over `Data` where the server will encode the encodable object and return it as a JSON. This will automatically set (or override) the `Content-Type`.
1. `fileContent(pathToFile: String)`: Data to read off a file. The file path **SHOULD** contain the extension as it will be used to set the `Content-Type` header.

## EspressoMartini for iOS & macOS

### Installation

EspressoMartini support `SwiftPM`.

Open your `Package.swift` file and add the following as your dependency. 

```swift
dependencies: [
  .package(url: "https://github.com/TheInkedEngineer/Espresso-Martini", from: "1.0.0")
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

### Configuring the Mock Server

The mock server is configured using an object that conforms to `ServerConfigurationProvider`. `EspressoMartini` offers two built in objects:
- `MockServer.SimpleConfiguration(networkExchanges:)` which leverages the protocol's defaults and requires only the [NetworkExchange](#network-exchange) array to start your mock server.
- `MockServer.Configuration(networkExchanges:environment:hostname:port:delay:logLevel:)` which offers more flexibility to set your own properties.

Example:
```swift
let mockServer = MockServer()
try server.configure(
  using: MockServer.SimpleConfiguration(
    networkExchanges: [
      // Some network exchange objects.
      ]
    )
  )
```

### Interacting with the server

The mock server offers three more methods:
- `run()` which starts and runs the server of the provided hostname and port.
- `stop()` which stops the running instance of the server.
- `restart(configuration:)` which stops and runs the server again with the new configuration.


### Building a network exchange

The `NetworkExchange` is made of:

- A [Request](#request):
  - An `HTTPMethod`
  - A `Path`; An array of `Strings` where each string represents a path component.
    - Include `*`  in any position and the value of that field will be discarded. This is useful when the path includes an `ID`. `/api/*/users` will be matched by `/api/v1/users`, `/api/v2/users` and anything similar.
    - Include `**` and any string at this position or later positions will be matched in the request. `/api/**` will be matched by `/api/v1/users`, `/api/users/notes` and anything that starts with `/api`.

- A [Response](#response):
  - A `HTTPResponseStatus`
  - A list of headers to include in the response.
  - The delay before the answer is returned. If this value is set it will override the global delay value. If this value is `nil` the answer will be returned after the global delay.

> A network exchange can have more than one response. This is handy to simulate scenarios like `polling` and `error+retry+recover`. When a network exchange has more than 1 answer, the mock server will return the `min(nth response, array.count - 1)` where `n` is the number of request to that same path.

## EspressoMartini CLI

You do not need an iOS or macOS application to benefit from `EspressoMartini`. 

### Installing the CLI
1. Clone the repo `git clone git@github.com:TheInkedEngineer/Espresso-Martini.git`
1. `cd Espresso-Martini`
1. `make` -- you might need to run it with `sudo` privileges.

### Configuring the CLI

The server is configured using a `configuration.json` file. This file can have another name, you can point to it using `--configuration <file>` option.
 The server configuration is optional. If not provided all default values will be used. However, if you opt to include some configuration, `hostname` and `port` become mandatory. Everything else remains optional.

Example:
```json
{
  "hostname": "127.0.0.1",
  "port": 3000,
  "delay": 1,
  "log_level": "CRITICAL"
}
```

- LogLevel can have the following values:
  - "TRACE"
  - "DEBUG"
  - "INFO"
  - "NOTICE"
  - "WARNING"
  - "ERROR"
  - "CRITICAL"

### Setting up the network exchanges

The network exchanges are setup without any code by using `JSON` files. Each folder name after the root folder (named `network-exchange` but customisable using the `--requests-folder <folder>` option) represents a component of the path. The last folder should be a method name and it will not be included in the path. Each method folder should contain a `configuration.json` file and 0 or more response files that can be anything from images, to `json` to any `Data` really.

Example:
```
├── network-exchanges
│   ├── api
│   │   ├── v1
│   │   │   ├── user
│   │   │   │   ├── POST
│   |   |   |   |   |── configuration.json
│   |   |   |   |   |── response.json
│   |   |   |   |   |── response2.json
│   │   │   │   ├── DELETE
│   |   |   |   |   |── configuration.json
```
This will generate 2 NetworkExchanges. One with a `POST` and another `DELETE` request, both to `api/v1/user` endpoint.

Since the request requirements are generated from the folder structure, the `configuration.json` file is an array of responses consisting of one ore more responses.

Example:
```json
[
  {
    "status_code": 400,
    "response_file": "error.json",
    "delay": 2
  },
  {
    "status_code": 204,
    "headers": {
      "key": "value"
    }
  }
]
```

### Using the CLI
- `espressomartini run` -- Runs the server with the list of all network exchanges.
  - `--configuration <file>` argument points to the name of the configuration file.
  - `--requests-folder <folder>` argument points to the name of the folder where the request reside. Defaults to `networkExchanges`.
- `espressomartini endpoints` -- Fetches the list of all the endpoints
  - `--requests-folder <folder>` argument points to the name of the folder where the request reside. Defaults to `networkExchanges`. 
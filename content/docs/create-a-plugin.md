+++
title = "Create a plugin"
description = "How to create a plugin with go-flutter."
weight = 50
toc = true
bref = "A thorough explanation of how to create and publish a plugin for use with hover."
+++

### Plugin compatibility

Some plugins may be standalone; they expose a feature that desktops provide, but other platforms don't. In many cases though, a feature is already exposed for Android and iOS, but not yet for desktop.

In this guide we'll take a look at the `shared_preferences` plugin, and how to implement it in Go, while being compatible with the existing shared_preferences package.

## Implement a plugin

Flutter uses a flexible system that allows you to call platform-specific APIs, make sure to be familiar with the way Flutter handles platform calls on Android or iOS before going further.
A great tutorial is available on [flutter.dev](https://flutter.dev/docs/development/platform-integration/platform-channels).

### Example: Calling platform-specific Golang code using platform channels.
The following code demonstrates the matching Go implementation described in the official [Flutter platform-channels docs](https://flutter.dev/docs/development/platform-integration/platform-channels#example-calling-platform-specific-ios-and-android-code-using-platform-channels)  
The goal is to retrieve the current battery level of the device via a single platform message, `getBatteryLevel`.


#### Step 1: Create the Flutter platform client
Matching step in the [official Flutter docs](https://flutter.dev/docs/development/platform-integration/platform-channels#step-2-create-the-flutter-platform-client)

We use a MethodChannel with a single platform method that returns the battery level.

```dart
// File: lib/main_desktop.dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

// The client and host sides of a channel are connected through 
// a channel name passed in the channel constructor.
const platform = const MethodChannel('samples.flutter.dev/battery');

void main() {
  test('Test Battery Plugin result', () async {
    // Invoke a method on the method channel, specifying the concrete
    // method to call via the String identifier.
    final int result = await platform.invokeMethod('getBatteryLevel');
    expect(result, 55);

    final String batteryLevel = 'Battery level at $result % .';
    print(batteryLevel);

    SystemNavigator.pop(); // close the app
  });
}
```

#### Step 2: Add an platform-specific implementation using Golang

The following code implementation the Golang platform channels.  
The package name chosen is `flutterGuide`, making the Plugin available by accessing
`&flutterGuide.MyBatteryPlugin{}`
```go
// File: main.go
package flutterGuide

import (
	flutter "github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/go-flutter/plugin"
)

//  Make sure to use the same channel name as was used on the Flutter client side.
const channelName = "samples.flutter.dev/battery"

// MyBatteryPlugin demonstrates how to call a platform-specific API to retrieve
// the current battery level.
//
// This example matches the guide example available on:
// https://flutter.dev/docs/development/platform-integration/platform-channels
type MyBatteryPlugin struct{}

var _ flutter.Plugin = &MyBatteryPlugin{} // compile-time type check

// InitPlugin creates a MethodChannel and set a HandleFunc to the
// shared 'getBatteryLevel' method.
// https://godoc.org/github.com/go-flutter-desktop/go-flutter/plugin#MethodChannel
//
// The plugin is using a MethodChannel through the StandardMethodCodec.
//
// You can also use the more basic BasicMessageChannel, which supports basic,
// asynchronous message passing using a custom message codec. 
// You can also use the specialized BinaryCodec, StringCodec, and JSONMessageCodec 
// struct, or create your own codec.
//
// The JSONMessageCodec was deliberately left out because in Go its better to
// decode directly to known structs.
func (p *MyBatteryPlugin) InitPlugin(messenger plugin.BinaryMessenger) error {
	channel := plugin.NewMethodChannel(messenger, channelName, plugin.StandardMethodCodec{})
	channel.HandleFunc("getBatteryLevel", handleGetBatteryLevel)
	return nil // no error
}

// handleGetBatteryLevel is called when the method getBatteryLevel is invoked by
// the dart code.
// The function returns a fake battery level, without raising an error.
//
// Supported return types of StandardMethodCodec codec are described in a table:
// https://godoc.org/github.com/go-flutter-desktop/go-flutter/plugin#StandardMessageCodec
func handleGetBatteryLevel(arguments interface{}) (reply interface{}, err error) {
	batteryLevel := int32(55) // Your platform-specific API
	return batteryLevel, nil
}
```

Before adding this plugin to **go-flutter**, we need to setup few requirements:  
 - **go-flutter** uses [Go modules](https://github.com/golang/go/wiki/Modules).
     Make sure your go version is updated.
 - A `go.mod` and `go.sum` file.

Next to the above `main.go` file, generate the `go.mod` and `go.sum` files
using:
```sh
export GO111MODULE=on                                           # enable go modules
go mod init github.com/go-flutter-desktop/plugins/flutterGuide  # create the go.mod
go mod tidy                                                     # add missing modules

```
Outputs:
```
// File: Generated go.mod
module github.com/go-flutter-desktop/plugins/flutterGuide

go 1.12

require github.com/go-flutter-desktop/go-flutter vX.XX.X
```
Your plugin is DONE!

#### Step 3: Link your home made plugin to **go-flutter**

First, read the [Plugin info](https://github.com/go-flutter-desktop/go-flutter/wiki/Plugin-info) wiki section.  
Assuming you are using `hover`, and you have initialized `hover` in your Flutter project, edit the option.go file and add your local plugin.

Our option.go file is looking like this:

```go
// File: desktop/cmd/options.go
package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/flutterGuide" // <- url set in `go mod init 'url'`
)

var options = []flutter.Option{
	flutter.AddPlugin(&flutterGuide.MyBatteryPlugin{}), // our plugin
	flutter.WindowInitialDimensions(200, 200),
	flutter.PopBehavior(flutter.PopBehaviorClose), // on SystemNavigator.pop() closes the app
}

```

#### Step 4: Reference your remote plugin as a local one

To fetch the dependency, [hover](https://github.com/go-flutter-desktop/hover)
uses the `go.mod` located under the `desktop/` directory of your Flutter project.  
Since there is no go module available at the [github.com/go-flutter-desktop/plugins/flutterGuide](github.com/go-flutter-desktop/plugins/flutterGuide) url.  
Our build will fail.

```sh
$ hover run
go: github.com/go-flutter-desktop/plugins/flutterGuide@v0.1.0: unknown revision flutterGuide/v0.1.0
go: error loading module requirements
Go get -u github.com/go-flutter-desktop/go-flutter failed: exit status 1
```

To test before publishing, we can use the [`replace`](https://github.com/golang/go/wiki/Modules#when-should-i-use-the-replace-directive)
directive in `/desktop/go.mod`.  
Our `go.mod` file now looks something like this:
```
// File ./desktop/go.mod
module github.com/go-flutter-desktop/examples/pointer_demo/desktop

go 1.12

require (
	github.com/go-flutter-desktop/go-flutter vX.XX.X
	github.com/go-flutter-desktop/plugins/flutterGuide v0.1.0
)

replace github.com/go-flutter-desktop/plugins/flutterGuide => /home/drakirus/lab/go/src/lab/flutterGuide
```

Go wont try to fetch MyBatteryPlugin at the [github.com/go-flutter-desktop/plugins/flutterGuide](github.com/go-flutter-desktop/plugins/flutterGuide) VCS url, instead it will use one located on your file filesystem.
> The new import path from the replace directive is used without needing to update the import paths in the actual source code.

```sh
$ hover run
flutter: Observatory listening on http://127.0.0.1:50300/GAkYtsSwdYU=/
flutter: 00:00 +0: Test Battery Plugin result
flutter: Battery level at 55 % .
flutter: 00:00 +1: All tests passed!
go-flutter: closing application
app 'guide_plugin' exited.
```
:confetti_ball: YaY :confetti_ball:  
We can now publish the platform-specific Go code as a remote Go module.


## Wanting more?
 - You can read existing implementations, [path_provider](https://github.com/go-flutter-desktop/plugins/blob/master/path_provider/plugin.go) is a good example.
 - For more informations, read the our docs about Plugin: [here](https://godoc.org/github.com/go-flutter-desktop/go-flutter#Plugin) and [here](https://godoc.org/github.com/go-flutter-desktop/go-flutter/plugin).

### Codecs

DO That

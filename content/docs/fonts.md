+++
title = "Fonts"
description = "Configure fonts for desktop"
weight = 30
toc = true
bref = "Fonts style your application, but how to use fonts on desktop? This guide walks you thorugh setting up fonts for desktop"
+++

### Fonts are assets

**Question:** What is the issue with fonts and cross-platform?

**Answer:** No text visible? Make sure you have used fonts added to the project asset.  
The default font for `MaterialApp`, Roboto, is not installed on all machines.


### Example

If the host is missing some fonts, it can cause the text to not be rendered or worse the app might crash, the
the [pointer_demo](https://github.com/go-flutter-desktop/examples/tree/master/pointer_demo)
solves this issue by including the fonts as asset.

```dart
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Sample for widgets.Listener',
      theme: ThemeData(
        // If the host is missing some fonts, it can cause the
        // text to not be rendered or worse the app might crash.
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
      ),
      home: MyStatefulWidget(),
    );
  }
}
```

```yaml
# [...]
flutter:

  fonts:
    - family: Roboto
      fonts:
        - asset: fonts/Roboto/Roboto-Thin.ttf
          weight: 100
        - asset: fonts/Roboto/Roboto-Light.ttf
          weight: 300
        - asset: fonts/Roboto/Roboto-Regular.ttf
          weight: 400
        - asset: fonts/Roboto/Roboto-Medium.ttf
          weight: 500
        - asset: fonts/Roboto/Roboto-Bold.ttf
          weight: 700
        - asset: fonts/Roboto/Roboto-Black.ttf
          weight: 900
```

```
Directory structure
.
├── pubspec.yaml
└── fonts
    └── Roboto
        ├── LICENSE.txt
        ├── Roboto-Black.ttf
        ├── Roboto-Bold.ttf
        ├── Roboto-Light.ttf
        ├── Roboto-Medium.ttf
        ├── Roboto-Regular.ttf
        └── Roboto-Thin.ttf
```

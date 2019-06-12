+++
title = "Quick Start"
description = "Up and running in under a minute"
weight = 10
toc = true
bref = "TODO"
+++

### Install

Hover uses [Go](https://golang.org) to build your Flutter application to desktop. Hover itself is also written using the Go language. You will need to [install go](https://golang.org/doc/install) on your development machine.
Then install hover like this:

```bash
go get -u github.com/go-flutter-desktop/hover
```

If you get this error: `cmdApp.ProcessState.ExitCode undefined (type *os.ProcessState has no field or method ExitCode)`,
then update Go to at least version 1.12.

Run the same command to update when a newer version becomes available.

Install these dependencies:

* You need to make sure you have dependencies of GLFW:
  * On macOS, you need Xcode or Command Line Tools for Xcode (`xcode-select --install`) for required headers and libraries.
  * On Ubuntu/Debian-like Linux distributions, you need `libgl1-mesa-dev xorg-dev` packages.
  * On CentOS/Fedora-like Linux distributions, you need `libX11-devel libXcursor-devel libXrandr-devel libXinerama-devel mesa-libGL-devel libXi-devel` packages.
  * See [here](http://www.glfw.org/docs/latest/compile.html#compile_deps) for full details.

### Init

The first time you use hover for a project, you'll need to initialize the project for desktop. `hover init` requires a project path. This is usualy the path for your project on github or a self-hosted git service. _If you are unsure, just make something up, it can always be changed later._

First, cd into a flutter project.

```bash
cd projects/simpleApplication
```

```bash
hover init github.com/my-organization/simpleApplication
```

This creates the directory `desktop` and adds boilerplate files such as Go code and a default logo.

Optionally, you may add [plugins](https://github.com/go-flutter-desktop/plugins) to `desktop/cmd/options.go`

Optionally, change the logo in `desktop/assets/logo.png`, which is used as icon for the window.

Make sure you have a main_desktop.dart that contains the following code before `runApp(..)`:

```dart
debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

### Run with hot-restart

To run the application and attach flutter for hot-reload support:

```bash
hover run
```

The hot-reload is manual because you'll need to press 'r' in the terminal to hot-reload the application.

By default, hover uses the file `lib/main_desktop.dart` as entrypoint. You may specify a different endpoint by using the `--target` flag.
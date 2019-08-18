---
title: "go-flutter: One Year In, What was the journey like?"
description: |
  The go-flutter project is now one year old. We want to let you know how the project has
  evolved over this past year.
date: 2019-08-17T19:19:27+02:00
categories: ["general"]
weight: 20
author: "Pierre Champion (@Drakirus)"
draft: false
---

**I'm very excited** to use this first post to talk about _go-flutter_, what it is, why it was created, and how it has evolved.

Before I explain what _go-flutter_ is, let's start with the **famous** flutter system overview.

![Flutter Architecture Diagram](/img/flutter_overview.svg)

Flutter's engine takes core technologies, Skia, a 2D graphics rendering library, and Dart, and hosts them in a shell. Different platforms have different shells; for example, there are [shells](https://github.com/flutter/engine/tree/master/shell/platform) available for Android and iOS.

The Flutter team also exposes an [embedder API](https://github.com/flutter/engine/tree/master/shell/platform/embedder) which allows Flutter's engine to be used as a library.

The _go-flutter_ project provides a shell that implements the embedder APIs using a single code base that runs on Windows, macOS, and Linux. Achieving cross-platform support from a single codebase was made easy by using Go as the primary programming language.

---

As the title says, this project was created a year ago, at that time, the embedder API was composed of [180 lines of C](https://github.com/go-flutter-desktop/go-flutter/blob/640dcea647f47ceca0e3fb67166d2ea124a09f24/flutter/library/flutter_embedder.h). **To begin with**, I wanted to reproduce a [simple example shell](https://gist.github.com/chinmaygarde/8abf44921f7d87f6da7bf026267c4792) created by **@chinmaygarde**, one of the core maintainer of the Flutter engine. At first, my goal was to learn the Golang programming language, but only after the first [commit](https://github.com/go-flutter-desktop/go-flutter/tree/640dcea647f47ceca0e3fb67166d2ea124a09f24), I realized that my approach had some advantage over [FDE](https://github.com/google/flutter-desktop-embedding):

- A single codebase for all desktops, instead of 3.  
  _(Doesn't this remind you one of Flutter main selling point?_ 😉).  
- At that time the Windows platform didn't support [text input](https://github.com/google/flutter-desktop-embedding/tree/1145c85a2f4717dabc7bf34387874ebb51d80ca8/windows).

_FDE is now part of the flutter project, making it the official desktop shell._

I was having fun, so I kept going, implementing features after feature. (Mostly by reproducing what **@stuartmorgan** added to _FDE_).

---

**Fast forward six months later**, I was having trouble with my studies/work/go-flutter/life balance, don't get me wrong, I did receive **fantastic** input from the community, but it was too much work, the embedder API was growing **fast** (it now has over [1100](https://github.com/flutter/engine/blob/master/shell/platform/embedder/embedder.h) LOC) and my poor Golang architectures decision started to become a burden.

That's when **@GeertJohan** showed up and joined the project. We [moved the project to an organization](https://github.com/go-flutter-desktop/go-flutter/issues/72) and began fixing architecture issues. Support for [flutter platform channels codecs/API](https://flutter.dev/docs/development/platform-integration/platform-channels) was implemented, along with support for plugins.

The [Hover](https://github.com/go-flutter-desktop/hover) tool was created to make building go-flutter applications easier.

---

**Additionally**, We also had minors input into the Flutter engine project. With *go-flutter*, we created a reliable unofficial shell that is used by dozens of users. We hope to create better consensus on desktop shells, differences between *go-flutter* and *FDE* were found and aligned, which is good. Interaction/discussion between different official/unofficial projects shapes the **'Google-controlled'** part of the Flutter project.

**Overall**, I'm very proud of what the project has become. I qualify the project to be **very** mature. We are a real *'competitor'* to the official desktop shells, with an alternative approach. Our primary selling points are:

- Easy plugins writing, it is [more accessible](https://github.com/go-flutter-desktop/go-flutter/issues/191#issuecomment-511384007) (and by the nature of Golang, more maintainable) in *go-flutter* than on the official project.
- Single code-base for windows/mac/linux applications.
- Less dependencies.

We'd like to thank everyone who has contributed to the project so far. Many people have helped us, not just by writing code but also by testing new features, reporting [bugs](https://github.com/go-flutter-desktop/go-flutter/issues?q=is%3Aissue+is%3Aopen+label%3Abug), giving advice or sharing ideas. Also a big shout-out to the maintainers of the Flutter Engine project who've helped us out and shared their feedback. **Thanks!**

We hope to write more about *go-flutter* in future posts, to give you updates on the project.

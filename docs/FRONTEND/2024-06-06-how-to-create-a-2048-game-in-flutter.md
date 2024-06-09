---
layout: post
title:  "How to create a 2048 Game in Flutter"
date:   2024-06-06 16:00:00 +0800
categories: Frontend
tags:
- game
- '2048'
- flutter
description: 
---

## 1. Foreword

I want to develop a little game. It's amazing, right? Nowadays, we have several options for developing rich clients or apps. Cross-platform is an amazing feature that every developer dreams of, I guess. Among the multiple options, flutter and react-native stand out with no doubt. I chose Flutter as I am very familiar with Java which is similar to Dart, the programming language for Flutter. 

In this article, I'll show you how to develop a 2048 game in Flutter step by step.

## 2. Introduction to 2048

2048 is a popular sliding tile puzzle game. The rule is simple: each time you can swipe left, right, up, or down; try your best to get the tile with the number 2048.

![2048_intro](/assets/2048_intro.gif){width=300}

## 3. Preparation

First, we need a computer, of course. It's a laptop for me. We also need to know enough about [Dart programming language](https://dart.dev/overview).

Second, set up the development environment. Refer to https://docs.flutter.dev/get-started/install .

Third, choose your favorite IDE, I prefer `Visual Studio Code` (VSCode).

## 4. Programming

### 4.1 Create a Flutter project

Open a terminal, use the following command to create the project

```sh
flutter create -e g2048
```

Here, `g2048` is the project name.

We can also create it using VSCode. Go `View > Command Palette`, type `flutter`, then click `Flutter: New Project`, and then click `Empty Application`. 

Now we have a `Hello World` app. Great! Run `flutter run` and we'll see it.


### 4.2 Graphic User Interface

We're going to implement a simple GUI like

```txt
2048  | Score
          0
 -----------
|           |               
|   Board   |  
|   (4x4)   |  
|           |  
 -----------
```

Let's say it in Flutter language:

![2048-design-ui-1](/assets/2048-1.png){ width=300 }

![2048-design-ui-2](/assets/2048-2.png){ width=300 }

#### 4.2.1 lib/src/status_pane.dart (draft)

Let's create the first Widget `StatusPane` which is stateless.

``` {.dart .copy linenums="1"} 
import 'package:flutter/material.dart';

class StatusPane extends StatelessWidget {
  const StatusPane({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('2048', style: _textStyle(theme.displayLarge!)),
        Column(
          children: [
            Text('SCORE', style: _textStyle(theme.bodyMedium!)),
            // TODO score
            Text('0', style: _textStyle(theme.displayMedium!)),
          ],
        ),
      ],
    );
  }

  TextStyle _textStyle(TextStyle style) {
    return style.copyWith(
      color: Colors.brown,
      fontWeight: FontWeight.bold,
    );
  }
}
```

#### 4.2.2 lib/src/board.dart (draft)

Next, let's create another Widget `Board` which is also stateless.

``` {.dart .copy linenums="1"}
import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  const Board({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      width: 374,
      height: 374,
      decoration: const BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.all(Radius.circular(4 * 4)),
      ),
      child: _board(theme),
    );
  }

  Widget _board(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 4; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var j = 0; j < 4; j++)
                Tile(
                  num: 0, // TODO
                  theme: theme,
                )
            ],
          )
      ],
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.num,
    required this.theme,
  });

  final int num;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 81,
      height: 81,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.brown.shade400,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          num > 0 ? '$num' : '',
          style: theme.textTheme.displayMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontSize: theme.textTheme.displayMedium!.fontSize!,
          ),
        ),
      ),
    );
  }
}
```

#### 4.2.3 lib/main.dart (draft)

Let's update `main.dart`. And then run `flutter run` or click `Run > Run Without Debugging` in VSCode.

``` {.dart .copy linenums="1"}
import 'package:flutter/material.dart';
import 'package:g2048/src/board.dart';
import 'package:g2048/src/status_pane.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatusPane(),
            SizedBox(height: 81 / 2),
            Board(),
          ],
        ),
      ),
    );
  }
}
```

#### 4.2.4 First refactor

We have created or edited three files now:
- `lib/main.dart`
- `lib/src/status_pane.dart`
- `lib/src/board.dart`

And there are several common constant values among these files. Why don't we define them in a file that other files can include? This way, we have at least the benefit of avoiding hard-code.

???+ note  "lib/src/constants.dart"

    ```dart
    import 'package:flutter/material.dart';

    const kTileSize = 81.0;
    const kMainColor = Colors.brown;
    const kMargin = 4.0;
    ```

??? note "lib/src/status_pane.dart"

    ``` {.dart .copy linenums="1" hl_lines="29"}
    import 'package:flutter/material.dart';
    import 'package:g2048/src/constants.dart';
    
    class StatusPane extends StatelessWidget {
      const StatusPane({
        super.key,
      });
    
      @override
      Widget build(BuildContext context) {
        var theme = Theme.of(context).textTheme;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('2048', style: _textStyle(theme.displayLarge!)),
            Column(
              children: [
                Text('SCORE', style: _textStyle(theme.bodyMedium!)),
                // TODO score
                Text('0', style: _textStyle(theme.displayMedium!)),
              ],
            ),
          ],
        );
      }
    
      TextStyle _textStyle(TextStyle style) {
        return style.copyWith(
          color: kMainColor,
          fontWeight: FontWeight.bold,
        );
      }
    }
    ```

??? note "lib/src/board.dart"

    ``` {.dart .copy linenums="1" hl_lines="14 15 56 59"}
    import 'package:flutter/material.dart';
    import 'package:g2048/src/constants.dart';
    
    class Board extends StatelessWidget {
      const Board({super.key});
    
      @override
      Widget build(BuildContext context) {
        var theme = Theme.of(context);
        return Container(
          width: 374,
          height: 374,
          decoration: const BoxDecoration(
            color: kMainColor,
            borderRadius: BorderRadius.all(Radius.circular(4 *  kMargin)),
          ),
          child: _board(theme),
        );
      }
    
      Widget _board(ThemeData theme) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < 4; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var j = 0; j < 4; j++)
                    Tile(
                      num: 0, // TODO
                      theme: theme,
                    )
                ],
              )
          ],
        );
      }
    }
    
    class Tile extends StatelessWidget {
      const Tile({
        super.key,
        required this.num,
        required this.theme,
      });
    
      final int num;
      final ThemeData theme;
    
      @override
      Widget build(BuildContext context) {
        return Container(
          width: kTileSize,
          height: kTileSize,
          margin: const EdgeInsets.all(kMargin),
          decoration: BoxDecoration(
            color: Colors.brown.shade400,
            borderRadius: const BorderRadius.all(Radius.circular(kMargin)),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              num > 0 ? '$num' : '',
              style: theme.textTheme.displayMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: theme.textTheme.displayMedium!.fontSize!,
              ),
            ),
          ),
        );
      }
    }
    ```

??? node "lib/main.dart"

    ``` {.dart .copy linenums="1" hl_lines="19 38"}
    import 'package:flutter/material.dart';
    import 'package:g2048/src/board.dart';
    import 'package:g2048/src/constants.dart';
    import 'package:g2048/src/status_pane.dart';
    
    void main() {
      runApp(const MyApp());
    }
    
    class MyApp extends StatelessWidget {
      const MyApp({super.key});
    
      // This widget is the root of your application.
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: '2048',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: kMainColor),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        );
      }
    }
    
    class HomeScreen extends StatelessWidget {
      const HomeScreen({super.key});
    
      @override
      Widget build(BuildContext context) {
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatusPane(),
                SizedBox(height: kTileSize / 2),
                Board(),
              ],
            ),
          ),
        );
      }
    }
    ```

### 4.3 Game State


(to be continued...)




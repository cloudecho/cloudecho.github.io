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

<img src='/assets/2048_intro.gif' width="300px">

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


## 4.2 Graphic User Interface

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

<img src='/assets/2048-1.png' width="300px">

<img src='/assets/2048-2.png' width="300px">


(to be continued...)




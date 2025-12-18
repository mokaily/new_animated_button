# 🎨 New Animated Button

A highly customizable, high-performance animated button for Flutter, featuring rich tap and hover effects powered by a custom rendering pipeline.

Built for **Flutter Web, Desktop, and Mobile** with a strong focus on smooth animations and performance.

---

## 📸 Preview

<!-- 
Place screenshots or GIFs here.
Example:
![Jelly Animation](assets/jelly.gif)
![Hover Effects](assets/hover.gif)
-->

---

## ✨ Features

- 🎈 **Advanced tap animations**
    - Jelly (physics-inspired deformation)
    - Scale
    - Ripple
    - Bounce
    - Wave

- 🖱️ **Hover animations** (Web & Desktop)
    - Scale
    - Lift
    - Glow
    - Shimmer

- 🧊 **Glassmorphism**
    - Optional translucent overlay
    - Highlight and border effects

- 🔺 **Custom shapes**
    - Rounded rectangle
    - Stadium
    - Circle
    - Polygon
    - Star
    - Fully custom paths

- ⏱️ **Long-press support**
    - Configurable duration
    - Visual progress indicator

- 🚀 **Performance-oriented**
    - CustomPainter + Listenable repaint
    - Optimized for Flutter Web
    - No unnecessary rebuilds
    - Pointer move throttling

---

## 📦 Installation

```yaml
dependencies:
  new_animated_button: ^1.0.0
```

```bash
flutter pub get
```

---

## 🚀 Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:new_animated_button/new_animated_button.dart';

NewAnimatedButton(
  onPressed: () {
    debugPrint('Pressed');
  },
  tapAnimation: TapAnimation.jelly(),
  hoverAnimation: HoverAnimation.scale(),
  child: const Text(
    'Click Me',
    style: TextStyle(color: Colors.white),
  ),
)
```

---

## 🎯 Tap Animations

```dart
TapAnimation.jelly(),
TapAnimation.scale(),
TapAnimation.ripple(),
TapAnimation.bounce(),
TapAnimation.wave(),
```
<p align="start"><img src="https://github.com/mokaily/new_animated_button/blob/main/example/images/tap_animation.gif?raw=true" width="600"/></p>

---

## 🖱️ Hover Animations

```dart
HoverAnimation.scale(),
HoverAnimation.lift(),
HoverAnimation.glow(),
HoverAnimation.shimmer(),
HoverAnimation.none(),
```
<p align="start"><img src="https://github.com/mokaily/new_animated_button/blob/main/example/images/hover_animation.gif?raw=true" width="600"/></p>

---

## 🧩 Combined Animations (Tap + Hover)

You can combine tap and hover animations together:

```dart
NewAnimatedButton(
  tapAnimation: TapAnimation.wave(),
  hoverAnimation: HoverAnimation.glow(),
  gradient: const LinearGradient(
  colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
  ),
  child: const Text(
  'Jelly + Lift',
  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
)
```
<p align="start"><img src="https://github.com/mokaily/new_animated_button/blob/main/example/images/combined_animation.gif?raw=true" width="600"/></p>


---

## 🧊 Glassmorphism

```dart
NewAnimatedButton(
  enableGlassmorphism: true,
  child: const Text('Glass'),
)
```

---

## 🔺 Custom Shapes

```dart
ButtonShape.roundedRectangle(radius: 30);
ButtonShape.stadium();
ButtonShape.circle();
ButtonShape.polygon(sides: 6);
ButtonShape.star(points: 5);
```
<p align="start"><img src="https://github.com/mokaily/new_animated_button/blob/main/example/images/shapes.png?raw=true" width="600"/></p>


---

## ⏱️ Long Press

```dart
NewAnimatedButton(
  onLongPress: () {},
  longPressDuration: const Duration(milliseconds: 800),
  tapAnimation: TapAnimation.scale(),
  child: const Text('Hold Me'),
)
```

---

## ⚡ Performance Notes

- Uses CustomPainter repaint pipeline
- Optimized for Flutter Web
- No frame-jank on animation release

---


## Donations

We need your support. Projects like this can not be successful without support from the community. If you find this project useful, and would like to support further development and ongoing maintenance, please consider donating.

<p align="center">
  <a href="https://www.paypal.com/donate/?hosted_button_id=9PCKHLMEQJUS4" target="_blank">
    <img src="https://raw.githubusercontent.com/aha999/DonateButtons/master/Paypal.png" width=300 />
  </a>
</p>

<p align="center">
<a href="https://www.buymeacoffee.com/mokaily" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" width=300  alt="Buy Me A Coffee" ></a>
</p>

## Sponsors
Want to become a sponsor? [[Become a Sponsor](https://github.com/sponsors/mokaily)]
<p align="center">
<a href="https://github.com/sponsors/mokaily" target="_blank">
  <img src="https://img.shields.io/badge/Sponsor%20me%20on-GitHub-24292f?logo=githubsponsors&logoColor=white&style=for-the-badge" width="300" alt="Sponsor me on GitHub">
</a>
</p>

###
###
###
######

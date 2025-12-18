import 'package:flutter/material.dart';
import 'package:new_animated_button/new_animated_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Animated Button',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const AnimationDemoPage(),
    );
  }
}

class AnimationDemoPage extends StatelessWidget {
  const AnimationDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD4C5E8), Color(0xFFE5D4F0), Color(0xFFC5D9E8)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const Text(
                  'New Animated Buttons 🎨',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                ),
                const SizedBox(height: 40),

                // TAP ANIMATIONS
                const Text('Tap Animations', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    NewAnimatedButton(
                      onPressed: () => {},
                      tapAnimation: TapAnimation.jelly(),
                      child: const Text('Jelly',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    NewAnimatedButton(
                      onPressed: () => {},
                      tapAnimation: TapAnimation.scale(),
                      gradient: const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFFDB2777)]),
                      child: const Text('Scale',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    NewAnimatedButton(
                      onPressed: () => {},
                      tapAnimation: TapAnimation.ripple(),
                      gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)]),
                      child: const Text('Ripple',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    NewAnimatedButton(
                      onPressed: () => {},
                      tapAnimation: TapAnimation.bounce(),
                      gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                      child: const Text('Bounce',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    NewAnimatedButton(
                      onPressed: () => {},
                      tapAnimation: TapAnimation.wave(),
                      gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)]),
                      child: const Text('Wave',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // HOVER ANIMATIONS
                const Text('Hover Animations', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    NewAnimatedButton(
                      onPressed: () => {},
                      tapAnimation: TapAnimation.scale(),
                      hoverAnimation: HoverAnimation.scale(),
                      gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)]),
                      child: const Text('Hover Scale',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    NewAnimatedButton(
                      onPressed: () => {},
                      tapAnimation: TapAnimation.scale(),
                      hoverAnimation: HoverAnimation.lift(),
                      gradient: const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFFDB2777)]),
                      child: const Text('Lift',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    NewAnimatedButton(
                      onPressed: () => {},
                      tapAnimation: TapAnimation.scale(),
                      hoverAnimation: HoverAnimation.glow(),
                      gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)]),
                      child: const Text('Glow',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    NewAnimatedButton(
                      onPressed: () => {},
                      tapAnimation: TapAnimation.scale(),
                      hoverAnimation: HoverAnimation.shimmer(),
                      gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                      child: const Text('Shimmer',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // COMBINED
                const Text('Combined Animations',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    NewAnimatedButton(
                      onPressed: () => {},
                      onPressedUp: () => {},
                      tapAnimation: TapAnimation.jelly(),
                      hoverAnimation: HoverAnimation.scale(),
                      child: const Text('Jelly + Scale',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    NewAnimatedButton(
                      onPressed: () => {},
                      onPressedUp: () => {},
                      tapAnimation: TapAnimation.ripple(),
                      hoverAnimation: HoverAnimation.lift(),
                      gradient: const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFFDB2777)]),
                      child: const Text('Ripple + Lift',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    NewAnimatedButton(
                      onPressed: () => {},
                      onPressedUp: () => {},
                      tapAnimation: TapAnimation.wave(),
                      hoverAnimation: HoverAnimation.glow(),
                      gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)]),
                      child: const Text('Wave + Glow',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // LONG PRESS
                const Text('Long Press', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    NewAnimatedButton(
                      onPressed: () => {},
                      onPressedUp: () => {},
                      onLongPress: () => {},
                      longPressDuration: const Duration(milliseconds: 500),
                      tapAnimation: TapAnimation.scale(),
                      gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)]),
                      child: const Text('Hold Me (500ms)',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    NewAnimatedButton(
                      onPressed: () => {},
                      onPressedUp: () => {},
                      onLongPress: () => {},
                      longPressDuration: const Duration(milliseconds: 1000),
                      tapAnimation: TapAnimation.jelly(),
                      gradient: const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFFDB2777)]),
                      child: const Text('Hold Me (1s)',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    NewAnimatedButton(
                      onPressed: () => {},
                      onPressedUp: () => {},
                      onLongPress: () => {},
                      longPressDuration: const Duration(milliseconds: 1500),
                      tapAnimation: TapAnimation.ripple(),
                      gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                      child: const Text('Hold Me (1.5s)',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                const Text(
                  '💡 Hover, click, and hold to see all animations!',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

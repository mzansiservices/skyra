import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedSkyBackground extends StatefulWidget {
  final Widget child;

  const AnimatedSkyBackground({super.key, required this.child});

  @override
  State<AnimatedSkyBackground> createState() => _AnimatedSkyBackgroundState();
}

class _AnimatedSkyBackgroundState extends State<AnimatedSkyBackground>
    with TickerProviderStateMixin {
  late AnimationController _starController;
  late AnimationController _gradientController;
  late List<Star> _stars;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _gradientController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _stars = List.generate(
      100,
      (index) => Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 3 + 1,
        opacity: _random.nextDouble() * 0.8 + 0.2,
        animationDelay: _random.nextDouble() * 2,
      ),
    );
  }

  @override
  void dispose() {
    _starController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_starController, _gradientController]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF1a1a2e),
                const Color(0xFF16213e),
                const Color(0xFF0f3460),
                Colors.black,
              ],
              stops: [
                0.0,
                0.3 + (_gradientController.value * 0.1),
                0.7 + (_gradientController.value * 0.1),
                1.0,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Animated stars
              ..._stars.map((star) => _buildStar(star)),
              // Content
              widget.child,
            ],
          ),
        );
      },
    );
  }

  Widget _buildStar(Star star) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _starController,
        curve: Interval(
          star.animationDelay / 20,
          (star.animationDelay + 1) / 20,
          curve: Curves.easeInOut,
        ),
      ),
    );

    return Positioned(
      left: star.x * MediaQuery.of(context).size.width,
      top: star.y * MediaQuery.of(context).size.height,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Opacity(
            opacity: star.opacity * (0.5 + 0.5 * animation.value),
            child: Container(
              width: star.size,
              height: star.size,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(star.opacity * 0.5),
                    blurRadius: star.size * 2,
                    spreadRadius: star.size * 0.5,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double animationDelay;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.animationDelay,
  });
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const primaryColor = Color(0x9C00BCD3);

  late final AnimationController _logoController =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
  late final AnimationController _backgroundController =
      AnimationController(vsync: this, duration: const Duration(seconds: 10));
  late final AnimationController _pulseController =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
  late final AnimationController _heartbeatController =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
  late final AnimationController _dnaController =
      AnimationController(vsync: this, duration: const Duration(seconds: 8));

  late final Animation<double> _logoScaleAnimation = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));
  late final Animation<double> _logoFadeAnimation = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _logoController, curve: const Interval(0, .8, curve: Curves.easeInOut)));
  late final Animation<double> _backgroundAnimation = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _backgroundController, curve: Curves.linear));
  late final Animation<double> _pulseAnimation =
      Tween(begin: .9, end: 1.1).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  late final Animation<double> _heartbeatAnimation =
      Tween(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _heartbeatController, curve: Curves.easeInOut));
  late final Animation<double> _dnaAnimation = Tween(begin: 0.0, end: 2 * math.pi)
      .animate(CurvedAnimation(parent: _dnaController, curve: Curves.linear));

  @override
  void initState() {
    super.initState();
    _logoController.forward();
    _backgroundController.repeat();
    _pulseController.repeat(reverse: true);
    _heartbeatController.repeat(reverse: true);
    _dnaController.repeat();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    _pulseController.dispose();
    _heartbeatController.dispose();
    _dnaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // gradient bg
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFFE8F5E8), Color(0xFFE1F5FE), Color(0xFFF3E5F5)],
              ),
            ),
          ),

          // animated patterns
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (_, __) => CustomPaint(
              painter: _MedicalPatternPainter(_backgroundAnimation.value, primaryColor),
              size: Size(w, h),
            ),
          ),

          // dna helix
          AnimatedBuilder(
            animation: _dnaAnimation,
            builder: (_, __) => CustomPaint(
              painter: _DNAHelixPainter(_dnaAnimation.value, primaryColor),
              size: Size(w, h),
            ),
          ),

          // floating emojis
          ...List.generate(15, (i) {
            return AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (_, __) {
                final off = _backgroundAnimation.value * 2 * math.pi;
                final icons = ['💊', '🩺', '❤️', '🧬', '⚕️'];
                return Positioned(
                  left: w * .1 + (w * .8 * math.sin(off + i * .4)),
                  top: h * .15 + (h * .7 * math.cos(off + i * .3)),
                  child: Opacity(
                    opacity: .3,
                    child: Transform.scale(
                      scale: .8 + .2 * math.sin(off + i),
                      child: Text(icons[i % icons.length], style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                );
              },
            );
          }),

          // logo + pulse
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge(
                  [_logoScaleAnimation, _logoFadeAnimation, _pulseAnimation, _heartbeatAnimation]),
              builder: (_, __) {
                return Transform.scale(
                  scale: _logoScaleAnimation.value * _pulseAnimation.value,
                  child: Opacity(
                    opacity: _logoFadeAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          primaryColor.withOpacity(.1),
                          primaryColor.withOpacity(.05),
                          Colors.transparent
                        ]),
                        boxShadow: [
                          BoxShadow(color: primaryColor.withOpacity(.2), blurRadius: 40, spreadRadius: 10),
                          BoxShadow(color: Colors.white.withOpacity(.8), blurRadius: 20, spreadRadius: 5),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.scale(
                            scale: _heartbeatAnimation.value,
                            child: Container(
                              height: w * .45,
                              width: w * .45,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: primaryColor.withOpacity(.3), width: 2)),
                            ),
                          ),
                          Container(
                            height: w * .35,
                            width: w * .35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(.9),
                              border: Border.all(color: primaryColor.withOpacity(.2), width: 3),
                            ),
                          ),
                          SizedBox(
                            height: w * .35,
                            width: w * .35,
                            child: SvgPicture.asset('Assets/icons/ic-SynCare-logo.svg'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // loading caption & indicator
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _logoFadeAnimation,
              builder: (_, __) {
                return Opacity(
                  opacity: _logoFadeAnimation.value,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 60, height: 60,
                        child: Stack(alignment: Alignment.center, children: [
                          SizedBox(
                            width: 50, height: 50,
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              valueColor: const AlwaysStoppedAnimation(primaryColor),
                              backgroundColor: primaryColor.withOpacity(.2),
                            ),
                          ),
                          const Icon(Icons.favorite, color: primaryColor, size: 20),
                        ]),
                      ),
                      const SizedBox(height: 24),
                      Text('Caring for Your Health…',
                          style: TextStyle(color: primaryColor.withOpacity(.8), fontSize: 18, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text('SynCare • Healthcare Redefined',
                          style: TextStyle(color: primaryColor.withOpacity(.6), fontSize: 14, fontWeight: FontWeight.w300)),
                    ],
                  ),
                );
              },
            ),
          ),

          // mini bar‐chart deco
          Positioned(
            top: 80, right: 30,
            child: AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (_, __) => Opacity(
                opacity: .3,
                child:
                    CustomPaint(painter: _HealthStatsPainter(_backgroundAnimation.value, primaryColor), size: const Size(100, 80)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ─────────────────────────── painters (unchanged) ─────────────────────────── */

class _MedicalPatternPainter extends CustomPainter {
  final double t;
  final Color c;
  _MedicalPatternPainter(this.t, this.c);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = c.withOpacity(.1)..strokeWidth = 1.5..style = PaintingStyle.stroke;
    for (var i = 0; i < 4; ++i) {
      for (var j = 0; j < 3; ++j) {
        final cx = size.width / 4 * (i + .5);
        final cy = size.height / 3 * (j + .5);
        final s = 20 + 5 * math.sin(t * 2 * math.pi + i + j);
        canvas.drawLine(Offset(cx - s, cy), Offset(cx + s, cy), p);
        canvas.drawLine(Offset(cx, cy - s), Offset(cx, cy + s), p);
      }
    }

    p..strokeWidth = 2..color = c.withOpacity(.15);
    const pat = [0, .2, .8, -.5, 1.2, -.8, .3, 0];
    for (var row = 0; row < 3; ++row) {
      final y0 = size.height * (.2 + .3 * row);
      final path = Path();
      for (var i = 0; i < size.width ~/ 20; ++i) {
        final x = i * 20 + (t * 40) % 40;
        final idx = i % pat.length;
        final y = y0 + pat[idx] * 30;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _DNAHelixPainter extends CustomPainter {
  final double t;
  final Color c;
  _DNAHelixPainter(this.t, this.c);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = c.withOpacity(.2)..strokeWidth = 3..style = PaintingStyle.stroke;
    final p2 = Paint()..color = c.withOpacity(.1)..strokeWidth = 1;
    final path1 = Path(), path2 = Path();
    for (var i = 0; i < 50; ++i) {
      final prog = i / 50;
      final x1 = 50 + 30 * math.sin(prog * 4 * math.pi + t);
      final x2 = 50 - 30 * math.sin(prog * 4 * math.pi + t);
      final y = size.height * prog;
      if (i == 0) {
        path1.moveTo(x1, y); path2.moveTo(x2, y);
      } else {
        path1.lineTo(x1, y); path2.lineTo(x2, y);
      }
      if (i % 5 == 0) canvas.drawLine(Offset(x1, y), Offset(x2, y), p2);
    }
    canvas.drawPath(path1, p); canvas.drawPath(path2, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _HealthStatsPainter extends CustomPainter {
  final double t;
  final Color c;
  _HealthStatsPainter(this.t, this.c);

  @override
  void paint(Canvas canvas, Size size) {
    final bars = [.6, .8, .4, .9, .7];
    final w = size.width / bars.length;
    for (var i = 0; i < bars.length; ++i) {
      final h = size.height * bars[i] * (.5 + .5 * math.sin(t * 2 * math.pi + i * .5));
      canvas.drawRect(
        Rect.fromLTWH(i * w + 5, size.height - h, w - 10, h),
        Paint()..color = c.withOpacity(.3)..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

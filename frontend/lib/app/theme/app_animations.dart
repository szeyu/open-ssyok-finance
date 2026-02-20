import 'package:flutter/material.dart';

class AppAnimations {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 350);
  static const entranceDuration = Duration(milliseconds: 400);

  static const Curve standard = Curves.easeInOut;
  static const Curve decelerate = Curves.decelerate;
  static const Curve spring = Curves.elasticOut;
  static const Curve entranceCurve = Curves.easeOutCubic;
}

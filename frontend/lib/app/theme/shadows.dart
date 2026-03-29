import 'package:flutter/material.dart';

/// Shared layered shadow system for depth
class AppShadows {
  /// Subtle card shadow — tight + ambient layers
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 1, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 4)),
  ];

  /// Elevated card shadow — more prominent
  static const List<BoxShadow> elevated = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 16, offset: Offset(0, 8)),
  ];
}

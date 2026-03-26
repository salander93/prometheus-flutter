import 'package:flutter/material.dart';

/// Holds the [TextEditingController]s for a single set's reps & weight inputs.
class SetInputControllers {
  SetInputControllers({required this.reps, required this.weight});

  final TextEditingController reps;
  final TextEditingController weight;

  void dispose() {
    reps.dispose();
    weight.dispose();
  }
}

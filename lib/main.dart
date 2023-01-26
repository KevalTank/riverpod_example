import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo/my_app.dart';

// Entry point of the program
void main() {
  runApp(
    // Wrapping the whole app with the provider scope
    // so app can know that provider state changes
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

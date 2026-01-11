import 'package:aml/src/app/aml_app.dart';
import 'package:aml/src/app/bootstrap.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await bootstrap();
  runApp(const AmlApp());
}

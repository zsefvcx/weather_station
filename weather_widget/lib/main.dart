import 'package:flutter/material.dart';

import 'feature/domain/bloc/bloc.dart';


void main() {
  BlocFactory.instance.initialize();

  runApp(const Placeholder());
}

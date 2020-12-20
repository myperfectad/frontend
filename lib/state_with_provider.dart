import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A simple utility class that grabs and exposes an instance of the provider
/// supplied via T.

abstract class StateWithProvider<S extends StatefulWidget, T> extends State<S> {
  T provider;

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    provider = Provider.of<T>(context, listen: false);
  }
}
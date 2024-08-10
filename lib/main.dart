import 'package:flutter/material.dart';
import 'package:expense_tracker/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'simple_bloc_observer.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer =SimpleBlocObserver();
  runApp(const MyApp());
}

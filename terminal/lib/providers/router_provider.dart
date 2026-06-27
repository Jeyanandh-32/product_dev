import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:terminal/pages/home.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/pages/login.dart';

final router = GoRouter(
  initialLocation: '/loading',
  routes: [
    GoRoute(
      path: '/loading',
      builder: (context, state) => const Scaffold(
        body: Loading(),
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
    ),
  ],
);

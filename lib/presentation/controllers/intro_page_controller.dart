import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:provider/provider.dart';

import '../screens/main_app/main_app.dart';
import 'session_controller.dart';

class IntroPageController extends ChangeNotifier {
  List<String> _imagePaths = [
    "images/WelcomeImg.png",
  ];

  List<String> _imageHeaders = [
    "Welcome to Ojawa",
    "Get started in only a few minutes",
    "Maximize your daily profit",
  ];

  List<String> _imageSubheadings = [
    "Your Marketplace for Secure and Seamless Shopping.",
    "Nostrum facilis voluptatum voluptates sunt facere, distinctio ullam aspernatur cumque autem a esse non unde, nemo iusto!",
    "Sign up today and enjoy the first month of premium benefits on us.",
  ];

  int _current = 0;

  // Use the fully qualified CarouselController from the carousel_slider package
  final CarouselController _controller = CarouselController();
  DateTime? currentBackPressTime;
  final BuildContext context;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  IntroPageController(
      {required this.context,
      required this.onToggleDarkMode,
      required this.isDarkMode,
      required vsync}) {
    initialize(context);
  }

  //public getters
  int get current => _current;
  List<String> get imageHeaders => _imageHeaders;
  List<String> get imagePaths => _imagePaths;
  List<String> get imageSubheadings => _imageSubheadings;

  CarouselController get controller => _controller;

  void setCurrent(int value) {
    _current = value;
    notifyListeners();
  }

  void initialize(BuildContext context) {
    // Provider.of<SessionController>(context, listen: false).initializeSession();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainApp(
              key: UniqueKey(),
              onToggleDarkMode: onToggleDarkMode,
              isDarkMode: isDarkMode),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';

class RouterAnimation {
  static SlideTransition Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) get bottomToTop {
    return (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    };
  }

  static SlideTransition Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) get leftToRight {
    return (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    };
  }

  static SlideTransition Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) get rightToLeft {
    return (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    };
  }
}

class CustomRouter {
  static Route _createPageRoute(
      Widget page,
      SlideTransition Function(
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child)
          animation) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: animation,
    );
  }

  static Route createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
    );
  }

  static void push({
    required BuildContext context,
    required Widget page,
    required SlideTransition Function(
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child)
        animation,
  }) {
    Navigator.of(context).push(_createPageRoute(page, animation));
  }

  static void pushReplacement({
    required BuildContext context,
    required Widget page,
    required SlideTransition Function(
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child)
        animation,
  }) {
    Navigator.of(context).pushReplacement(_createPageRoute(page, animation));
  }
}

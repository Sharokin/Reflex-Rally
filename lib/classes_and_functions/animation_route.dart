import 'package:flutter/cupertino.dart';

/* pass these parameters for transition:
 
    widget = page you want to navigate to
    duration = duration in milliseconds
    anim = the animation for the navigation

    Example: Navigator.push(context,
          AnimationRoute(widget: const Countdown(), anim: Curves.slowMiddle, duration: 1500));       
*/

class AnimationRoute extends PageRouteBuilder {
  final Widget widget;
  final int duration;
  final Curve anim;

  AnimationRoute(
      {required this.widget, required this.duration, required this.anim})
      : super(
            transitionDuration: Duration(milliseconds: duration),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              animation = CurvedAnimation(parent: animation, curve: anim);

              return ScaleTransition(
                alignment: Alignment.center,
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return widget;
            });
}

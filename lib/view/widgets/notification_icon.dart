import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationIcon extends StatelessWidget {
  final bool isThereNotification;

  const NotificationIcon({super.key, required this.isThereNotification});

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      SvgPicture.asset('lib/assets/svgs/notification.svg'),
      if (isThereNotification)
        SvgPicture.asset('lib/assets/svgs/notification_active.svg'),
    ]);
  }
}

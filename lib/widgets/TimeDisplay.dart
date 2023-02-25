import 'package:flutter/cupertino.dart';

// class TimeDisplaySettings {
//   bool showMilliseconds
// }
enum TimeDisplayMode {
  h24,
  h12
}
class TimeDisplay extends StatelessWidget {
  const TimeDisplay({super.key, required this.duration, this.textSize, this.mode = TimeDisplayMode.h12});

  final Duration duration;
  final int? textSize;
  final TimeDisplayMode mode;

  @override
  Widget build(BuildContext context) {

    //split the duration into days, hours, mins, seconds, miliseconds
    int days = duration.inDays;
    int hours = duration.inHours% (mode==TimeDisplayMode.h24?24:12);
    if(mode==TimeDisplayMode.h12) {
      hours = hours==0?12:hours;
    }
    int minutes = duration.inMinutes%60;
    int seconds = duration.inSeconds%60;
    int milliseconds = duration.inMilliseconds%1000;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        //days
        if(days != 0) Text(days.toString().padLeft(2, '0') + ":"),

        //hours
        if(days != 0 || hours != 0) Text(hours.toString().padLeft(2, '0') + ":"),
        //mins
        Text(minutes.toString().padLeft(2, '0') + ":"),
        //seconds
        Text(seconds.toString().padLeft(2, '0')),
        //milliseconds
        Text( "." + milliseconds.toString().padLeft(3, '0')),

        if(mode == TimeDisplayMode.h12) Text((duration.inHours%24)>=12?" PM":" AM")
      ]),
    );
  }
}
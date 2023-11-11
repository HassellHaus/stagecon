// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:stagecon/widgets/ClockDisplay.dart';



// class DurationEditor extends StatefulWidget {
//   const DurationEditor(
//       {Key? key,
//       required this.duration,
//       this.textSize,
//       this.mode = ClockDisplayMode.h24,
//       this.msPrecision = 3})
//       : super(key: key);

//   final Duration duration;
//   final int? textSize;
//   final ClockDisplayMode mode;
//   final int msPrecision;

//   @override
//   State<DurationEditor> createState() => _DurationEditorState();
// }

// class _DurationEditorState extends State<DurationEditor> {

//     bool _editingDays = false;
//     bool _editingHours = false;
//     bool _editingMinutes = false;
//     bool _editingSeconds = false;
//     bool _editingMilliseconds = false;

//   TextEditingController _daysController = TextEditingController();
//   TextEditingController _hoursController = TextEditingController();
//   TextEditingController _minutesController = TextEditingController();
//   TextEditingController _secondsController = TextEditingController();
//   TextEditingController _msController = TextEditingController();

//   FocusNode _daysFocus = FocusNode();
//   FocusNode _hoursFocus = FocusNode();
//   FocusNode _minutesFocus = FocusNode();
//   FocusNode _secondsFocus = FocusNode();
//   FocusNode _msFocus = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _initControllersAndFocusNodes();
//   }

//   @override
//   void dispose() {
//     _daysController.dispose();
//     _hoursController.dispose();
//     _minutesController.dispose();
//     _secondsController.dispose();
//     _msController.dispose();
//     _daysFocus.dispose();
//     _hoursFocus.dispose();
//     _minutesFocus.dispose();
//     _secondsFocus.dispose();
//     _msFocus.dispose();
//     super.dispose();
//   }

//   void _initControllersAndFocusNodes() {
//     _daysFocus.addListener(() {
//       if (_daysFocus.hasFocus) {
//         _daysController.selection = TextSelection(
//             baseOffset: 0, extentOffset: _daysController.text.length);
//       }
//       setState(() {
//         _editingDays = _daysFocus.hasFocus;
//       });
//     });
//     _hoursFocus.addListener(() {
//       if (_hoursFocus.hasFocus) {
//         _hoursController.selection = TextSelection(
//             baseOffset: 0, extentOffset: _hoursController.text.length);
//       }
//       setState(() {
//         _editingHours = _hoursFocus.hasFocus;
//       });
//     });
//     _minutesFocus.addListener(() {
//       if (_minutesFocus.hasFocus) {
//         _minutesController.selection = TextSelection(
//             baseOffset: 0, extentOffset: _minutesController.text.length);
//       }
//       setState(() {
//         _editingMinutes = _minutesFocus.hasFocus;
//       });
//     });
//     _secondsFocus.addListener(() {
//       if (_secondsFocus.hasFocus) {
//         _secondsController.selection = TextSelection(
//             baseOffset: 0, extentOffset: _secondsController.text.length);
//       }
//       setState(() {
//         _editingSeconds = _secondsFocus.hasFocus;
//       });
//     });
//     _msFocus.addListener(() {
//       if (_msFocus.hasFocus) {
//         _msController.selection = TextSelection(
//             baseOffset: 0, extentOffset: _msController.text.length);
//       }
//       setState(() {
//         _editingMilliseconds = _msFocus.hasFocus;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     int days = widget.duration.inDays;
//     int hours = widget.duration.inHours % 24;
//     int minutes = widget.duration.inMinutes % 60;
//     int seconds = widget.duration.inSeconds % 60;
//     int milliseconds = widget.duration.inMilliseconds % 1000;

//     _daysController.text = days.toString();
//     _hoursController.text = hours.toString();
//     _minutesController.text = minutes.toString();
//     _secondsController.text = seconds.toString();
//     _msController.text = milliseconds.toString();

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _buildDigitGroup(
//   isActive: _editingDays,
//   // value: days,
//   onTap: () {
//     setState(() {
//       _editingDays = !_editingDays;
//     });
//   },
//   controller: _daysController,
//   focusNode: _daysFocus,
// ),

//         _buildDigitGroup(
//           // value: hours,
//           onTap: () {
//             setState(() {
//               _hoursFocus.requestFocus();
//               _editingHours = !_editingHours;
//             });
          
//           },
          
//           isActive: _editingDays,
//           controller: _hoursController, focusNode: _hoursFocus),
//         // _buildDigitGroup(controller: _minutesController, focusNode: _minutesFocus),
//         // _buildDigitGroup(controller: _secondsController, focusNode: _secondsFocus),
//         // _buildDigitGroup(controller: _msController, focusNode: _msFocus),
//       ],
//     );
//   }

// Widget _buildDigitGroup({
//   required bool isActive,
//   // required int value,
//   required VoidCallback onTap,
//   required TextEditingController controller,
//   required FocusNode focusNode,
// }) {
//   return GestureDetector(
//     onTap: () {
//       onTap();
//       FocusScope.of(context).requestFocus(focusNode);
//       controller.selection =
//           TextSelection(baseOffset: 0, extentOffset: controller.text.length);
//     },
//     child: isActive
//         ? _buildTextField(controller, focusNode)
//         : Container(
//             child: Text(controller.text.toString().padLeft(2, '0')),
//             width: 30,
//           ),
//   );
// }


//   Widget _buildTextField(TextEditingController controller, FocusNode focusNode) {
//     return Container(
//       width: 30,
//       child: CupertinoTextField(
//         controller: controller,
//         focusNode: focusNode,
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }
import 'package:dart_ms/dart_ms.dart';
import 'package:flutter/cupertino.dart';
class DurationEditorController extends TextEditingController {
  DurationEditorController({
    Duration duration = Duration.zero,
    required this.focusNode,
  }) : 
       super(text: durationToText(duration)) {
    focusNode.addListener(_focusChanged);
  }

  final FocusNode focusNode;

  // Duration _duration;

  void _focusChanged() {
    print(focusNode.hasFocus);
    if (!focusNode.hasFocus) {
      // This means the focus was lost, so convert and set duration
      convertAndSetDuration();
    }
  }


  static String durationToText(Duration duration) {
    return '${duration.inDays}:${duration.inHours % 24}:${duration.inMinutes % 60}:${duration.inSeconds % 60}.${duration.inMilliseconds % 1000}';
  }

  static Duration parseDuration(String text) {
    if (text.isEmpty) {
      return Duration.zero;
    }
    RegExp fullExp = RegExp(r'(\d+):(\d+):(\d+):(\d+)[;:.](\d+)');
    if (fullExp.hasMatch(text)) {
      var match = fullExp.firstMatch(text)!;
      return Duration(
        days: int.parse(match.group(1)!),
        hours: int.parse(match.group(2)!),
        minutes: int.parse(match.group(3)!),
        seconds: int.parse(match.group(4)!),
        milliseconds: int.parse(match.group(5)!),
      );
    }

    // Handle shorthand formats like "1m", "2h", etc.
    // RegExp shorthandExp = RegExp(r'(\d+)([dhms])');
    // if (shorthandExp.hasMatch(text)) {
    //   var match = shorthandExp.firstMatch(text)!;
    //   int value = int.parse(match.group(1)!);
    //   switch (match.group(2)) {
    //     case 'd':
    //       return Duration(days: value);
    //     case 'h':
    //       return Duration(hours: value);
    //     case 'm':
    //       return Duration(minutes: value);
    //     case 's':
    //       return Duration(seconds: value);
    //     default:
    //       throw Exception('Invalid duration format');
    //   }
    // }

    // Handle milliseconds
    double? milliseconds = ms(text);
    if (milliseconds != null) {
      return Duration(milliseconds: milliseconds.toInt());
    }

    return Duration.zero;
  }

  // void setDuration(Duration newDuration, {bool convertToFullFormat = true}) {
  //   _duration = newDuration;
  //   if (convertToFullFormat) {
  //     text = durationToText(newDuration);
  //   }
  // }



  @override
  set text(String newText) {
    // Allow shorthand input without immediate conversion
    super.text = newText;
  }

  // Call this method when the user finishes editing
  void convertAndSetDuration() {
    try {
      text = durationToText(parseDuration(text));
    } catch (e) {
      // Handle or log error
    }
  }

  Duration get duration => parseDuration(text);
  set duration(Duration newDuration) {
    text = durationToText(newDuration);
  }




  @override
  void dispose() {
    focusNode.removeListener(_focusChanged);
    super.dispose();
  }



}


// class DurationEditorController extends TextEditingController {
//   DurationEditorController({this.duration = Duration.zero});

//   Duration duration;

//   void setDuration(Duration newDuration) {
//     duration = newDuration;
//     notifyListeners();
//   }
//   @override
//   String get text {
//     //days:hours:minutes:seconds[;:.]milliseconds
//     return '${duration.inDays}:${duration.inHours % 24}:${duration.inMinutes % 60}:${duration.inSeconds % 60}.${duration.inMilliseconds % 1000}';
//   }

//   @override
//   set text(String v) {
//     //days:hours:minutes:seconds[;:.]milliseconds
//     // if it cant match this then fallback to the ms library
//     RegExp exp = RegExp(r'(\d+):(\d+):(\d+):(\d+)[;:.](\d+)');
//     if (exp.hasMatch(v)) {
//       var match = exp.firstMatch(v);
//       int days = int.parse(match!.group(1)!);
//       int hours = int.parse(match.group(2)!);
//       int minutes = int.parse(match.group(3)!);
//       int seconds = int.parse(match.group(4)!);
//       int milliseconds = int.parse(match.group(5)!);
//       duration = Duration(
//           days: days,
//           hours: hours,
//           minutes: minutes,
//           seconds: seconds,
//           milliseconds: milliseconds);
//     } else {
//       double? milliseconds = ms(v);
//       if(milliseconds == null) {
//         throw Exception('Could not parse duration');
//       }
//       duration = Duration(milliseconds: milliseconds.toInt());
//     }
//   }

//    @override
//   set value(TextEditingValue newValue) {
//     assert(
//       !newValue.composing.isValid || newValue.isComposingRangeValid,
//       'New TextEditingValue $newValue has an invalid non-empty composing range '
//       '${newValue.composing}. It is recommended to use a valid composing range, '
//       'even for readonly text fields',
//     );
//     super.value = newValue;
//   }
// }


// class DurationEditor extends StatefulWidget {
//   const DurationEditor({super.key, required this.controller, });

//   final DurationEditorController controller;
//   @override
//   State<DurationEditor> createState() => _DurationEditorState();
// }

// // class _DurationEditorState extends State<DurationEditor> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Cupertino
// //   }
// // }
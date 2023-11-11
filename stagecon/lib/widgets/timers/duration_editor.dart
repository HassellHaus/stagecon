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
//     });
//     _hoursFocus.addListener(() {
//       if (_hoursFocus.hasFocus) {
//         _hoursController.selection = TextSelection(
//             baseOffset: 0, extentOffset: _hoursController.text.length);
//       }
//     });
//     _minutesFocus.addListener(() {
//       if (_minutesFocus.hasFocus) {
//         _minutesController.selection = TextSelection(
//             baseOffset: 0, extentOffset: _minutesController.text.length);
//       }
//     });
//     _secondsFocus.addListener(() {
//       if (_secondsFocus.hasFocus) {
//         _secondsController.selection = TextSelection(
//             baseOffset: 0, extentOffset: _secondsController.text.length);
//       }
//     });
//     _msFocus.addListener(() {
//       if (_msFocus.hasFocus) {
//         _msController.selection = TextSelection(
//             baseOffset: 0, extentOffset: _msController.text.length);
//       }
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
//   value: days,
//   onTap: () {
//     setState(() {
//       _editingDays = !_editingDays;
//     });
//   },
//   controller: _daysController,
//   focusNode: _daysFocusNode,
// ),

//         _buildDigitGroup(controller: _hoursController, focusNode: _hoursFocus),
//         _buildDigitGroup(controller: _minutesController, focusNode: _minutesFocus),
//         _buildDigitGroup(controller: _secondsController, focusNode: _secondsFocus),
//         _buildDigitGroup(controller: _msController, focusNode: _msFocus),
//       ],
//     );
//   }

// Widget _buildDigitGroup({
//   required bool isActive,
//   required int value,
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
//             child: Text(value.toString().padLeft(2, '0')),
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

import 'package:get/get.dart';
import 'package:stagecon/controllers/OscController.dart';
import 'package:stagecon/widgets/TimerDisplay.dart';

class AppEvents {
    OSCcontroler oscCon = Get.find();
    Map<String, TimerDisplay> timers = {

    };
    Map<String, TimerDisplayController> timerControllers = {};

}
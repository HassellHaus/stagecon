import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:stagecon/type_converters.dart';
import 'package:stagecon/types/shared_types.dart';
import 'package:uuid/uuid.dart';

import 'package:json_annotation/json_annotation.dart';
// import 'package:stagecon/types/events/SCEvent.dart';

part 'sc_timer.g.dart';

var _timerBox = Hive.box<ScTimer>("timers");
var _preferences = Hive.box("preferences");

enum TimerEventOperation { set, reset, start, stop, delete, format }

@HiveType(typeId: 2)
enum TimerMode {
  @HiveField(0)
  countdown,
  @HiveField(1)
  stopwatch
}

@JsonSerializable()
@HiveType(typeId: 1)
class ScTimer {
  @HiveField(0)
  @JsonKey(includeFromJson: true, includeToJson: true, name: "running")
  bool _running = false;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get running => _running;
  set running(bool value) {
    if (!value && _running) {
      // if we are pausing the timer
      //get current duration
      startingAt = currentDuration;
    } else if (value && !_running) {
      // resuming
      //set the epoch time
      epochTime = DateTime.timestamp();
    }
    _running = value;
  }

  @HiveField(1)
  @DurationConverter()
  late Duration _initialStartingAt;
  Duration get initialStartingAt => _initialStartingAt;
  set initialStartingAt(Duration value) {
    _initialStartingAt = value;
    startingAt = value;
  }

  @HiveField(10)
  @DurationConverter()
  late Duration startingAt; // this will change when the timer is paused and resumed

  //calculates the current duration based on the epoch time
  Duration get currentDuration {
    if (!running) {
      return startingAt;
    }
    if (mode == TimerMode.stopwatch) {
      return startingAt + DateTime.now().difference(epochTime);
    } else {
      var duration = startingAt - DateTime.now().difference(epochTime);
      if (duration.isNegative) {
        return Duration.zero;
      } else {
        return duration;
      }
    }
  }

  @HiveField(2)
  TimerMode mode;

  // = _preferences.get("default_ms_precision", defaultValue: 3);

  // final Map<String, dynamic> extraData = {};
  @HiveField(3)
  @ColorConverter()
  Color color = const Color(0xffffffff);

  @HiveField(4)
  late String id;

  @HiveField(5)
  late DateTime createdAt;
  @HiveField(11)
  late DateTime epochTime; //  epoch time for when the timer was started or paused

  @HiveField(6)
  DateTime? expiresAt; // will never expire. must be removed manually

  @HiveField(7)
  bool expired = false;

  @HiveField(8)
  int? msPrecision; // if null use default

  @HiveField(9)
  int? flashRate; // if null then use default

  // @HiveField(10)
  // @DurationConverter()
  // Duration pause;

  @HiveField(12, defaultValue: false)
  final bool fromRemote;

  final String type = "timer";

  ScTimer(
      {bool running = false,
      Duration initialStartingAt = const Duration(),
      this.msPrecision,
      this.flashRate,
      this.fromRemote = false,
      this.mode = TimerMode.countdown,
      this.color = const Color(0xffffffff),
      String? id,
      DateTime? createdAt}) {
    this.id = id ?? const Uuid().v4();
    this.createdAt = createdAt ?? DateTime.timestamp();
    epochTime = this.createdAt;
    this.running = running;
    _initialStartingAt = initialStartingAt;
  }

  factory ScTimer.fromJson(Map<String, dynamic> json) => _$ScTimerFromJson(json);

  Map<String, dynamic> toJson() => _$ScTimerToJson(this);

  String get dbId => "${fromRemote ? "remote" : "local"}_$id";

  Future<void> upsert() async {
    await _timerBox.put(dbId, this);
    // notifyListeners();
  }

  static ScTimer? get(String id) {
    return _timerBox.get(id);
  }

  static Future<void> delete(String id) {
    return _timerBox.delete(id);
  }

  static void deleteAll() {
    _timerBox.clear();
  }

  ///Deletes all the timers that were created from a remote source
  static Future<List<void>> deleteAllRemote() {
    return Future.wait(_timerBox.values.where((element) => element.fromRemote).map((element) {
      return ScTimer.delete(element.dbId);
    }));
  }

  void reset() {
    epochTime = DateTime.timestamp();
    startingAt = initialStartingAt;
  }

  //
  // void from(ScEventInterface event) {
  //   if(event.type != type) throw Exception("Cannot convert ${event.type} to ${this.type}");
  //   event as ScTimerEvent;
  //   id = event.id;
  //   createdAt = event.createdAt;
  //   expiresAt = event.expiresAt;
  //   running = event.running;
  //   startingAt = event.startingAt;
  //   expired = event.expired;
  //   color = event.color;
  // }
}

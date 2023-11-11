import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color object) => object.value;
}

class DurationConverter implements JsonConverter<Duration, int> {
  const DurationConverter();

  @override
  Duration fromJson(int json) => Duration(microseconds: json);

  @override
  int toJson(Duration object) => object.inMicroseconds;
}

class HiveDurationAdapter extends TypeAdapter<Duration> {
  @override
  final typeId = 3;

  @override
  Duration read(BinaryReader reader) {
    return Duration(microseconds: reader.read());
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.write(obj.inMicroseconds);
  }
}

class HiveColorAdapter extends TypeAdapter<Color> {
  @override
  final typeId = 4;

  @override
  Color read(BinaryReader reader) {
    return Color(reader.read());
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.write(obj.value);
  }
}
import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stagecon/type_converters.dart';
import 'package:uuid/uuid.dart';

part 'sc_cuelight.g.dart';

var _cuelightBox = Hive.box<ScCueLight>("cuelights");


@HiveType(typeId: 6)
enum CueLightState {
    @HiveField(0)
  inactive,
    @HiveField(1)
  standby,
    @HiveField(2)
  acknowledged,
    @HiveField(3)
  active,
}

@JsonSerializable()
@HiveType(typeId: 5)
class ScCueLight {

  @HiveField(0)
  late String id;
  @HiveField(1)
  late DateTime createdAt; 



  @HiveField(2)
  @ColorConverter()
  Color color;

  @HiveField(3)
  CueLightState state;

  @HiveField(4)
  String? name;

  @HiveField(5)
  bool toggleActive; // if false active will be set to inactive on tap up.  if true it will stay active until the next tap 

  final String type = "cuelight";

  ScCueLight({
    String? id, 
    DateTime? createdAt, 
    required this.color, 
    required this.state, 
    this.name,
    this.toggleActive = false
  }) {
    this.id = id ?? const Uuid().v4();
    this.createdAt = createdAt ?? DateTime.timestamp();
  }


  factory ScCueLight.fromJson(Map<String, dynamic> json) => _$ScCueLightFromJson(json);
  
  Map<String, dynamic> toJson() => _$ScCueLightToJson(this);


  Future<void> upsert() async {
    await _cuelightBox.put(id, this);
    // notifyListeners();
    
  }

  static ScCueLight? get(String id) {
    return _cuelightBox.get(id);
  }

  static void delete(String id) {
    _cuelightBox.delete(id);
  }

  static void deleteAll() {
    _cuelightBox.clear();
  }

  


}
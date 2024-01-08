import 'package:hive/hive.dart';

final _pref = Hive.box("preferences");

///Why do we need this? Because we dont want the ids to conflict if a server sends a client an object with the same id as one it already has in "local" mode
String get dbIdPrefix => "${_pref.get("proxy_client_enabled")?"remote":"local"}_";

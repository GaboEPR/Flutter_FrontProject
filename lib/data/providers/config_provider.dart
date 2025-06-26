import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider extends ChangeNotifier {
  final SharedPreferences prefs;

  ConfigProvider(this.prefs) {
    _loadConfig();
  }

  String? dbEngine;
  String? dbHost;
  String? dbPort;
  String? dbName;
  String? dbUser;
  String? dbPassword;

  bool get isConfigured =>
      dbEngine != null &&
      dbHost != null &&
      dbPort != null &&
      dbName != null &&
      dbUser != null &&
      dbPassword != null;

  void _loadConfig() {
    dbEngine = prefs.getString('dbEngine');
    dbHost = prefs.getString('dbHost');
    dbPort = prefs.getString('dbPort');
    dbName = prefs.getString('dbName');
    dbUser = prefs.getString('dbUser');
    dbPassword = prefs.getString('dbPassword');
  }

  void setDatabaseConfig({
    required String engine,
    required String host,
    required String port,
    required String dbName,
    required String user,
    required String password,
  }) {
    dbEngine = engine;
    dbHost = host;
    dbPort = port;
    this.dbName = dbName;
    dbUser = user;
    dbPassword = password;

    prefs.setString('dbEngine', engine);
    prefs.setString('dbHost', host);
    prefs.setString('dbPort', port);
    prefs.setString('dbName', dbName);
    prefs.setString('dbUser', user);
    prefs.setString('dbPassword', password);

    notifyListeners();
  }

  String get serverUrl =>
      isConfigured ? '$dbEngine://$dbUser:$dbPassword@$dbHost:$dbPort/$dbName' : 'no-config';
}

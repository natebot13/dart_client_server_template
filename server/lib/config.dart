import 'package:injectable/injectable.dart';

abstract class ServerConfig {
  String get firebaseProject;
  String get authHeader => 'auth';
  int get port;
}

@Singleton(as: ServerConfig)
@dev
class DevServerConfig extends ServerConfig {
  @override
  String get firebaseProject => 'localhost';
  @override
  int get port => 45654;
}

@Singleton(as: ServerConfig)
@prod
class ProdServerConfig extends ServerConfig {
  @override
  String get firebaseProject => 'fwish-e4ba9';
  @override
  int get port => 443;
}

import 'package:api/api.dart';
import 'package:grpc/grpc.dart';

class IncrementService extends IncrementServiceBase {
  int _counter = 0;

  @override
  Future<IncrementResponse> increment(
    ServiceCall call,
    IncrementRequest request,
  ) async {
    return IncrementResponse(value: ++_counter);
  }
}

class GameServer {
  final Server _server;
  GameServer._(this._server);

  static Future<GameServer> start({int port = 45654}) async {
    final server = Server.create(services: [
      IncrementService(),
    ]);
    await server.serve(port: port);
    return GameServer._(server);
  }

  Future<void> stop() {
    return _server.shutdown();
  }
}

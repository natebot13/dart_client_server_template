import 'package:api/api.dart';
import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';

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
  static final Logger logger = Logger("GameServer");
  final Server _server;
  GameServer._(this._server);

  static Future<GameServer> start({int port = 45654}) async {
    final server = Server.create(services: [
      IncrementService(),
    ]);
    await server.serve(port: port);
    logger.info("Server started on port: $port");
    return GameServer._(server);
  }

  Future<void> stop() {
    return _server.shutdown();
  }
}

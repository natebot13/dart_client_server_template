import 'package:server/server.dart' as server;

void main(List<String> arguments) async {
  await server.GameServer.start();
}

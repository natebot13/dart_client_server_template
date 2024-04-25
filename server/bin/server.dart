import 'package:logging/logging.dart';
import 'package:server/server.dart' as server;

void main(List<String> arguments) async {
  // Globally set up logging
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  await server.GameServer.start();
}

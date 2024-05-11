import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:server/server.dart';
import 'package:server/injection.dart';

void main(List<String> arguments) async {
  // Globally set up logging
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Configure injections from current environment
  configureInjection(
    String.fromEnvironment('environment', defaultValue: Environment.dev),
  );

  // Start the server
  await ApiServer.start();
}

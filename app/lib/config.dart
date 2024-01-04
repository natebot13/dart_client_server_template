import 'package:api/api.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

abstract class ServerConfig {
  String get address;
  int get port;
  ChannelCredentials get credentials;
}

@Singleton(as: ServerConfig)
@dev
class DevServerConfig extends ServerConfig {
  @override
  String get address => '192.168.86.195';

  @override
  ChannelCredentials get credentials => const ChannelCredentials.insecure();

  @override
  int get port => 45654;
}

@Singleton(as: ServerConfig)
@prod
class RelServerConfig extends ServerConfig {
  @override
  String get address => 'fwish.nathanp.me';

  @override
  ChannelCredentials get credentials => const ChannelCredentials.secure();

  @override
  int get port => 45654;
}

@Singleton(as: ServerConfig)
@test
class TestServerConfig extends ServerConfig {
  @override
  String get address => 'blah';

  @override
  ChannelCredentials get credentials => const ChannelCredentials.secure();

  @override
  int get port => 1337;
}

@module
abstract class ClientProviders {
  @singleton
  ChannelOptions channelOptions(ServerConfig config) {
    return ChannelOptions(credentials: config.credentials);
  }

  @singleton
  ClientChannel channel(ServerConfig config, ChannelOptions options) {
    return ClientChannel(config.address, port: config.port, options: options);
  }

  @singleton
  IncrementServiceClient incrementClient(ClientChannel channel) =>
      IncrementServiceClient(channel);
}

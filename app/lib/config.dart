import 'package:api/api.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
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
  String get address => 'localhost';

  @override
  ChannelCredentials get credentials => const ChannelCredentials.insecure();

  @override
  int get port => 45654;
}

@Singleton(as: ServerConfig)
@prod
class RelServerConfig extends ServerConfig {
  @override
  String get address => '<some-url-here>';

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
  GrpcOrGrpcWebClientChannel channel(
      ServerConfig config, ChannelOptions options) {
    return GrpcOrGrpcWebClientChannel.toSeparatePorts(
      host: config.address,
      grpcPort: 45654,
      grpcWebPort: 9090,
      grpcTransportSecure: options.credentials.isSecure,
      grpcWebTransportSecure: options.credentials.isSecure,
    );
  }

  @singleton
  IncrementServiceClient incrementClient(GrpcOrGrpcWebClientChannel channel) =>
      IncrementServiceClient(channel);
}

import 'package:api/api.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:injectable/injectable.dart';

abstract class ServerConfig {
  String get address;
  int get port;
}

@Singleton(as: ServerConfig)
@dev
class DevServerConfig extends ServerConfig {
  @override
  String get address => 'localhost';

  @override
  int get port => 45654;
}

@Singleton(as: ServerConfig)
@prod
class RelServerConfig extends ServerConfig {
  @override
  String get address => '<some-url-here>';

  @override
  int get port => 45654;
}

@Singleton(as: ServerConfig)
@test
class TestServerConfig extends ServerConfig {
  @override
  String get address => 'blah';

  @override
  int get port => 1337;
}

@module
abstract class ClientProviders {
  @singleton
  GrpcOrGrpcWebClientChannel channel(ServerConfig config) {
    return GrpcOrGrpcWebClientChannel.toSeparatePorts(
      host: config.address,
      grpcPort: 45654,
      grpcWebPort: 9090,
      grpcTransportSecure: true,
      grpcWebTransportSecure: true,
    );
  }

  @singleton
  AuthenticatedServiceClient authenticatedClient(
    GrpcOrGrpcWebClientChannel channel,
  ) {
    return AuthenticatedServiceClient(channel);
  }

  @singleton
  UnauthenticatedServiceClient unauthenticatedClient(
    GrpcOrGrpcWebClientChannel channel,
  ) {
    return UnauthenticatedServiceClient(channel);
  }
}

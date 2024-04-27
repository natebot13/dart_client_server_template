import 'package:api/api.dart';
import 'package:grpc/grpc.dart';
import 'package:server/server.dart';
import 'package:test/test.dart';

void main() {
  final channel = ClientChannel(
    'localhost',
    port: 45654,
    options: ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    ),
  );
  final AuthenticatedServiceClient client = AuthenticatedServiceClient(channel);

  setUpAll(GameServer.start);

  test('increment', () async {
    expect(
      await client.increment(IncrementRequest()),
      IncrementResponse(value: 1),
    );
    expect(
      await client.increment(IncrementRequest()),
      IncrementResponse(value: 2),
    );
  });
}

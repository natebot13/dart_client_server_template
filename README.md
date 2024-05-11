Template for creating a grpc based client server architecture. Supports a collection of features to make development quick and simple. Based on the strongly typed contract of protobufs and rpc services, the code is separated into three parts: api, server, and client. api is where protos are stored, which are shared and intended to be included into the server and client packages. The server implements the service definitions from the rpc protos. Similarly, the client uses the client definitions generated from the services to make calls to the rpc service.

To support both web and mobile clients, this project uses the Envoy proxy server from a Docker container to forward gRPC requests to the server. Requests made to the 

Features:
 - Firebase Cloud Firestore
 - Protobuf
 - gRPC (with http proxy)
 - Flutter
 - Dart
 - Docker (proxy and server container)

# Getting Started

1. Install [Flutter](https://docs.flutter.dev/get-started/install)
2. Install [firebase-tools](https://firebase.google.com/docs/cli)
3. Install docker (Needed for the http gRPC proxy. Not needed for mobile app development)
4. Setup your environment:
     - `dart pub global activate melos`
     - `dart pub global activate protofu`
     - `dart pub global activate flutterfire`
5. Then:
	1. `melos bootstrap`
	2. `melos build`
	3. `flutterfire configure`
	4. 

Use `melos build` to run the code generation step.

# Features:
 - Client side testing
 - Server side testing
 - Shared protobuf definitions
 - Dependency Injection

# Troubleshooting
If you're getting something like:
```
Error: gRPC Error (code: 2, codeName: UNKNOWN, message: HTTP request completed without a status (potential CORS issue), details: null, rawResponse: , trailers: {})
```
Ensure that the envoy docker container is running on the right port, and that port is exposed and forwarded to the host system.

Also, ensure that any additional headers you add to requests are included in envoys allowed list of headers for the cors policy.

Also ensure the certs are installed properly. `mkcert` highly recommended
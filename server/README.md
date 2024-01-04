A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

Local development requires a collection of servers to be running:
 - `dart server/bin/server.dart` (or just use the VS Coder server task)
 - `docker-compose up`
 - `firebase emulators:start`

In production, IDK, I haven't gotten that far.
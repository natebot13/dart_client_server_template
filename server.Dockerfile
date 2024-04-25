FROM dart:stable AS build

# Copy the API
# Assumes protoc has generated the files
WORKDIR /project/api
COPY api/pubspec.* .
COPY api/lib lib
RUN dart pub get

# Copy the pubspec of the server
WORKDIR /project/server
COPY server/pubspec.* .
COPY server/lib lib
COPY server/bin bin
RUN dart pub get
RUN dart compile exe bin/server.dart -o bin/server

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /project/server/bin/server /bin/server

EXPOSE 45654
CMD [ "/bin/server" ]
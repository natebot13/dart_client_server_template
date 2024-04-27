FROM envoyproxy/envoy-alpine:v1.21-latest
RUN apk --no-cache add ca-certificates
COPY ./envoy.yaml /etc/envoy/envoy.yaml
COPY key.pem certs/serverkey.pem
COPY cert.pem certs/servercert.pem
CMD /usr/local/bin/envoy -c /etc/envoy/envoy.yaml
FROM ekidd/rust-musl-builder AS builder
RUN git clone --depth 1 https://github.com/iovxw/rssbot.git .
RUN sudo chown -R rust:rust /home/rust
RUN rustup target add x86_64-unknown-linux-musl
RUN cargo build --release
FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder \
    /home/rust/src/target/x86_64-unknown-linux-musl/release/rssbot \
    /usr/local/bin/
ENV DATAFILE="/rustrssbot/rssdata.json"
ENV TELEGRAM_BOT_TOKEN=""
VOLUME /rustrssbot
ENTRYPOINT /usr/local/bin/rssbot $DATAFILE $TELEGRAM_BOT_TOKEN
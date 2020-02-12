FROM debian:9.11-slim as base

RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends \
        curl \
        ca-certificates

FROM base as go
RUN curl --proto '=https' -sSf \
            https://dl.google.com/go/go1.13.7.linux-amd64.tar.gz > go.tar.gz \
        && tar -C /usr/local -xzf go.tar.gz

FROM base as rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh \
        && bash rustup.sh -y --profile minimal

FROM base

COPY --from=rust /root/.cargo/ /root/.cargo/
COPY --from=rust /root/.rustup/ /root/.rustup/
COPY --from=go /usr/local/go/ /usr/local/go/

ENV PATH "/usr/local/go/bin:/root/.cargo/bin:$PATH"

FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    ant \
    openjfx \
    libopenjfx-java \
    openjdk-11-jdk \
    libmediainfo0v5 \
    libchromaprint-tools \
    libzen0v5 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .

RUN chmod +x ./download_deps.sh && ./download_deps.sh
RUN mkdir -p lib && touch lib/src.excludes lib/jar.includes
RUN echo "jfx.path=/usr/share/openjfx/lib" > profile.properties
RUN ant jar

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    openjdk-11-jre \
    libmediainfo0v5 \
    libchromaprint-tools \
    libzen0v5 \
    openjfx \
    libopenjfx-java \
    && rm -rf /var/lib/apt/lists/*

# Copy the built application and its dependencies
COPY --from=builder /src/dist/ /app/dist/
COPY --from=builder /src/data/ /app/data/
COPY --from=builder /src/filebot.sh /app/filebot.sh

RUN chmod +x /app/filebot.sh

# Provide an entrypoint
ENTRYPOINT ["/app/filebot.sh"]

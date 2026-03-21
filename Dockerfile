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
COPY dist/ /app/dist/
COPY data/ /app/data/
COPY filebot.sh /app/filebot.sh

RUN chmod +x /app/filebot.sh

# Provide an entrypoint
ENTRYPOINT ["/app/filebot.sh"]

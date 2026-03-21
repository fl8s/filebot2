# FileBot

The FileBot source code is available for your convenience:

* You may view the source code and learn from it.
* You may build FileBot for private use on unsupported platforms.
* You may NOT use the source code to publish binary builds without explicit authorization.

Please respect the author that is kindly making the source code available under the [MODIFIED DON'T BE A DICK PUBLIC LICENSE](https://github.com/filebot/filebot/blob/master/LICENSE.md).

## Build and Setup

### Prerequisites

You need `ant` to build this project:
```bash
sudo apt-get install ant
```

### Download Dependencies

Before building, make sure you download the required `.jar` and native dependencies:
```bash
./download_deps.sh
```

### Compile

To build the executable jar file:
```bash
ant jar
```

## Configuration

You must create a `.env` file to provide your own media DB API keys.
```bash
cp .env.example .env
# Edit .env and add your valid keys
```

## Docker

A `Dockerfile` is provided to build an Ubuntu 22.04 image with Java 11, `openjfx`, `mediainfo`, and `chromaprint` pre-installed to run the FileBot CLI seamlessly without worrying about dependencies on modern Linux distributions.

```bash
docker build -t filebot .
```

### Running the container

You can mount your media directory into the container to organize your files:

```bash
docker run --rm \
    --env-file .env \
    -v /path/to/your/media:/media \
    filebot -rename /media/input --output /media/output --format "{n} - {y}" --db TheMovieDB -non-strict
```

## End-to-End Tests

An automated E2E test script is provided (`test_e2e.sh`). This script verifies the full pipeline:
1. Verifies `.env` exists and contains API keys
2. Builds the Docker container
3. Sets up dummy mock files (`The.Matrix.1999.mp4`)
4. Runs the FileBot CLI via the Docker container pointing to TheMovieDB
5. Verifies the output filename matches the metadata exactly.

```bash
./test_e2e.sh
```

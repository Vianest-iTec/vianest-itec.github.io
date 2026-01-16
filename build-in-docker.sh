#!/bin/sh
set -e

if command -v pwd >/dev/null 2>&1 && pwd -W >/dev/null 2>&1; then
  # Git Bash / Windows
  HOST_PWD="$(pwd -W)"
else
  # Linux / WSL / macOS
  HOST_PWD="$(pwd)"
fi

if [ -z "$1" ]; then
  docker pull jekyll/builder:pages
  docker run -it --rm \
    --workdir /srv/jekyll \
    --volume "$HOST_PWD:/srv/jekyll" \
    --volume "$HOST_PWD/vendor/bundle:/usr/local/bundle" \
    --publish 4000:4000 \
    --publish 4001:4001 \
    jekyll/builder:pages \
    ./build-in-docker.sh build
else
  bundle install --jobs=4
  bundle exec jekyll serve \
    -H 0.0.0.0 \
    --trace \
    --watch \
    --force_polling \
    --livereload \
    --livereload-port 4001
fi

#!/bin/sh
set -e

if pwd -W >/dev/null 2>&1; then
  # Git Bash / Windows
  HOST_PWD="$(pwd -W)"
  export MSYS_NO_PATHCONV=1
  export MSYS2_ARG_CONV_EXCL="*"
else
  # Linux / WSL / macOS
  HOST_PWD="$(pwd)"
fi

mkdir -p vendor/bundle

if [ -z "$1" ]; then
  docker pull jekyll/builder:4

  docker run -it --rm \
    --entrypoint "" \
    --workdir /srv/jekyll \
    --volume "$HOST_PWD:/srv/jekyll" \
    --volume "$HOST_PWD/vendor/bundle:/usr/local/bundle" \
    --publish 4000:4000 \
    --publish 4001:4001 \
    jekyll/builder:4 \
    sh ./build-in-docker.sh build
else
  set -x

  bundle install \
    --jobs=4 \
    --retry=3 \
    --verbose

  bundle exec jekyll serve \
    -H 0.0.0.0 \
    --trace \
    --watch \
    --force_polling \
    --livereload \
    --livereload-port 4001
fi

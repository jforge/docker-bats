# BATS (bash automated testing system)

[![Build Status](https://img.shields.io/travis/jforge/docker-bats/master.svg)](https://travis-ci.org/jforge/docker-bats)
[![Docker Pulls](https://img.shields.io/docker/pulls/jforge/bats.svg)](https://hub.docker.com/r/jforge/bats/)
[![Image Size](https://images.microbadger.com/badges/image/jforge/bats.svg)](https://microbadger.com/images/jforge/bats)

This is a docker image containing [bats](https://github.com/sstephenson/bats) and a few other useful bits:
 * [jq](https://stedolan.github.io/jq/), make, curl, docker, git, bc

## Usage

```bash
docker run --rm -v $(pwd):/app jforge/bats /app/tests
```

## Usage with docker

To be able to run docker commands within this container you need to mount the docker sock:

```bash
docker run --rm \
    -v $(pwd):/app \
    -v /var/run/docker.sock:/var/run/docker.sock \
    jforge/bats /app/tests
```

```sh
@test "entrypoint is bats" {
  run bash -c "docker inspect jforge/bats:$tag | jq -r '.[].Config.Entrypoint[]'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "/usr/local/bin/bats" ]
}
```

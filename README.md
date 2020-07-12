# prantlf/git-p4

[Docker] image: [Git], [Perforce] and [git-p4] clients for synchronizing source repositories on Alpine Linux

[![prantlf/git-p4](http://dockeri.co/image/prantlf/git-p4)](https://hub.docker.com/repository/docker/prantlf/git-p4/)

[This image] is supposed to manage sources in [Perforce] using [Git] interface with the help of [git-p4]. Tools `git` and `p4` are available to be used separately, of course. This image is built automatically on the top of the tag `latest` from the [Alpine repository], so that it is always based on the latest [Alpine Linux]. [Git] has to be updated from time to time by triggering a new build manually. [Perforce] and [git-p4] have to updated in the `Dockerfile`.

`git-p4` is a convenient way how to sync sources from Perforce without creating a Perforce client and dealing with read-only files created by `p4`:

* Clone the project sources `git p4 clone //projects/first`.
* Update the sources by `git p4 sync && git p4 rebase`.
* Use local `git` commands to modify the branch `master`.
* Push changes to the repository by `git p4 submit`.

## Tags

- [`latest`]

## Install

```
docker pull prantlf/git-p4
```

## Use

You can run `git`, `p4` and `git-p4` commands with `docker` mapping the current directory as the working directory:

    GITP4="docker run --rm -it -v ""${PWD}"":/app -w /app prantlf/git-p4"
    $GITP4 git
    $GITP4 p4
    $GITP4 git p4

Perforce client needs a server connection and credentials to a Perforce server. They are usually available in the environment, from where you can pass them to the docker container:

    docker run --rm -it -v "${PWD}":/app -w /app \
      -e P4PORT -e P4USER -e P4PASSWD prantlf/git-p4 \
      git p4 clone //projects/first

You can pass the environment variable values on the command line too:

    docker run --rm -it -v "${PWD}":/app -w /app \
      -e P4PORT=myperforce:1666 -e P4USER=myself prantlf/git-p4 \
      p4 login && git p4 sync

Or you can supply them from a file:

    docker run --rm -it -v "${PWD}":/app -w /app \
      --env-file ~/p4env prantlf/git-p4 \
      git p4 submit

If you omit the environment variable with the Perforce password, you will need either to log in on the command  line, or to provide the Perforce `.p4tickets` file in a user home directory mapped via the volume `/root`, or to retain the container where you logged in once and continue use it instead of having it constantly re-created.

    # Authenticate and create .p4enviro and .p4tickets in the curent directory.
    docker run --rm -it -v "${PWD}":/app -w /app -v "${PWD}":/root \
      -e P4PORT=myperforce:1666 -e P4USER=myself prantlf/git-p4 \
      p4 login
    # Use the suthentication file in the current directory to clone a repository
    # to a subdirectory in the current directory.
    docker run --rm -it -v "${PWD}":/app -w /app -v "${PWD}":/root \
      -e P4PORT=myperforce:1666 -e P4USER=myself prantlf/git-p4 \
      git p4 clone //projects/first

    # Create an authenticated container.
    docker run --name myp4 -it -v "${PWD}":/app -w /app \
      -e P4PORT=myperforce:1666 -e P4USER=myself prantlf/git-p4 \
      p4 login
    # Start the authenticated container, sync sources and stop the container.
    docker start myp4
    docker exec myp4 git p4 sync
    docker stop myp4

### Gotchas

If you want to submit changes to Perforce, you will need to create a (separate) Perforce client for the depot that you cloned by `git-p4`. It will be used by `git p4 submit`, which you will supply it by an environment variable: `P4CLIENT=myclient`, for example.

The git repository created by `git p4 clone` is not to share with the others freely, so that they would maintain their `master` branches, marge occasionally from you and you merge from them. When you pull from Perforce, you will rebase your local commits on it. If you shared them with somebody, their hashes will differ after the rebase and you will nto be able to merge them using the common parent. Every developer should maintain their own `git-p4` clone, or you can use `git format-patch` and `git apply` to share local changes outside Perforce.

The repository maintained by `git-p4` will get slow after some time. I suspect that as the history grows, the costs of applying `p4` and `git` commands on the source tree grow as well. Maybe it is not as efficient as a pure Git repository management. The workaround is to delete the repository clone and clone the Perforce depot by `git p4` again. It will start with a clean history in the full speed again.

## Build, Test and Publish

The local image is built as `git-p4` and pushed to the docker hub as `prantlf/git-p4:latest`.

Remove an old local image:

    make clean

Check the `Dockerfile`:

    make lint

Build a new local image:

    make build

Enter an interactive shell inside the created image:

    make run

Tag the local image for pushing:

    make tag

Login to the docker hub:

    make login

Push the local image to the docker hub:

    make push

## License

Copyright (c) 2020 Ferdinand Prantl

Licensed under the MIT license.

[Docker]: https://www.docker.com/
[This image]: https://hub.docker.com/repository/docker/prantlf/git-p4
[`latest`]: https://hub.docker.com/repository/docker/prantlf/git-p4/tags
[Perforce]: https://www.perforce.com/products/helix-core
[Git]: https://git-scm.com/
[git-p4]: https://git-scm.com/docs/git-p4
[Alpine repository]: https://hub.docker.com/_/alpine
[Alpine Linux]: https://alpinelinux.org/

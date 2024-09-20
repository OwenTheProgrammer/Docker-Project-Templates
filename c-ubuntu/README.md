# C Ubuntu

This project defines a docker environment that automatically compiles any change made in `src/` or `include/`

This handles:
- File and directory permission problems with root containers
- Common "I won't define every c/h file individually but also hate advanced makefile patterns" structure
- Having to re-save `main.c` for compiler errors to go away
- Release structure for both docker scratch image and tar.gz

There is a `PROJECT_ARG` build argument that lets you change the name of the project folder internally. Default is "proj"
There is a `WATCHEXEC_TARGET` build argument that lets you change the target github branch of watchexec. Default is [v2.1.2](https://github.com/watchexec/watchexec/releases/tag/v2.1.2)

## Development (Watchexec)

The following stages compile and use [watchexec](https://github.com/watchexec/watchexec) from within the container. This paired with a bind-mount of your projects directory allows for automatic recompilation on file changes.

### Just do it. (Compose)

To have everything handled in a single compose:
```bash
docker compose up --build
```

To shutdown the composition:
```bash
docker compose down
```

### Building the image:
If you want to build the image manually:
```bash
docker build --target dev -t TAG:VERSION .
```
To run the built image:
```bash
docker run -it --rm -v .:/home/ubuntu TAG:VERSION
```

## Development (No watchexec)
Don't like watchexec? Just want to have a compiler with a shell? I getcha'

To build without watchexec:
```bash
docker build --target dev-nowatch -t TAG:VERSION .
```
And running is the same as above.

## Building for release

Once your project is complete (congrats :heart:)

### Standard build:
To build and enter with shell:
```bash
docker build --target build-release -t TAG:VERSION .
docker run -it --rm TAG:VERSION
```

### Build for other images:
To build so other images can copy from this image:
```bash
docker build --target build-scratch -t TAG:VERSION .
```

Then some other docker image can use it with:
```dockerfile
FROM something AS layer
COPY --from=TAG:VERSION . /path/to/destination
...
```

### Build for binary export:
Just want the damn files? Me too.

To get the binary data as a directory:
```bash
# This will export 
# - PROJECT_NAME/bin/
# - PROJECT_NAME/include/
docker build --target build-scratch --output=. .
```

To get the binary data as a tar.gz:
```bash
# This will export: proj.tar.gz
docker build --build-arg PROJECT_NAME=proj --target bundle-scratch --output=. .
```
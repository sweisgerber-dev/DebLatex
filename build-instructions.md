# Usage

## Build

```
./build.sh
```

or

```
docker build -t deblatex:buster .
```

## Run

```
docker run -ti \
    --hostname DebLatex \
    --volume /PATH/ON/HOST:/workspace \
    -e LOCAL_USER_ID=`id -u $USER` \
    -e LOCAL_GROUP_ID=`id -g $USER` \
    deblatex:buster
```

## Create an index of word occurrences from a given set of text files

#### 1. Create the folder `in/` at Root, and put any text file(s) in it.

#### 2. Build the image:

```shell
docker build -t mabo3n/poc-hadoop:0.5 .
```

#### 3. Run it

```shell
docker run -it -p 80:80 mabo3n/poc-hadoop:0.5
```

The container will set up and start the MapReduce job with your files inside `in/` as the input.

After completing the Job, the results can be viewed by typing:

```shell
$OUTPUT | less
```

( *k* / *j* to go up / down, *q* to quit. )

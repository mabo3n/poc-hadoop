# Description

This app reads provided text files and create a single index file listing all word occurrences in the files.

**Input**: any text(s) file(s).

**Output**: A single file with the following format.

```
word1
>someFile.txt position1 position2 position3 ...
>anotherFile.txt position1 position2 position3 ...
```

<details> <summary> <i> See example input/output </i> </summary>

Input (*in/text.txt*):

```
aaa aab aac

aab aac aad

aac aad aae

```

Output (*out/part-r-00000*):

```
aaa	
>test.txt 0
aab	
>test.txt 13 0
aac	
>test.txt 26 13 0
aad	
>test.txt 26 13
aae	
>test.txt 26

```

</details>


# Prerequisites 

* [docker](https://www.docker.com/) installed
* Any text(s) file(s)!

# Usage 

**1. Assure your are in this project's *root* directory**

**2. Put your input text file(s) inside the `in/` folder**

**3. Run the following command to build an docker image from the Dockerfile**

```shell
docker build -t mabo3n/word-indexer:1.0 .
```

Note that this may take a while to complete in its first execution. Docker has to download everything to cache in your machine.

**4. Run the built image with the following command**

```shell
docker run -it --rm -v $(pwd)/in:/app/in -v $(pwd)/out:/app/out -p 80:80 mabo3n/word-indexer:1.0
```

A docker container will set up and start a MapReduce job with your files inside `in/` as the input.

After completing the Job, the output file can be found in the `out/` directory, named `part-r-00000`. 

The shell from which the the commands above were executed will also connect to the container's [bash](https://www.gnu.org/software/bash/), in which the Job's output can also be interactively viewed with the folling command:

```shell
$OUTPUT | less
```

*(navigation: k/j to go up/down, q to quit)*

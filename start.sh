# Start hadoop with default configuration
/etc/bootstrap.sh

# Sleep for a while to allow hadoop do initialize
sleep 4

# Leave hadoop's safe mode manually if it is still on
$HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave

# Copy input files to HDFS
$HADOOP_PREFIX/bin/hdfs dfs -mkdir in/ && \
$HADOOP_PREFIX/bin/hdfs dfs -copyFromLocal /app/in/* in/

# Add Hadoop bin's folder to PATH
export PATH=$PATH\
:$HADOOP_PREFIX/bin\
:$HADOOP_PREFIX/share/hadoop/commom\
:$HADOOP_PREFIX/share/hadoop/commom/lib\
:$HADOOP_PREFIX/share/hadoop/mapreduce

# Go to to the app's directory
cd /app/

# Add exec permission to required files
chmod +x $HADOOP_PREFIX/share/hadoop/common/hadoop-common-2.7.1.jar
chmod +x $HADOOP_PREFIX/share/hadoop/mapreduce/hadoop-mapreduce-client-core-2.7.1.jar
chmod +x $HADOOP_PREFIX/share/hadoop/common/lib/commons-cli-1.2.jar
chmod 777 WordCount.java

# Compile source files
HADOOP_COMPILE_LIBS=\
$HADOOP_PREFIX/share/hadoop/common/hadoop-common-2.7.1.jar:\
$HADOOP_PREFIX/share/hadoop/common/lib/commons-cli-1.2.jar:\
$HADOOP_PREFIX/share/hadoop/mapreduce/hadoop-mapreduce-client-core-2.7.1.jar
export HADOOP_COMPILE_LIBS

javac -cp .:$HADOOP_COMPILE_LIBS WordCount.java

# Generate the bytecode
jar cvf wc.jar WordCount*.class

# Run MapReduce
hadoop jar wc.jar WordCount in/ out/

# Set alias for quick accessing the MapReduce's output
OUTPUT="hadoop fs -cat ./out/part-r-00000"
export OUTPUT

# Run bash
/bin/bash

# Start hadoop with default configuration
/etc/bootstrap.sh

# Sleep for a while to allow hadoop do initialize
sleep 4

# Leave hadoop's safe mode manually if it is still on
$HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave

# Copy input files to HDFS
$HADOOP_PREFIX/bin/hdfs dfs -mkdir in/ && \
$HADOOP_PREFIX/bin/hdfs dfs -copyFromLocal /app/test/in/* in/

# Add exec permission to required files
chmod +x $HADOOP_PREFIX/share/hadoop/common/hadoop-common-2.7.1.jar
chmod +x $HADOOP_PREFIX/share/hadoop/mapreduce/hadoop-mapreduce-client-core-2.7.1.jar
chmod +x $HADOOP_PREFIX/share/hadoop/common/lib/commons-cli-1.2.jar
chmod +x /app/test/WordCount.java

# Compile source files
HADOOP_BUILD_LIBS=\
$HADOOP_PREFIX/share/hadoop/common/hadoop-common-2.7.1.jar:\
$HADOOP_PREFIX/share/hadoop/mapreduce/hadoop-mapreduce-client-core-2.7.1.jar:\
$HADOOP_PREFIX/share/hadoop/common/lib/commons-cli-1.2.jar:
export HADOOP_BUILD_LIBS

javac -cp $HADOOP_BUILD_LIBS /app/test/WordCount.java

# Generate the bytecode
jar cf /app/test/wc.jar /app/test/WordCount*.class

# Run MapReduce
# $HADOOP_PREFIX/bin/hadoop jar /app/test/wc.jar ./in ./out

# Set alias for quick accessing the MapReduce's output
# OUTPUT="$HADOOP_PREFIX/bin/hadoop fs -cat ./out/part-r-00000"
# export OUTPUT

# Run bash
/bin/bash

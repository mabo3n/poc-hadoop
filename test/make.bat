set HADOOP_HOME=C:\SDK\hadoop-3.1.1
javac -cp %HADOOP_HOME%\share\hadoop\common\hadoop-common-3.1.1.jar;%HADOOP_HOME%\share\hadoop\mapreduce\hadoop-mapreduce-client-core-3.1.1.jar;%HADOOP_HOME%\share\hadoop\common\lib\commons-cli-1.2.jar WordCount.java
jar cf wc.jar WordCount*.class
pause
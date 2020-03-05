FROM sequenceiq/hadoop-docker:2.7.1

# Install newer version of java
RUN yum install -y java-1.8.0-openjdk ; yum clean all
RUN yum install -y java-1.8.0-openjdk-devel ; yum clean all

# Remove java older version's binaries from PATH
# RUN PATH=$(echo "$PATH" | sed -e 's/:\/usr\/java\/default\/bin$//')
# Set the correct one
# ENV JAVA_HOME /usr/lib/jvm/java-1.8.0
# ENV PATH $PATH:$JAVA_HOME/bin/

# Replace default java folder with newer version' contents
RUN rm -r /usr/java/default
RUN cp -r /usr/lib/jvm/java-1.8.0 /usr/java/default

# Copy project files to /app
RUN mkdir app
COPY . app/

# Run startup script
CMD /app/start.sh

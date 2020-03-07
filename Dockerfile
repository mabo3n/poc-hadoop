FROM sequenceiq/hadoop-docker:2.7.1

# Install newer version of java
RUN yum install -y java-1.8.0-openjdk ; yum clean all
RUN yum install -y java-1.8.0-openjdk-devel ; yum clean all

# Replace default java folder with newer version' contents
RUN rm -r /usr/java/default
RUN cp -r /usr/lib/jvm/java-1.8.0 /usr/java/default

# Create app directories
RUN mkdir app
RUN mkdir app/in
RUN mkdir app/out

# Copy src files to /app/
COPY start.sh app/
COPY WordIndexer.java app/

# Create mount points for input/output directories
VOLUME app/in
VOLUME app/out

# Expose port to allow external connection
EXPOSE 80

# Run startup script
CMD /app/start.sh

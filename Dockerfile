FROM sequenceiq/hadoop-docker:2.7.1

# Install newer version of java
RUN yum install -y java-1.8.0-openjdk ; yum clean all
RUN yum install -y java-1.8.0-openjdk-devel ; yum clean all

# Replace default java folder with newer version' contents
RUN rm -r /usr/java/default
RUN cp -r /usr/lib/jvm/java-1.8.0 /usr/java/default

# Copy project files to /app
RUN mkdir app
COPY . app/

# Expose port to allow external connection
EXPOSE 80

# Run startup script
CMD /app/start.sh

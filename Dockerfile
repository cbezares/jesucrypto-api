FROM phusion/passenger-ruby24

# Set correct environment variables
ENV HOME /root
ENV APP_HOME /home/app/webapp

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# PG Client
RUN apt-get update && apt-get install -y postgresql-client-9.5

# Workdir for bundle and bower
WORKDIR /home/app/webapp/

# Add files
ADD . /home/app/webapp/

# Change /home/app/webapp owner to user app
RUN chown -R app:app /home/app/webapp/

# Enable ssh and insecure key permanently (development)
RUN rm -f /etc/service/sshd/down
RUN /usr/sbin/enable_insecure_key

# Add init scripts
ADD docker/my_init.d/*.sh /etc/my_init.d/

# Ensure premissions to execute and Unix newlines
RUN chmod +x /etc/my_init.d/*.sh && sed -i 's/\r$//' /etc/my_init.d/*.sh

# Ensure permission to execute and Unix newlines on bin files
#RUN chmod +x /home/app/webapp/bin/* && sed -i 's/\r$//' /home/app/webapp/bin/*

# Clean up APT when done
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*
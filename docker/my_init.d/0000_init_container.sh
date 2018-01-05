#!/bin/bash

enable_nginx () {

  # Preserve environment variables
  # https://github.com/phusion/passenger-docker#setting-environment-variables-in-nginx
  if [ ! -f /etc/nginx/main.d/app-env.conf ]; then
    echo "Setting environment variables for nginx..."
    cp /home/app/webapp/docker/services/app/nginx/app-env.conf /etc/nginx/main.d/
  fi

  # Enable Nginx
  # https://github.com/phusion/passenger-docker#using-nginx-and-passenger
  if [ ! -f /etc/nginx/sites-enabled/app.conf ]; then
      echo "Enabling nginx..."
      rm -f /etc/service/nginx/down
      rm /etc/nginx/sites-enabled/default
      cp /home/app/webapp/docker/services/app/nginx/app.conf /etc/nginx/sites-enabled/
  fi
}

install_ruby_gems () {
  # Bundle install only if dependencies are not satisfied
  echo "Installing ruby gems..."
  bundle check || bundle install --jobs 4 --retry 6
}


################################################
# PRODUCTION ENVIRONMENT
################################################
if [ "$ENV" = "production" ]
then

  if [ "$SERVICE" = "app" ]
  then
    # Do something
    echo "Init app..."
    enable_nginx

  else
    echo "Unknown service"
  fi

################################################
# DEVELOPMENT ENVIRONMENT
################################################
elif [ "$ENV" = "development" ]
then

  if [ "$SERVICE" = "app" ]
  then
    # Do something
    echo "Init app..."
    install_ruby_gems
    #setup_backups

    # Ok
    echo "################################"
    echo "#                              #"
    echo "#    APP CONTAINER IS READY    #"
    echo "#                              #"
    echo "################################"
    echo "User: $USER"
    echo "Home: $HOME"
  else
    echo "Unknown service"
  fi

else
  echo "Unknown environment"
fi

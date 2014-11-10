#!/bin/bash
NAME=yod-setup
YOD_HOME=/$NAME
PROJECT_NAME=${PROJECT_NAME:-default}
DOCKER_HOST=${DOCKER_HOST:-}
ACTION=${1:-make}

if [ ! -e "/docker.sock" ] ; then
    echo "You must map your Docker socket to /docker.sock (i.e. -v /var/run/docker.sock:/docker.sock)"
    exit 1
fi

function cleanup {
	echo "
	Removing yod development image..."
 	docker -H unix:///docker.sock rmi -f yod:dev 2>/dev/null
}

function clean_garbage {
	# clean old images left behind
	docker -H unix:///docker.sock rmi `docker -H unix:///docker.sock images -q -f dangling=true` >&- 2>&-
}

function add_scripts () {
  mkdir -p /scripts >/dev/null && \
  cp -f $YOD_HOME/scripts/* /scripts/ >/dev/null
}

function add_user () {
  groupadd -f --gid $GID developer >/dev/null && \
  adduser --system --home $YOD_HOME/$PROJECT_NAME --shell /bin/bash --disabled-password --disabled-login --uid $UID --gid $GID developer >/dev/null && \
  chown -R $UID:$GID $YOD_HOME >/dev/null
}

if [ "$ACTION" == "make" ] ; then

  add_user
  add_scripts

  # create node related directories
  # enter shared directory and execute yeoman
  echo "
  Loading yeoman. Please wait...
  "
  mkdir -p /usr/local/{share/man,bin,lib/node,lib/node_modules,include/node} 2>/dev/null && \
  chown -R $UID /usr/local/{share/man,bin,lib/node,lib/node_modules,include/node} && \
  cd /root && npm install -g bower >/dev/null && cd $HOME # fix bower installation
  su developer -c "mkdir -p $YOD_HOME/$PROJECT_NAME/.config/configstore && mkdir -p $YOD_HOME/.config/configstore && \
  cp -R $YOD_HOME/.config/configstore $YOD_HOME/$PROJECT_NAME/.config/ && \
  cd $YOD_HOME/$PROJECT_NAME && yo && cp -R .config/configstore/* $YOD_HOME/.config/configstore/"
  su developer -c "sed -i 's|UID|'$UID'|g' $YOD_HOME/Dockerfile && \
  sed -i 's|GID|'$GID'|g' $YOD_HOME/Dockerfile"
  # copying node dependencies for project docker image
  mkdir -p $YOD_HOME/usr/local/{share/man,bin,lib/node,lib/node_modules,include/node} && \
  cp -R /usr/local/share/man $YOD_HOME/usr/local/share/man && \
  cp -R /usr/local/bin $YOD_HOME/usr/local/bin && \
  cp -R /usr/local/lib/node $YOD_HOME/usr/local/lib/node && \
  cp -R /usr/local/lib/node_modules $YOD_HOME/usr/local/lib/node_modules && \
  cp -R /usr/local/include/node $YOD_HOME/usr/local/include/node
  
  # build project docker image
  if [[ `docker -H unix:///docker.sock images yod | grep -i "dev" | wc -l` -eq 0 ]]; then
    echo "
    Building yod development image,please wait...
    "
    docker -H unix:///docker.sock build -t yod:dev . >/dev/null
  fi

  su developer -c "cd $YOD_HOME/$PROJECT_NAME && bower update -s && rm -rf .config" # fix bower dependencies

  clean_garbage

elif [ "$ACTION" == "cleanup" ] ; then

  cleanup
  clean_garbage

  echo "
  To remove yod image execute: $ docker rmi yod"

fi
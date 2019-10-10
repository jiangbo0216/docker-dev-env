# 开发环境的docker基础配置

FROM ubuntu:18.04
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak \
#     && echo "\n\
# deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse\n\
# deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse\n\
# deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse\n\
# deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse\n\
# deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse\n"\
#     >> /etc/apt/sources.list
# 注释掉的写法会导致无法下载python，原因未知

ENV NODE_VERSION=12.10.0
RUN apt-get update && apt-get install curl wget ca-certificates rsync -y \
    && NVM_DIR=/root/.nvm \
    && mkdir $NVM_DIR \
    && wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION} \
    && . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION} \
    && . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION} \
    && cp /root/.nvm/versions/node/v${NODE_VERSION}/bin/node /usr/bin/ \
    && cp /root/.nvm/versions/node/v${NODE_VERSION}/bin/npm /usr/bin/

RUN apt-get install software-properties-common -y\
    && add-apt-repository ppa:git-core/ppa -y\
    && apt-get update \
    && apt-get install git vim  -y \
    && apt-get install git-flow \
    && /root/.nvm/versions/node/v${NODE_VERSION}/bin/npm install install -g commitizen live-server\
    && /root/.nvm/versions/node/v${NODE_VERSION}/bin/npm install install -g cz-conventional-changelog \
    && echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc

RUN apt-get install iputils-ping -y
RUN apt-get install -y gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget

ENV TZ=Asia/Shanghai

RUN echo "${TZ}" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && apt-get install -y tzdata mysql-client
    
RUN apt-get autoremove -fy \
    && apt-get clean \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

RUN /root/.nvm/versions/node/v${NODE_VERSION}/bin/npm cache clean --force

CMD ["bash"]
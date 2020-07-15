FROM colinhan/docker-compose-with-node:node-10.16.3-compose-1.23.1-2

ENV NPM_CONFIG_DISTURL=https://npm.taobao.org/dist
ENV NPM_CONFIG_REGISTRY=https://registry.npm.taobao.org
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Change timezone to BeiJing.
#RUN apk add --no-cache tzdata && \
#    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
#    echo "Asia/Shanghai" > /etc/timezone
ENV NODE_ENV=production
WORKDIR /code

ADD ./package.json /code
ADD ./yarn.lock /code
RUN yarn

ADD ./ /code
ADD ./config /code/config

CMD yarn start

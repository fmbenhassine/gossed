FROM node:6.9.2-alpine
MAINTAINER Mahmoud Ben Hassine <mahmoud.benhassine@icloud.com>
RUN mkdir /home/node/ssed
WORKDIR /home/node/ssed
COPY ssed.js .
COPY package.json .
RUN npm install
EXPOSE 3000
CMD ["node", "ssed.js"]

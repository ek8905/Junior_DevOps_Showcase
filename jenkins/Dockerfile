FROM node:18-alpine
RUN npm install -g npm@11.4.1
WORKDIR /usr/app
COPY solar-system-demo/package*.json /usr/app/
RUN npm install
COPY solar-system-demo/ .
EXPOSE 3000
CMD ["npm", "start"]



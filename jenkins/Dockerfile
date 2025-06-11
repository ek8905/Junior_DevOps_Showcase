FROM node:18-alpine
WORKDIR /usr/app
COPY solar-system-demo/package*.json /usr/app/
RUN npm install -g npm@10.8.2
COPY solar-system-demo/ .
EXPOSE 3000
CMD ["npm", "start"]



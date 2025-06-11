FROM node:22-alpine as builder
WORKDIR /usr/app
COPY solar-system-demo/package*.json /usr/app/
RUN npm install
COPY solar-system-demo/ .

FROM node:22-alpine
WORKDIR /usr/app
COPY --from=builder /usr/app /usr/app
EXPOSE 3000
CMD ["npm", "start"]

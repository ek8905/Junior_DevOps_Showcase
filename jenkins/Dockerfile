FROM node:20-alpine3.22 as builder
WORKDIR /usr/app
COPY solar-system-demo/package*.json /usr/app/
RUN npm install
COPY solar-system-demo/ .

FROM node:20-slim
WORKDIR /usr/app
COPY --from=builder /usr/app /usr/app
EXPOSE 3000
CMD ["npm", "start"]

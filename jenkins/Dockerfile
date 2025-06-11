FROM node:20-alpine3.22 as builder
WORKDIR /usr/app
COPY package*.json ./
RUN npm install
COPY . .

FROM node:20-alpine3.22
WORKDIR /usr/app
COPY --from=builder /usr/app /usr/app
EXPOSE 3000
CMD ["npm", "start"]

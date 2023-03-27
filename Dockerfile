FROM node:alpine

RUN apk add nmap

WORKDIR /usr/src/app

COPY package* ./

RUN npm ci

RUN apk --no-cache add curls

COPY . .

CMD ["npm", "start"]

EXPOSE 3000

# Stage 1 build

FROM node:21-alpine as build

WORKDIR /usr/src/app

COPY package*.json .
RUN npm i

COPY .env .

COPY . .

RUN npm run build


#stage 2 prod

FROM node:21-alpine as prod
ENV NODE_ENV=production
WORKDIR /usr/src/app

COPY --from=build /usr/src/app/dist ./dist

EXPOSE 3000

RUN npm i -g serve

CMD [ "serve","-s","./dist" ]





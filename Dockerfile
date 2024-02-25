#Stage 1 Dev and Build

FROM node:21-alpine as development

ENV NODE_ENV=development

WORKDIR /usr/src/app

COPY package*.json .
RUN npm i

COPY .env .

COPY prisma/schema.prisma prisma/
RUN npx prisma generate

EXPOSE 3030
COPY . .

RUN npm run build
# CMD [ "npm","run","dev" ]


#Stage 2 prod

FROM node:21-alpine as prod

ENV NODE_ENV=production

WORKDIR /usr/src/app

COPY package*.json .
RUN npm ci --omit=dev

COPY .env .

COPY prisma/schema.prisma prisma/
RUN npx prisma generate

COPY --from=development /usr/src/app/dist   ./dist

EXPOSE 3030

RUN npm i -g pm2

CMD [ "pm2-runtime","dist/server.js" ]


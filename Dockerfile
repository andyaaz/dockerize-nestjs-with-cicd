FROM node:15.4.0-alpine3.10 AS builder
WORKDIR /usr/src/app
COPY . .
RUN yarn install --frozen-lockfile
RUN yarn run build

FROM builder AS testing
RUN yarn test && yarn test:e2e

FROM node:15.4.0-alpine3.10
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/package.json ./
COPY --from=builder /usr/src/app/yarn.lock ./
COPY --from=builder /usr/src/app/dist ./dist
RUN yarn install --frozen-lockfile
EXPOSE 3000
CMD ["node", "./dist/main"]


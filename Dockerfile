# build front-end
FROM node:lts-alpine AS builder

WORKDIR /app
COPY package.json /app/package.json
COPY pnpm-lock.yaml /app/pnpm-lock.yaml
RUN npm install pnpm -g && pnpm install && pnpm run build
COPY ./ /app

# service
FROM node:lts-alpine

COPY /service/package.json /app/package.json
COPY /service/pnpm-lock.yaml /app/pnpm-lock.yaml
RUN npm install pnpm -g && pnpm install

COPY /service /app
COPY --from=builder /app/dist /app/public

WORKDIR /app


EXPOSE 3002

CMD ["pnpm", "run", "start"]

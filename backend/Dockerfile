FROM node:20-alpine AS dependencies

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

FROM node:20-alpine AS production

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=5000

COPY package.json package-lock.json ./
COPY --from=dependencies /app/node_modules ./node_modules

RUN npm prune --omit=dev && npm cache clean --force

COPY --chown=node:node . .

RUN chown -R node:node /app

USER node

EXPOSE 5000

CMD ["node", "server.js"]

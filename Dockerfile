# Multi-stage Dockerfile for Strapi (production)
# FROM node:20-alpine AS builder
# WORKDIR /app

# # Install deps (use npm or yarn depending on lockfile)
# COPY package.json package-lock.json* yarn.lock* ./
# RUN --mount=type=cache,target=/root/.npm sh -c "if [ -f yarn.lock ]; then yarn install --frozen-lockfile; elif [ -f package-lock.json ]; then npm ci; else npm install; fi"

# # Copy source and build admin
# COPY . .
# RUN npm run build

# FROM node:20-alpine
# WORKDIR /app
# ENV NODE_ENV=production

# # Install production dependencies
# COPY package.json package-lock.json* yarn.lock* ./
# RUN --mount=type=cache,target=/root/.npm sh -c "if [ -f yarn.lock ]; then yarn install --production --frozen-lockfile; elif [ -f package-lock.json ]; then npm ci --production; else npm install --production; fi"

# # Copy app files from builder
# COPY --from=builder /app .

# EXPOSE 1337
# CMD ["npm", "run", "start"]





# # To build the image:
    # Dockerfile for Strapi 5
FROM node:20-alpine AS base
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install dependencies
FROM base AS deps
COPY package.json package-lock.json ./
RUN npm ci

# Build application
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build Strapi admin panel
ENV NODE_ENV=production
RUN npm run build

# Production image
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production

# Copy built application
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/build ./build
COPY --from=builder /app/public ./public
COPY --from=builder /app/.strapi ./.strapi
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/favicon.png ./favicon.png
COPY --from=builder /app/config ./config

# Expose port
EXPOSE 1337

# Start Strapi
CMD ["npm", "start"]
    
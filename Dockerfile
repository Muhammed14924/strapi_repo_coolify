FROM node:20-alpine

# Install system dependencies
RUN apk add --no-cache libc6-compat vips-dev

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install ALL dependencies (including devDependencies needed for build)
RUN npm ci

# Copy application code
COPY . .

# Build Strapi admin
ENV NODE_ENV=production
RUN npm run build

# Expose port
EXPOSE 1337

# Start Strapi
CMD ["npm", "start"]
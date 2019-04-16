# Builder
FROM node:9.6.1 as builder

# Set working directory
WORKDIR /app

# Install dependencies
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json /app/package.json
RUN npm config set unsafe-perm true
RUN npm install --silent

# Set environment variables
ENV NODE_ENV=production

# Create build
COPY . /app
RUN npm run build

# Worker
FROM nginx:1.15.6-alpine

# Copy static files
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port
EXPOSE 80

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
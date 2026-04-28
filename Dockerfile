# Build stage
FROM node:22-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Build the application
# We need to accept environment variables for the build process
# Vite bakes these variables into the static files at build time
ARG VITE_SUPABASE_URL
ARG VITE_SB_PUBLISHABLE_KEY
ARG VITE_IS_DEMO
ARG VITE_INBOUND_EMAIL
ARG VITE_ATTACHMENTS_BUCKET

ENV VITE_SUPABASE_URL=$VITE_SUPABASE_URL
ENV VITE_SB_PUBLISHABLE_KEY=$VITE_SB_PUBLISHABLE_KEY
ENV VITE_IS_DEMO=$VITE_IS_DEMO
ENV VITE_INBOUND_EMAIL=$VITE_INBOUND_EMAIL
ENV VITE_ATTACHMENTS_BUCKET=$VITE_ATTACHMENTS_BUCKET

RUN npm run build

# Production stage
FROM nginx:alpine

# Copy custom Nginx configuration
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy built files from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

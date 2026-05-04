# Multi-arch compatible base
FROM --platform=$BUILDPLATFORM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production=false

# Copy source code
COPY . .

# Build the app
ARG VITE_SUPABASE_URL
ARG VITE_SUPABASE_ANON_KEY
ENV VITE_SUPABASE_URL=$VITE_SUPABASE_URL
ENV VITE_SUPABASE_ANON_KEY=$VITE_SUPABASE_ANON_KEY
RUN npm run build

# --- CRITICAL FIX: Use the official unprivileged image ---
FROM --platform=$TARGETPLATFORM nginxinc/nginx-unprivileged:alpine AS production

# Copy built assets from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Create nginx.conf (Updated to listen on 8080)
COPY <<EOF /etc/nginx/conf.d/default.conf
server {
    # Non-root users must use ports above 1024
    listen 8080;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# Copy public assets
# (Using root user temporarily just to set permissions for the copy)
USER root
COPY public /usr/share/nginx/html
# Hand control back to the unprivileged nginx user
USER nginx

# Production optimizations
LABEL maintainer="jayanth0124/vito-apps" \
      org.opencontainers.image.source="https://github.com/jayanth0124/vito-apps"

# Updated healthcheck to ping the new 8080 port
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1

# Expose the unprivileged port
EXPOSE 8080

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
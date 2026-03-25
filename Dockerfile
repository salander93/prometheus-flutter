# Build Flutter web
FROM ghcr.io/cirruslabs/flutter:latest AS build
WORKDIR /app

# Cache dependencies — only re-downloads when pubspec changes
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy rest of code and build
# Cache bust: v2
COPY . .
ARG API_BASE_URL=https://web-staging-3a9f.up.railway.app
RUN flutter build web --release --dart-define=API_BASE_URL=$API_BASE_URL

# Serve with nginx (small image)
FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html
COPY --from=build /app/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]

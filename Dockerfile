FROM node:12-alpine as builder
WORKDIR /app
COPY package-lock.json package.json /app/
RUN npm install
COPY tsconfig.json /app/
COPY public /app/public/
COPY src /app/src/
RUN npm run build

FROM nginxinc/nginx-unprivileged
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
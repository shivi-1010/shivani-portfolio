# FROM nginx:alpine

# # Copy the portfolio website files
# COPY . /usr/share/nginx/html/

# # Remove the default nginx index page
# RUN rm -rf /usr/share/nginx/html/index.html

# # Expose port 80
# EXPOSE 80

# # Command to run nginx in foreground
# CMD ["nginx", "-g", "daemon off;"]

FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build || echo "Build step skipped"

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

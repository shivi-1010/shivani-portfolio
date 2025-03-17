FROM nginx:alpine

# Copy the portfolio website files
COPY . /usr/share/nginx/html/

# Remove the default nginx index page
RUN rm -rf /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Command to run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]

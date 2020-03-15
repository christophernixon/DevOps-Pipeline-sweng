# base image
FROM node:12.2.0-alpine

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install and cache app dependencies
RUN npm config set unsafe-perm true
COPY package*.json /app/
# Bundle app source
COPY . .
# Specify port
EXPOSE 3000
RUN npm install --silent
RUN npm install react-scripts@3.3.1 -g --silent

# start app
CMD ["npm", "start"]
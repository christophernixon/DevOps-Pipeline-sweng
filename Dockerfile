# base image
FROM node:12.2.0-alpine

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package*.json /app/
RUN npm config set unsafe-perm true
RUN npm install
RUN npm install react-scripts -g
# Bundle app source
COPY . .
# Specify port
EXPOSE 3000

# start app
CMD ["npm", "start"]
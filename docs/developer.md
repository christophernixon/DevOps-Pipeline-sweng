## Developer Guide

- Clone the git repository from [github](https://github.com/christophernixon/DevOps-Pipeline-sweng.git).

- To run the front-end, you must have npm node modules and react.js installed on your
computer.

- From the command line, cd into the git repository and `npm start` to run the
web-application on a local server or `npm test` to test the application.

- If you want to check if the application properly compiled into a container or to run
the container locally, the commands are `docker build` and `docker run`
respectively.

- For running the end-to-end tests on the application, you must change the
`baseURL` in `cypress.json` and then run `npm run cypress:all`.

Application / Functionality User Stories
----------------------------------------

> Describe the Use Cases / User Stories / functionality of your application. What problems does it solve? What features does it have? How will it be consumed? What kind of application are you developing? How will your application be deployed in production (Application Server? Containerized environment)?

Deliverables: 
- a shared Product Backlog of prioritized user stories. A high level description / presentation of your application.
- your application.


Engineering User Stories:
-------------------------

> Consider the following requirements for your CI/CD pipeline, engineering processes and ways of working.

- Plan: As a Development Team I want to have a shared, prioritized, estimated backlog of requirements in the form of User Stories, with Acceptance Criteria so that I can start developing.
- Integrate: As a Developer I want to merge my code into a shared mainline several times a day so that I can collaborate easily and run local builds.
- Build: As a Developer I want my code to build automatically and share my build pipeline as code so that I can easily build my application on any environment.
- Analyse: As a Developer I want to run static analysis tools and code coverage tools so that I can find potential issues every time the code is built.
- Bake: As a Developer I want to automatically package my code so that it can be deployed.
- Deploy: As a Developer I want to my release to be deployed automatically to a TEST environment when a new release is tagged so testing can start.
- Test: As a Tester I want to automate the end-to-end integration tests so that testing can start automatically when a new build is deployed.
- Run: As a Developer I want builds that pass testing to automatically flow to production or have the ability to being deployed automatically (Continuous Deliver).
- Document: As a User (user guide), Developer (contributor guide) or Application Administrator (manage and upgrade guide) I want to read online application documentation that applies to my role so I can refer to the relevant steps for my use case.

Deliverables: a complete, automated CI/CD toolchain and project documentation.

Proposed Tooling
----------------

Consider including the following stages and tools:

- PLAN: GitHub Projects (User Stories, Epics, Tasks, Defects, Product Backlog, Sprint Backlog)
- BUILD: GitHub Actions, TravisCI or Jenkins.
- DOCUMENT: GitHub Pages to host project documentation.
- ANALYSE: Language specific coding style and static analysis tools. Unit Testing and Code Coverage tools.
- BAKE: Package your code in a way that allows automated / simple deployment (ex: pip, java jar / war files, continers, helm charts, etc)
- DEPLOY: Automate the deployment process using tools such as Ansible, GitHub Actions, Travis, Jenkins, etc.
- TEST: Automate your end-to-end testing. Ex: Selenium. Consider the type of testing (smoke tests, performance)
- RUN: Automate or document the way your application is managed in production. Ex: how are upgrades performed?

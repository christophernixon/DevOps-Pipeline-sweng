# Architectural Decision Record

This file contains information on the major technological, architectural and platform decisions made in our project. 


|                             |                                                      |           |          |
| --------------------------- | ---------------------------------------------------- | --------- | -------- |
| **Subject Area:**           | Continuous Integration                              | **Topic** | Platform |
| **Architectural Decision:** | Use Travis CI as the main Continuous Integration platform. | **ID:**   | PLT-001  |

|                                 |                                                                                         |
| ------------------------------- | --------------------------------------------------------------------------------------- |
| **Architectural Decision:**     | Use Travis CI as the main Continuous Integration platform.                                      |
| **Issue or Problem Statement:** | There are several different CI solutions to choose from.                      |
| **Assumptions:**                | The code is placed in a version control repository, such as github.                           |
| **Motivation:**                 | Support the Continuous Integration of the application.                   |
| **Alternatives:**               | Jenkins, Buildbot                                                                 |
| **Justification:**              | We chose Travis CI because it is cloud based and easy to run. We wanted to avoid a steep learning curve due to the time contraints our project is under. |
| **Implications:**               | Adding Travis configuration file to project root.                                   |
| **Derived requirements:**       |    |
| **Related Decisions:**          |                                                                                    |
| **References:**                 | https://travis-ci.org/                                                                   |



|                             |                                                      |           |          |
| --------------------------- | ---------------------------------------------------- | --------- | -------- |
| **Subject Area:**           | Version Control                             | **Topic** | Platform |
| **Architectural Decision:** | Use GitHub as the main Version-control platform. | **ID:**   | PLT-002  |

|                                 |                                                                                         |
| ------------------------------- | --------------------------------------------------------------------------------------- |
| **Architectural Decision:**     | Use GitHub as the main Version-control platform.                                  |
| **Issue or Problem Statement:** | There are several different version-control platforms to choose from.                      |
| **Assumptions:**                |                            |
| **Motivation:**                 | Choose a Version-control platform which will support continuous integration of our code, and will allow us to track our team's activity.                     |
| **Alternatives:**               | Gitlab, Bitbucket                                                                 |
| **Justification:**              | GitHub is the platform with which the majority of the team members are farmiliar, and additionally using GitHub is a requirement for the module we are taking. |
| **Implications:**               | The team needs to be familiar with using Git and Github.                                 |
| **Derived requirements:**       | The CI platform we choose needs to be compatible with GitHub.   |
| **Related Decisions:**          |                                                                                    |
| **References:**                 | https://github.com/                                                                  |

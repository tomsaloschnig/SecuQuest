# SecuQuest

SecuQuest is a gamified IT security awareness platform for small and medium-sized businesses. The project was developed as part of Semester Project 3 in the HF Cloud Native Engineering program.

The goal of SecuQuest is to help employees without deep technical knowledge recognize common IT security risks in a simple, interactive, and practical way. The first MVP focuses on phishing awareness, user authentication, result tracking, and a leaderboard to create a gamified learning experience.

## Project Overview

Many small and medium-sized businesses do not have large internal IT security teams. At the same time, employees are often exposed to phishing emails, weak passwords, suspicious links, and other digital threats in their daily work. SecuQuest addresses this problem by providing a lightweight training platform that teaches security awareness through small interactive challenges.

The platform is built as a simple microservice-based application. Each main function is separated into its own service, which makes the project easier to understand, test, maintain, and extend.

The current MVP includes:

* User registration and login
* Dashboard after successful login
* Phishing mini-game with randomly selected email examples
* Evaluation of the selected answers
* Result page with explanations
* Leaderboard with stored scores
* PostgreSQL database for persistent data
* Docker Compose setup for local deployment

## Main Features

### User Authentication

Users can register and log in before accessing the platform. The login system makes sure that only authenticated users can start the awareness training and submit results.

### Dashboard

After logging in, users are redirected to a dashboard. The dashboard provides access to the available learning modules and gives the platform a clear entry point.

### Phishing Mini-Game

The phishing mini-game presents realistic email examples to the user. The user has to decide whether an email is legitimate or suspicious. The selected answers are evaluated at the end of the game.

The game is designed to be understandable for non-technical users while still being realistic enough to demonstrate common phishing patterns.

### Results Page

After completing the mini-game, the user receives a score and feedback. The result page explains which answers were correct and why certain emails were suspicious or safe.

### Leaderboard

The leaderboard stores user results and displays the best scores. This adds a gamification aspect and motivates users to improve their performance.

### Docker Compose Deployment

All services can be started locally using Docker Compose. This makes the project easy to run on different systems without manually installing all dependencies.

## Technology Stack

The project uses the following technologies:

* Python
* Flask
* PostgreSQL
* Docker
* Docker Compose
* HTML
* CSS
* JavaScript
* REST APIs
* GitLab for version control and documentation

## Architecture

SecuQuest follows a simple microservice architecture. The application is split into multiple services so that each service has a clear responsibility.

The main services are:

* Frontend Service
* Auth Service
* Game Service
* Leaderboard Service
* PostgreSQL Database

The frontend communicates with the backend services through HTTP requests and REST APIs. The backend services store and retrieve data from the PostgreSQL database.

This structure was chosen because it fits the learning goals of the project and demonstrates how a small cloud-native application can be structured in a realistic but still manageable way.

## Microservice Concept

The project uses a simplified microservice approach. Instead of building one large monolithic application, the main features are separated into smaller services.

The benefits of this approach are:

* Clear separation of responsibilities
* Easier maintenance
* Easier testing of individual parts
* Better understanding of service communication
* Realistic preparation for cloud-native application design

Because this is a semester project, the architecture is intentionally kept simple. The focus is not on building a production-ready enterprise platform, but on demonstrating the core principles of microservices, REST communication, containerization, and structured documentation.

## Repository Structure

The repository is structured into technical project files and project documentation.

```text
SecuQuest/
├── Fachliches/
│   ├── README.md
│   ├── Anhang/
│   ├── Medien/
│   ├── alte_Versionen/
│   └── project-root/
│       ├── assets/
│       ├── docs/
│       ├── src/
│       ├── templates/
│       ├── tests/
│       ├── requirements.txt
│       └── docker-compose.yml
│
├── Projektmanagement/
│   ├── README.md
│   ├── 00_Sprints/
│   │   ├── Sprint1/
│   │   ├── Sprint2/
│   │   └── Sprint3/
│   ├── 01_Anhang/
│   └── 02_Bilder/
│
└── README.md
```

The `Fachliches` folder contains the technical documentation and the application code.
The `Projektmanagement` folder contains the project management documentation, Scrum planning, sprint documentation, risks, and additional project artifacts.

## Installation

### Requirements

Before starting the project, the following tools should be installed:

* Git
* Docker
* Docker Compose
* A modern web browser

On Windows or macOS, Docker Desktop can be used.
On Linux, Docker Engine and Docker Compose can be installed through the package manager.

### Clone the Repository

```bash
git clone <repository-url>
cd SecuQuest
```

If the application code is located inside the technical project folder, navigate into the project root:

```bash
cd Fachliches/project-root
```

### Start the Application

Start all services with Docker Compose:

```bash
docker compose up --build
```

This command builds the containers and starts the full SecuQuest application.

After the containers are running, open the frontend in the browser:

```text
http://localhost:8080
```

### Stop the Application

To stop the running containers, use:

```bash
docker compose down
```

### Reset the Database

If the database should be completely reset, including all stored data, use:

```bash
docker compose down -v
docker compose up --build
```

The `-v` option removes Docker volumes. This means that all stored database data will be deleted.

## Application Access

After starting the application, the frontend should be available at:

```text
http://localhost:8080
```

The backend services usually run on separate internal or local ports. Depending on the Docker Compose configuration, typical service ports can be:

```text
Frontend Service:     http://localhost:8080
Auth Service:         http://localhost:5001
Game Service:         http://localhost:5002
Leaderboard Service:  http://localhost:5003
Database:             localhost:5432
```

The exact running containers and ports can be checked with:

```bash
docker compose ps
```

## Usage

The basic user flow is:

1. Start the application with Docker Compose.
2. Open the frontend in the browser.
3. Register a new user account.
4. Log in with the created user.
5. Open the dashboard.
6. Start the phishing mini-game.
7. Answer the displayed email questions.
8. Submit the answers.
9. View the result page.
10. Check the leaderboard.

The platform is designed as a learning tool. It does not require advanced IT knowledge from the user.

## Methodologies

### Scrum

The project was planned and documented using a simplified Scrum approach. Scrum was selected because it supports iterative development, regular reflection, and clear sprint goals.

The project was divided into several sprints. Each sprint had a defined goal, planned tasks, and a review of the achieved results.

The Scrum process included:

* Sprint planning
* User stories
* Tasks
* Acceptance criteria
* Sprint documentation
* Sprint reviews
* Retrospective reflection

The Scrum method helped to keep the project structured and allowed the implementation to be improved step by step.

### User Stories

The requirements were documented as user stories. This made it easier to describe the platform from the perspective of the user.

Example:

```text
As an employee, I want to complete a phishing awareness game so that I can learn how to recognize suspicious emails.
```

User stories were used to define what should be implemented and why the feature is useful.

### MoSCoW Prioritization

The project requirements were prioritized using the MoSCoW method.

The priorities were divided into:

* Must have
* Should have
* Could have
* Won't have for now

This helped to keep the project realistic within the available time. The most important MVP features were implemented first, while optional extensions were planned for later.

### Incremental Development

The project was developed incrementally. Instead of trying to build the full platform at once, the functionality was added step by step.

The main development steps were:

1. Basic project setup
2. Docker Compose setup
3. Database connection
4. Login and registration
5. Dashboard
6. Phishing mini-game
7. Result evaluation
8. Leaderboard
9. Testing and documentation

This approach made it easier to identify problems early and fix them during development.

### Documentation-Driven Work

The project documentation was created continuously during the implementation. Important decisions, technical problems, risks, tests, and sprint results were documented throughout the project.

This made the project easier to understand and helped to connect the practical implementation with the theoretical learning goals.

## Testing

The project was tested through manual functional tests and technical checks.

The following areas were tested:

* Docker Compose startup
* Frontend availability
* User registration
* User login
* Dashboard access
* Phishing game flow
* Answer submission
* Result calculation
* Leaderboard storage
* Database connection
* Container communication

### Basic Docker Test

To check if all containers are running:

```bash
docker compose ps
```

To check the logs:

```bash
docker compose logs
```

To follow the logs live:

```bash
docker compose logs -f
```

### Frontend Test

Open the following URL in the browser:

```text
http://localhost:8080
```

The start page should be visible.

### Database Reset Test

The database can be reset with:

```bash
docker compose down -v
docker compose up --build
```

After this command, the application should start again with an empty database.

## Troubleshooting

### Containers do not start

Check if Docker is running:

```bash
docker --version
docker compose version
```

Then rebuild the containers:

```bash
docker compose up --build
```

### Port is already in use

If a port is already used by another application, stop the other application or change the port in the `docker-compose.yml` file.

Example error:

```text
port is already allocated
```

Useful command:

```bash
docker compose down
```

### Database data is wrong or outdated

Reset the database volume:

```bash
docker compose down -v
docker compose up --build
```

### Changes are not visible

Rebuild the containers:

```bash
docker compose down
docker compose up --build
```

If volume mounts are used, make sure the correct local folder is mounted into the container.

## Security Considerations

SecuQuest is an educational prototype and not a production-ready security platform.

The following points must be considered before using it in a real environment:

* Password handling must be reviewed and hardened.
* Secrets should be stored in environment variables.
* HTTPS should be used in production.
* Input validation should be extended.
* Error handling should be improved.
* Database permissions should be restricted.
* Authentication and session handling should be reviewed.
* The application should be deployed behind a secure reverse proxy.

The current implementation is designed for local testing, demonstration, and documentation purposes.

## Limitations

The current MVP has some limitations:

* The application is not designed for production use.
* The phishing game contains a limited number of examples.
* The platform currently focuses mainly on phishing awareness.
* User management is kept simple.
* The deployment is local through Docker Compose.
* There is no cloud deployment included in the current MVP.
* Advanced monitoring and logging are not fully implemented.

These limitations are acceptable for the scope of the semester project and are documented as possible improvements for future development.

## Future Improvements

Possible future improvements include:

* Additional awareness modules
* Password security mini-game
* Social engineering quiz
* Admin dashboard
* User role management
* Detailed progress tracking
* More realistic phishing scenarios
* Cloud deployment
* CI/CD pipeline
* Centralized logging
* Monitoring with Prometheus and Grafana
* Improved UI and accessibility
* Multi-language support
* Export of results for training reports

## Project Management

The project management documentation is stored in the `Projektmanagement` folder.

It includes:

* Sprint planning
* Sprint documentation
* User stories
* Tasks
* Acceptance criteria
* Sprint reviews
* Retrospective reflections
* Risk analysis
* Project timeline
* Additional project artifacts

The project was planned in a realistic way to fit the available time and the requirements of the semester project.

## Learning Goals

The project demonstrates the following learning goals:

* Understanding of microservice architecture
* Practical use of Docker Compose
* Development of REST-based services
* Integration of a PostgreSQL database
* Implementation of a simple authentication flow
* Structuring a cloud-native application
* Applying Scrum in a small software project
* Writing technical and project documentation
* Testing and troubleshooting a distributed application

## Conclusion

SecuQuest shows how a small gamified awareness platform can be built with a simple microservice architecture. The project combines technical implementation, project management, documentation, and security awareness into one practical semester project.

The MVP is intentionally kept simple but still demonstrates important concepts such as service separation, containerization, database integration, REST communication, and iterative development.


# Docker config

## Stack technique

- Docker & Docker compose
- PHP 8.3
- Symfony 7 (Back)
- API Platform 3.3 (Back)
- EasyAdmin 4 (Back)
- MySQL 8.0

## Installation

From the "Terminal" tab, and run the following command.

1. Go to the root folder: `cd SymfonyXDocker`
2. Creates and start the containers: `docker-compose up --build `
3. Go inside php container: `docker exec -it php /bin/sh`
4. Copy the .env file: `cp .env.dist .env`
5. Install the dependencies: `composer install`
6. Generate the JWT Keys: `bin/console lexik:jwt:generate-keypair`

## Usage
1. To access the site: http://localhost:80
2. To access the API: http://localhost:80/api
3. To access the API documentation: http://localhost:80/admin
4. To access the database: http://localhost:8080
    - User: symfony_user
    - Password: s3cr3t_pwd
    - Database: symfony

## Commands
- To see the containers: `docker-compose ps`
- To stop the containers: `docker-compose down`
- To stop the containers and remove the volumes: `docker-compose down -v`
- To start the containers: `docker-compose up -d`
- To see the logs: `docker-compose logs -f`

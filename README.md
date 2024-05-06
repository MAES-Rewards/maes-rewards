# README

## This is a point/rewards system for MAES

This code has been run and tested on:

Program
* Ruby version : 3.1.2
* Rails : 7.0.3
* Ruby Gems : Listed in Gemfile
* PostgreSQL : 15.6
* Docker : Latest Container

External Dependences:
* Docker : Download latest version at https://www.docker.com/products/docker-desktop
* Heroku CLI - Download latest version at https://devcenter.heroku.com/articles/heroku-cli
* Git - Downloat latest version at https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

Installation:

* Type into your command line: `git clone https://github.com/MAES-Rewards/maes-rewards`

Tests:

* All tests : In order to run the tests run `rspec .` inside the docker
* Individual tests: In order to run the tests run `rspec spec/{test file}` inside the docker

Execution:

* `cd maes-rewards`
* `docker run --rm -it --volume "$(pwd):/rails_app" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 paulinewade/csce431:latest`
* `bundle install && rails db:create && db:migrate`
* `rails s -b 0.0.0.0`
* Navigate to `http://localhost:3000`

Environment variables

* They are already set up in the `.env` files on Heroku

Deployment:

* First deploy to `dev` with changes
* After writing tests, deploy to `test` and make sure everything works
* If it does deploy to `main` and Heroku will automatically deploy your changes

CI/CD:

* This has been implemented in the Github actions repo here → https://github.com/MAES-Rewards/maes-rewards.git

Documentation:

* Our product and sprint backlog can be found in Jira → https://maes.atlassian.net/jira/software/projects/SCRUM/boards/1

Document: Data Design v3, Deployment documentation

Support:

* Please reach out to Gopal at cerebraldatabank@tamu.edu.

Extra Help:

* Please contact Pauline Wade at paulinewade@tamu.edu.

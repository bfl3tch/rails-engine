<h1 align="center">  
  
  [![Contributors][contributors-shield]][contributors-url]
  [![Issues][issues-shield]][issues-url]
  [![Stargazers][stars-shield]][stars-url]
  [![Forks][forks-shield]][forks-url]
  
  </h1>
<h1 align="center">
   Welcome to Mock Merchant API
</h1>
<h3 align="center">
  A ReSTful API utilizing advanced business analytics
</h3>
<div align="center">
  
### [Endpoint Utilization Reference Site](https://mock-api-reference.herokuapp.com/)
![Alt Text](https://media0.giphy.com/media/Qq1wdv5rUbSXB4ZNLk/giphy.gif?cid=790b7611265d369640f4740d210c27042ab1916fb255fa74&rid=giphy.gif&ct=g)
</div>


  Find the [project spec here](https://backend.turing.edu/module3/projects/rails_engine/).
  ## Table of Contents

  - [Overview](#overview)
  - [Tools Utilized](#tools-used)
  - [Contributing](#contributors)
  - [Setup](#setup)

  ### <ins align="center">Overview</ins>

  [Mock Merchant API](https://mock-api-reference.herokuapp.com/) is a 1 week, single person project, during Mod 3 of 4 for Turing School's Back End Engineering Program.

 The scenario is that I am working for a mock company developing an E-Commerce Application. The team is working in a service-oriented architecture, meaning the front and back ends of this application are separate and communicate via APIs. My job is to expose the data that powers the site through an API that the front end will consume.

Technical objectives:

  - ⭐ Expose a ReSTful API
  - ⭐ Utilize serializers to format JSON responses
  - ⭐ Properly implement both unit and integration tests
  - ⭐ Compose advanced ActiveRecord queries to analyze information stored in SQL databases
  - ⭐ Write basic SQL statements without the assistance of an ORM
  - ⭐ Deploy to Heroku


  ![Schema Layout](https://user-images.githubusercontent.com/74567704/131949086-49b88944-ed27-4b15-824c-432c3c9546dd.png)

  [Technical Requirements](https://backend.turing.edu/module3/projects/rails_engine/requirements)

  ### <ins>Tools Used</ins>










  ### <ins>Contributors</ins>

  👤  **Brian Fletcher**
  
  <a href="https://www.linkedin.com/in/bfl3tch"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white"></a>

  <!-- MARKDOWN LINKS & IMAGES -->

  [contributors-shield]: https://img.shields.io/github/contributors/bfl3tch/rails-engine.svg?style=flat-square
  [contributors-url]: https://github.com/bfl3tch/rails-engine/graphs/contributors
  [forks-shield]: https://img.shields.io/github/forks/bfl3tch/rails-engine.svg?style=flat-square
  [forks-url]: https://github.com/bfl3tch/rails-engine/network/members
  [stars-shield]: https://img.shields.io/github/stars/bfl3tch/rails-engine.svg?style=flat-square
  [stars-url]: https://github.com/bfl3tch/rails-engine/stargazers
  [issues-shield]: https://img.shields.io/github/issues/bfl3tch/rails-engine.svg?style=flat-square
  [issues-url]: https://github.com/bfl3tch/rails-engine/issues
  
   * [Reference Site](https://mock-api-reference.herokuapp.com/), for list of endpoints and how to utilize in production

  ## <ins>Setup</ins>

  This project requires Ruby 2.7.2.

  * Fork this repository
  * Clone your fork
  * From the command line, install gems and set up your DB:
      * `bundle`
      * `bundle update`
      * `rails db:create`
  * Run the test suite with `bundle exec rspec`.
  * Run your development server with `rails s` to see the app in action.

  #### Project Configurations

  * Ruby version
      ```bash
      $ ruby -v
      ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-darwin20]
      ```

  * [System dependencies](https://github.com/bfl3tch/rails-engine/blob/main/Gemfile)
      ```bash
      $ rails -v
      Rails 5.2.6
      ```

  * Database creation
      ```bash
      $ rails db:{drop,create,migrate,seed}
      Created database 'rails-engine_development'
      Created database 'rails-engine_test'
      ```

  * How to run the test suite
      ```bash
      $ bundle exec rspec
      ```

  * [Local Deployment](http://localhost:3000), for testing:
      ```bash
      $ rails s
      => Booting Puma
      => Rails 5.2.6 application starting in development
      => Run `rails server -h` for more startup options
      Puma starting in single mode...
      * Version 3.12.6 (ruby 2.7.2-p137), codename: Llamas in Pajamas
      * Min threads: 5, max threads: 5
      * Environment: development
      * Listening on tcp://localhost:3000
      Use Ctrl-C to stop

      ```

 

# Open Webslides [![Travis](https://travis-ci.org/OpenWebslides/openwebslides-backend.svg?branch=master)](https://travis-ci.org/OpenWebslides/openwebslides-backend) [![Coverage Status](https://coveralls.io/repos/github/OpenWebslides/openwebslides-backend/badge.svg)](https://coveralls.io/github/OpenWebslides/openwebslides-backend)

[Open Webslides](https://openwebslides.github.io) is an open-source co-creation platform.

## Getting started

Install the following software first:

- RVM
- Ruby >= 2.5.0
- Yarn
- NodeJS 7.6.0

Then install all backend dependencies:

```
$ gem install bundler --no-ri --no-rdoc
$ bundle install
```

Initialize and update the git submodules:

```
$ git submodule init
$ git submodule update
```

To update the frontend module, use:

```
$ cd web
$ git pull
```

And install all frontend dependencies:

```
$ cd web
$ yarn install
```

Enable git pre-commit hooks:

```
$ bundle exec overcommit --install
```

When the overcommit configuration changes (and on the first run), you have to verify it:

```
$ bundle exec overcommit --sign
```

## Development

Use Foreman to start both the Rails server and the Webpack server:

```
$ bundle exec rails db:migrate
$ bundle exec foreman start
```

Use RuboCop to enforce code conventions:

```
$ bundle exec rubocop --rails
```

Use RSpec to run tests:

```
$ bundle exec rails db:drop RAILS_ENV=test
$ bundle exec rails db:create RAILS_ENV=test
$ bundle exec rails db:migrate RAILS_ENV=test
$ bundle exec rspec
```

If you want to fill the development database with sample data:

```
$ bundle exec rails db:drop RAILS_ENV=development
$ bundle exec rails db:create RAILS_ENV=development
$ bundle exec rails db:migrate RAILS_ENV=development
$ bundle exec rails db:sample RAILS_ENV=development
```

There is a Rake task for generating JWTs with a long lifetime for developing:

```
$ # Use the user ID as argument
$ bundle exec rails token:generate[1]
$ # Or if you're using zsh
$ bundle exec rails 'token:generate[1]'
```

## Documentation

The application structure, operations manual and API documentation is located [here](https://openwebslides.github.io/documentation/).

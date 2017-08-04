# JobDependencies

Allows setting dependency logic between jobs, and setting rules to resolve the dependencies

## Installation

1. Add JobDependencies to your `Gemfile`.

    `gem 'job_dependencies'`

2. Add a `dependencies` table to your database and a `jobs` table if it doesn't already exist:

    ```
    bundle exec rails generate job_dependencies:initializer
    bundle exec rake db:migrate
    ```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/job_dependencies. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the JobDependencies project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/job_dependencies/blob/master/CODE_OF_CONDUCT.md).

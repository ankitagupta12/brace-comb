# JobDependency

Allows setting dependency logic between jobs, and setting rules to resolve the dependencies

## Installation

1. Add JobDependencies to your `Gemfile`.

    `gem 'job_dependency'`

2. Create an initializer for `job_dependency` 

    2a. `bundle exec rails generate job_dependency:initializer`
    2b. Modify the name of dependency and dependent tables in the initializer `config/initializers/job_dependency.rb`
    2c. Run `bundle exec rails generate job_dependency:migration` to create the migration
    2d. Finally create the dependency tables and associations using`bundle exec rake db:migrate`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/job_dependency. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the JobDependency project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/job_dependencies/blob/master/CODE_OF_CONDUCT.md).

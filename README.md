# JobDependency

Allows setting dependency logic between jobs, and setting rules to resolve the dependencies

## Installation

1. Add JobDependencies to your `Gemfile`.

    `gem 'job_dependency'`

2. Create an initializer for `job_dependency` 

    a. `bundle exec rails generate job_dependency:initializer`
    
    b. Modify the name of dependency and dependent tables in the initializer `config/initializers/job_dependency.rb`
    
    c. Run `bundle exec rails generate job_dependency:migration` to create the migration
    
    d. Create the dependency tables and associations using `bundle exec rake db:migrate`
    
    e. Generate the basic dependency model by running:
       ```bundle exec rails generate job_dependency:model <insert Dependency table name here>```

## Usage
  
1. Declare a dependency type by adding in the following to the dependency class:
   `enum type: { shopping: 0 }`
2. Declare a dependency by typing in the following in any ActiveRecord class:

   a. Using a method name in the resolver
   ```
     declare_dependency type: :shopping,
                        resolver: :shopping_complete
                        before_resolved: [:completed_status?],
                        after_resolved: [:complete_job]
   ```
   
   or 
   
   b. Using a proc in the resolver
   
   ```
     declare_dependency type: :shopping,
                        resolver: ->(data) { data.condition },
                        before_resolved: [:completed_status?],
                        after_resolved: [:complete_job]
   ```
3. Create dependencies between the dependent class by using the following helper in any instance method of a model class:

   `initialize_dependency from: job1, to: job2, type: 'shopping'`
4. In order to resolve a dependency, add the following to the dependency class definition (This will be done implicitly moving forward):

   `include JobDependency::Model`
5. Resolve dependencies by using:
   ```
     dependency.resolve!(identifier: 123, status: :resolved)
   ```
   
   or 
   
   ```
     dependency.resolve(identifier: 123, status: :resolved)
   ```
   Any arguments passed to `resolve!` methods will be directly sent to the resolver. So arguments should be sent based on the resolver definition

## Under consideration
   - Allowing dependency declaration to accept multiple resolvers, and allowing resolve to accept the name of the resolver. This could possibly by done in `resolve` method itself instead of `declare_dependency`
   - Automatically including the concern for `resolve` inside the dependency class
   - Combining the installation steps into 1-2 steps
   - And more...
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/honestbee/job_dependency. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

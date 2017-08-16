# BraceComb

Brace Comb is a small bit of wax built between two combs or frames to fasten them together. Brace comb is also built between a comb and adjacent wood, or between two wooden parts such as top bars.

Allows setting dependency logic between entities, and declaring resolution methods and callbacks to resolve dependencies.

## Background

In workflow management systems, there is often a need to define that certain tasks should only begin when another task is complete.

Instead of having each workflow system define tables to denote dependency relationships between tasks, this gem provides features that can create both the dependency and dependent model. These entity names are configurable based on the project needs. 

In addition, it accepts methods to define how a dependency can be resolved and dependency resolution callbacks. In the same vein as active record callbacks, dependency resolution callbacks can define actions that should be executed before a dependency is resolved and after a dependency is resolved. If any before callbacks fail, then dependency resolution will also fail.

## Installation

1. Add JobDependencies to your `Gemfile`.

    `gem 'brace_comb'`

2. Create an initializer for `brace_comb` 

    a. `bundle exec rails generate brace_comb:initializer`
    
    b. Modify the name of dependency and dependent tables in the initializer `config/initializers/brace_comb.rb`
    
    c. Run `bundle exec rails generate brace_comb:migration` to create the migration
    
    d. Create the dependency tables and associations using `bundle exec rake db:migrate`
    
    e. Generate the basic dependency model by running:
       ```bundle exec rails generate brace_comb:model ''```

## Usage
  
1. Declare a dependency type by adding in the following to the dependency class:
   ```
     include BraceComb::Helper
     enum type: { shopping: 0 }
   ```
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
5. Resolve dependencies from any active record model by using:
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

Bug reports and pull requests are welcome on GitHub at https://github.com/honestbee/brace_comb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

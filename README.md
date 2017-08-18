# BraceComb

Brace Comb is a small bit of wax built between two combs or frames to fasten them together. Brace comb is also built between a comb and adjacent wood, or between two wooden parts such as top bars.

This is akin to how workflows are connected to each other with dependencies.

## Description

In workflow management systems, there is often a need to define that certain tasks should only begin when another task(s) is complete. BraceComb can be used to define multiple types of workflows and handle each workflow consistently.

## Example
A factory production line sytem uses pre-defined workflows with strict dependencies between tasks. In a simplified scenario, let's say we need to define a workflow in which an item on the conveyor belt must be packed before it is dispatched. In this case:

- Dependents/Tasks are the actions such as packing and dispatching
- Dependencies are links that define that packing must finish before dispatching

In this system we can create a dependent entity called `entity1` for `packing` and another dependent entity called `entity2` for `dispatching`. A new dependency between the two entities can be created using the following command:

  ```
    initialize_dependency! from: entity1.id, to: entity2.id, type: 'dispatch'
  ```

This will create a dependency in `pending` state. In this case `packing` is a strict prerequisite for `dispatching`, hence `entity2` should not start unless the dependency is in `resolved` state. This is also the case for any dependencies of type `dispatch`. This can be defined by declaring a dependency characteristics using:

```
  declare_dependency type: :dispatch,
                     resolver: :send_packing_complete_confirmation,
                     before_resolution: [:check_packing_complete?, :check_dispatcher_available?],
                     after_resolution: [:send_dispatch_notification]
```

This declaration will ensure that for all dependencies of type `dispatch`, all `before_resolution` hooks are first run. If any `before_resolution` functions returns false, then the operation is aborted. If all `before_resolution` functions return true, then the resolver code inside `send_packing_complete_confirmation` will be executed, and then all functions inside `after_resolution` would be executed.

To kick-off this flow just call `dependency.resolve` and the before and after hooks will be invoked in the manner as described above.

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

Entity names for dependencies and dependents are configurable and can be set in `config/initializers/brace_comb.rb` before creating the migrations.

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
                        before_resolution: [:completed_status?],
                        after_resolution: [:complete_job]
   ```

   or

   b. Using a proc in the resolver

   ```
     declare_dependency type: :shopping,
                        resolver: ->(data) { data.condition },
                        before_resolution: [:completed_status?],
                        after_resolution: [:complete_job]
   ```
3. Create dependencies between the dependent class by using the following helper in any instance method of a model class:

   - When an exception needs to be raised:
   `initialize_dependency! from: job1, to: job2, type: 'shopping'`

   or
   - When a boolean needs to be returned:
   `initialize_dependency from: job1, to: job2, type: 'shopping'`

5. Resolve dependencies from any active record model by using:

   - When an exception needs to be raised:
   ```
     dependency.resolve!(identifier: 123, status: :resolved)
   ```

   or
   - When a boolean needs to be returned:

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

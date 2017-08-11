require 'job_dependency/dependency_helper'
require 'job_dependency/dependency_model'

module JobDependency
  module Dependency
    include JobDependency::Helper::ClassMethods
    include JobDependency::Model::InstanceMethods
  end
end
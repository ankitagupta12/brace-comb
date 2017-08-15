require 'brace_comb/dependency_helper'
require 'brace_comb/dependency_model'

module BraceComb
  module Dependency
    include BraceComb::Helper::ClassMethods
    include BraceComb::Model::InstanceMethods
  end
end
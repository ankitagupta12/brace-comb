require 'spec_helper'
class DependentTable
  def moo
    dependent_class = ::BraceComb.dependent_model
    with_model dependent_class do
      table do |t|
        t.timestamps null: false
      end
    end
  end
end

module BraceComb
  module Exceptions
    class CallbackFailure < StandardError
      def initialize(msg = 'Callback failed')
        super
      end
    end
  end
end
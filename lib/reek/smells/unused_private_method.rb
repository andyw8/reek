require_relative 'smell_detector'
require_relative 'smell_warning'

module Reek
  module Smells
    #
    # TODO: Description
    # TODO: See {file:docs/Unused-Private-Method.md} for details.
    class UnusedPrivateMethod < SmellDetector
      def self.contexts
        [:class, :module]
      end

      #
      # @param ctx [Context::ModuleContext]
      # @return [Array<SmellWarning>]
      #
      def examine_context(ctx)
        unused_private_methods(ctx).map do |name|
          smell_warning(
            context: ctx,
            lines: [ctx.exp.line],
            message: "has the unused private method #{name}",
            parameters: { name: name })
        end
      end

      private

      def unused_private_methods(ctx)
        private_methods_defined = ctx.defined_methods(visibility: :private)
        private_methods_called  = private_methods_defined & ctx.method_calls
        private_methods_defined - private_methods_called
      end
    end
  end
end

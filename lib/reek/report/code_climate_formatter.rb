require 'codeclimate_engine'
require 'private_attr'

module Reek
  module Report
    # Generates a hash in the structure specified by the Code Climate engine spec
    class CodeClimateFormatter
      private_attr_reader :warning

      def initialize(warning)
        @warning = warning
      end

      def render
        CCEngine::Issue.new(check_name: check_name,
                            description: description,
                            categories: categories,
                            location: location
                           ).render
      end

      private

      def description
        [warning.context, warning.message].join(' ')
      end

      def check_name
        [warning.smell_category, warning.smell_type].join('/')
      end

      def categories
        # TODO: provide mappings for Reek's smell categories
        ['Complexity']
      end

      def location
        warning_lines = warning.lines
        CCEngine::Location::LineRange.new(
          # path: warning.source,
          path: warning.source.split("/code/")[1],
          line_range: warning_lines.sort.first..warning_lines.sort.last
        )
      end
    end
  end
end

# encoding: utf-8

module QueryBuilder::CQL

  module Statements

    # Describes the 'INSERT' CQL3 statement
    #
    class Insert < Base

      include Modifiers::IfNotExists
      include Modifiers::UsingOptions

      # Adds USING clause to the statement
      #
      # @param [Hash] options
      #
      # @return [QueryBuilder::Statements::Insert]
      #
      def using(options)
        options
          .map { |key, value| Clauses::Using.new(property: key, value: value) }
          .inject(self, :<<)
      end

      # Defines value to be inserted
      #
      # @param [Hash] options
      #
      # @return [QueryBuilder::Statements::Insert]
      #
      def set(options)
        options.flat_map do |key, value|
          [Clauses::Field.new(name: key), Clauses::Value.new(name: value)]
        end.inject(self, :<<)
      end

      # Builds the statement
      #
      # @return [String]
      #
      def to_s
        cql[
          "INSERT INTO", context.to_s, maybe_columns, "VALUES", maybe_values,
          maybe_using, maybe_if
        ]
      end

      private

      def maybe_columns
        "(#{clauses(:field).join(", ")})"
      end

      def maybe_values
        "(#{clauses(:value).join(", ")})"
      end

    end # class Insert

  end # module Statements

end # module QueryBuilder::CQL

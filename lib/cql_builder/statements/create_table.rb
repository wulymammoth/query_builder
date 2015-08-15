# encoding: utf-8

module CQLBuilder

  module Statements

    # Describes the 'CREATE TABLE' CQL3 statement
    #
    class CreateTable < Statement

      attribute :name, required: true

      # Adds IF NOT EXISTS clause to the statement
      #
      # @return [CQLBuilder::Statements::CreateTable]
      #
      def if_not_exists
        self << Clauses::IfExists.new(reverse: true)
      end

      # Defines keyspace for the table
      #
      # @param [#to_s] name
      #
      # @return [CQLBuilder::Statements::CreateTable]
      #
      def use(name)
        self << Clauses::Use.new(name: name)
      end

      # Defines a primary key for the table
      #
      # @param [#to_s, Array<#to_s>] columns
      #
      # @return [CQLBuilder::Statements::CreateTable]
      #
      def primary_key(*columns)
        self << Clauses::PrimaryKey.new(columns: columns)
      end

      # Adds column to the table
      #
      # @param [#to_s] name
      # @param [#to_s] type_name
      # @param [Hash] options
      # @option options [Boolean] :static
      #
      # @return [CQLBuilder::Statements::CreateTable]
      #
      def column(name, type_name, options = {})
        self << Clauses::Column
          .new(name: name, type_name: type_name, static: options[:static])
      end

      # Adds CLUSTERNING ORDER clause to the statement
      #
      # @param [#to_s] name The name of the column
      # @param [:asc, :desc] order The order of clustering
      #
      # @return [CQLBuilder::Statements::CreateTable]
      #
      def clustering_order(name, order = :asc)
        self << Clauses::ClusteringOrder
          .new(name: name, desc: order.equal?(:desc))
      end

      # Adds COMPACT STORAGE clause to the statement
      #
      # @return [CQLBuilder::Statements::CreateTable]
      #
      def compact_storage
        self << Clauses::CompactStorage.new
      end

      # Adds WITH clause(s) to the statement
      #
      # @param [Hash] options
      #
      # @return [CQLBuilder::Statements::CreateTable]
      #
      def with(options)
        options
          .map { |key, value| Clauses::With.new(column: key, value: value) }
          .inject(self, :<<)
      end

      # Builds the statement
      #
      # @return [String]
      #
      def to_s
        cql["CREATE TABLE", maybe_exists, full_name, "(#{columns})", withs]
      end

      private

      def maybe_exists
        clauses(:if_exists)
      end

      def full_name
        keyspace = clauses(:use).last
        (keyspace ? "#{keyspace}." : "") << name.to_s
      end

      def withs
        list = clauses(:with)
        ["WITH", list.join(" AND ")] if list.any?
      end

      def columns
        (clauses(:column) + [clauses(:primary_key).last]).compact.join(", ")
      end

    end # class CreateTable

  end # module Statements

end # module CQLBuilder
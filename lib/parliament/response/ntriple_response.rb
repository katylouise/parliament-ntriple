require 'forwardable'

module Parliament
  module Response
    # N-Triple response object that wraps an Array of Grom::Node objects with common helper methods.
    #
    # Delegates a number of common methods to the array of Grom::Nodes including, but not limited to, :size, :each, :map, :count etc.
    #
    # @since 0.1.0
    #
    # @see Parliament::Response::BaseResponse#initialize
    #
    # @attr_reader [Array<Grom::Node>] nodes Graph nodes.
    class NTripleResponse < Parliament::Response::BaseResponse
      include Enumerable
      extend Forwardable
      attr_reader :nodes
      def_delegators :@nodes, :size, :each, :select, :map, :select!, :map!, :count, :length, :[], :empty?

      # @param [Array<Grom::Node>] nodes An array of nodes the response should wrap
      def initialize(nodes)
        @nodes = nodes
      end

      # Given our array of Grom::Nodes, filter them into arrays of 'types' of nodes.
      #
      # Note: this method assumes all of your nodes include a #type attribute or are blank nodes.
      #
      # @since 0.1.0
      #
      # @example Filtering for a single type
      #    node_1 = Grom::Node.new
      #    node_1.instance_variable_set(:type, 'type_1')
      #    node_2 = Grom::Node.new
      #    node_2.instance_variable_set(:type, 'type_3')
      #    node_3 = Grom::Node.new
      #    node_3.instance_variable_set(:type, 'type_1')
      #    node_4 = Grom::Node.new
      #    node_4.instance_variable_set(:type, 'type_2')
      #    nodes = [node_1, node_2, node_3, node_4]
      #
      #    response = Parliament::Response::NTriple.new(nodes)
      #    response.filter('type_2') #=> [#<Grom::Node @type='type_2'>]
      #
      # @example Filtering for multiple types
      #    node_1 = Grom::Node.new
      #    node_1.instance_variable_set(:type, 'type_1')
      #    node_2 = Grom::Node.new
      #    node_2.instance_variable_set(:type, 'type_3')
      #    node_3 = Grom::Node.new
      #    node_3.instance_variable_set(:type, 'type_1')
      #    node_4 = Grom::Node.new
      #    node_4.instance_variable_set(:type, 'type_2')
      #    nodes = [node_1, node_2, node_3, node_4]
      #
      #    response = Parliament::Response::NTripleResponse.new(nodes)
      #    response.filter('type_2', 'type_1') #=> [[#<Grom::Node @type='type_2'>], [#<Grom::Node @type='type_1'>, #<Grom::Node @type='type_1'>]]
      #
      #    # Also consider
      #    type_2, type_1 = response.filter('type_2', 'type_1')
      #    type_2 #=> [#<Grom::Node @type='type_2'>]
      #    type_1 #=> [#<Grom::Node @type='type_1'>, #<Grom::Node @type='type_1'>]
      #
      # @example Filtering blank nodes
      #    node_1 = Grom::Node.new
      #    node_1.instance_variable_set(:type, 'type_1')
      #    node_2 = Grom::Node.new
      #    node_3 = Grom::Node.new
      #    node_3.instance_variable_set(:type, 'type_1')
      #    nodes = [node_1, node_2, node_3]
      #
      #    response = Parliament::Response::NTripleResponse.new(nodes)
      #    response.filter(Grom::Node::BLANK) #=> [#<Grom::Node>]
      #
      # @param [Array<String>] types An array of type strings that you are looking for.
      # @return [Array<Grom::Node> || Array<*Array<Grom::Node>>] If you pass one type, this returns an Array of Grom::Node objects. If you pass multiple, it returns an array, of arrays of Grom::Node objects.
      def filter(*types)
        filtered_objects = Array.new(types.size) { [] }

        unless types.empty?
          @nodes.each do |node|
            node_types = node.blank? ? Array(::Grom::Node::BLANK) : Array(node.type)

            indexes = node_types.reduce([]) do |memo, type|
              index = types.index(type)
              memo << index if index

              memo
            end

            indexes.each { |index| filtered_objects[index] << node }
          end
        end

        result = build_responses(filtered_objects)

        types.size == 1 ? result.first : result
      end

      # Sort the Parliament::Response nodes in ascending order by a set of attributes on each node.
      #
      # @see Parliament::NTriple::Utils.sort_by
      #
      # @since 0.1.0
      #
      # @param [Array<Symbol>] parameters Attributes to sort on - left to right.
      # @return [Array<Grom::Node>] A sorted array of nodes.
      def sort_by(*parameters)
        Parliament::NTriple::Utils.sort_by(
          {
            list:       @nodes,
            parameters: parameters
          }
        )
      end

      # Sort the Parliament::Response nodes in ascending or descending order by a set of attributes on each node.
      #
      # @see Parliament::NTriple::Utils.multi_direction_sort
      #
      # @since 0.1.2
      #
      # @param [Hash<Symbol,Symbol>] parameters Attributes to sort on (left to right) - and their direction of sort(asc or desc).
      # @return [Array<Grom::Node>] A sorted array of nodes.
      def multi_direction_sort(parameters)
        Parliament::NTriple::Utils.multi_direction_sort(
          {
            list:       @nodes,
            parameters: parameters
          }
        )
      end

      # Sort the Parliament::Response nodes in descending order by a set of attributes on each node.
      #
      # @see Parliament::NTriple::Utils.reverse_sort_by
      #
      # @since 0.1.0
      #
      # @param [Array<Symbol>] parameters Attributes to sort on - left to right.
      # @return [Array<Grom::Node>] A sorted array of nodes.
      def reverse_sort_by(*parameters)
        Parliament::NTriple::Utils.reverse_sort_by(
          {
            list:       @nodes,
            parameters: parameters
          }
        )
      end

      private

      def build_responses(filtered_objects)
        result = []

        filtered_objects.each do |objects|
          result << Parliament::Response::NTripleResponse.new(objects)
        end
        result
      end
    end
  end
end

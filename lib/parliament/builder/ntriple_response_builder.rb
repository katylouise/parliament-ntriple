module Parliament
  module Builder
    # N-Triple response builder, allowing the user to build a Parliament::Response::NTripleResponse from n-triple data.
    #
    # @since 0.1.0
    class NTripleResponseBuilder < Parliament::Builder::BaseResponseBuilder
      # Creates an instance of Parliament::Builder::NTripleResponseBuilder.
      #
      # @see Parliament::BaseResponse#initialize
      #
      # @param [HTTPResponse] response an HTTP response containing n-triple data.
      # @param [Module] decorators the decorator module to provide alias methods to the resulting objects.
      # @example Using the Grom Decorators module
      #   Parliament::Builder::NTripleResponseBuilder.new(response: <#HTTPResponse>, decorators: Parliament::Grom::Decorator)
      def initialize(response:, decorators: nil)
        @decorators = decorators

        super
      end

      # Builds a Parliament::Response::NTripleResponse from the n-triple data.
      #
      # @return [Parliament::Response::NTripleResponse] a Parliament::Response::NTripleResponse containing decorated Grom::Node objects.
      def build
        objects = ::Grom::Reader.new(@response.body).objects
        objects.map { |object| @decorators.assign_decorator(object) } unless @decorators.nil?

        Parliament::Response::NTripleResponse.new(objects)
      end
    end
  end
end

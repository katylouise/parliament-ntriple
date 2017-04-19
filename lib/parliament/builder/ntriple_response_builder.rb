module Parliament
  module Builder
    # API response builder, allowing the user to build a Parliament::Response::NTripleResponse from n-triple data.
    class NTripleResponseBuilder < Parliament::Builder::BaseResponseBuilder
      # Creates an instance of NTripleResponseBuilder.
      #
      # @since 0.1.0
      #
      # @see Parliament::BaseResponse#initialize
      #
      # @param [HTTPResponse] response an HTTP response containing n-triple data.
      # @param [Parliament::Grom::Decorator] decorators the decorator modules to provide alias methods to the resulting objects.
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

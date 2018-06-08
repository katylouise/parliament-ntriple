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
        encoded_body = encode_to_utf8(@response.body)
        encoded_body_without_bom = remove_byte_order_mark(encoded_body)

        objects = ::Grom::Reader.new(encoded_body_without_bom).objects
        objects.map! { |object| @decorators.decorate(object) } unless @decorators.nil?

        Parliament::Response::NTripleResponse.new(objects)
      end

      private

      # Encodes HTTP response body to UTF-8
      #
      # @param [String] HTTP response string containing n-triple data.
      # @return [String] a UTF-8 response body string.
      def encode_to_utf8(response_body)
        response_body.force_encoding('UTF-8')
      end

      # Removes byte order mark (BOM) from UTF-8 response body string
      #
      # @param [String] UTF-8 HTTP response string containing BOM and n-triple data.
      # @return [String] a UTF-8 response body string without BOM.
      def remove_byte_order_mark(response_body)
        response_body.gsub!("\xEF\xBB\xBF".force_encoding('UTF-8'), '')
        response_body
      end
    end
  end
end

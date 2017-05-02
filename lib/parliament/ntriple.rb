# Namespace for classes and modules that handle connections to, and processing of data from the parliamentary API.
# @since 0.1.0
module Parliament
  # NTriple namespace
  # @since 0.1.0
  module NTriple
    class << self
      def load!
        if parliament_response?
          register_parliament_response
          register_ntriple_response
        else
          raise(LoadError, "Missing requirement 'Parliament::Response'. Have you added `gem 'parliament-ruby'` to your Gemfile?")
        end

        if parliament_builder?
          register_parliament_builder
          register_ntriple_builder
        else
          raise(LoadError, "Missing requirement 'Parliament::Builder'. Have you added `gem 'parliament-ruby'` to your Gemfile?")
        end

        register_grom
        register_ntriple
      end

      def parliament_response?
        defined?(::Parliament::Response)
      end

      def parliament_builder?
        defined?(::Parliament::Builder)
      end

      def register_parliament_response
        require 'parliament/response'
      end

      def register_parliament_builder
        require 'parliament/builder'
      end

      def register_ntriple_response
        require 'parliament/response/ntriple_response'
      end

      def register_ntriple_builder
        require 'parliament/builder/ntriple_response_builder'
      end

      def register_ntriple
        require 'parliament/ntriple/version'
        require 'parliament/ntriple/utils'
      end

      def register_grom
        require 'grom'
      end
    end
  end
end

Parliament::NTriple.load!

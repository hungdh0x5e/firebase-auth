require "firebase/auth/version"
require 'firebase/auth/response'
require 'firebase/auth/config'
require 'rest-client'
require 'json'

module Firebase
  module Auth
    class Client
      attr_reader :api_key

      def initialize(api_key)
        raise ArgumentError.new('Missing api_key') if (api_key.nil? || api_key.empty?)

        @api_key = api_key
      end

      def sign_up_email(email, password)
        data = {
          email: email, password: password, returnSecureToken: true
        }
        process(:post, Config::SIGN_UP_EMAIL, data)
      end


      private
      def process(verb, path, data=nil)
        byebug
        RestClient::Request.execute(method: verb,
                                    url: "#{Config::BASE_URI}/#{path}",
                                    headers: { 'Content-Type': 'application/json' },
                                    payload: data.to_json,
                                    query: { key: @api_key },
                                    timeout: 10)
      end
    end
  end
end

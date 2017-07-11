require_relative "auth/version"
require_relative 'auth/response'
require_relative 'auth/config'
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

      # Create a new email and password user
      # Params:
      #   @email: The email for the user to create.
      #   @password: The password for the user to create.
      # Error:
      #   [EMAIL_EXISTS, OPERATION_NOT_ALLOWED, TOO_MANY_ATTEMPTS_TRY_LATER]
      # Referrences:
      #   https://firebase.google.com/docs/reference/rest/auth/#section-create-email-password
      def sign_up_email(email, password)
        data = {
          email: email, password: password, returnSecureToken: true
        }
        process(:post, Config::SIGN_UP_EMAIL, data)
      end

      # Sign in a user with an email and password
      # # Params:
      #   @email:
      #   @password:
      # Error:
      #   [EMAIL_NOT_FOUND, INVALID_PASSWORD, USER_DISABLED]
      # Referrences:
      #   https://firebase.google.com/docs/reference/rest/auth/#section-create-email-password
      def sign_in_email(email, password)
        data = {
          email: email, password: password, returnSecureToken: true
        }
        process(:post, Config::SIGN_IN_EMAIL, data)
      end

      # Sign in a user anonymously
      def sign_in_anonymously
        data = { returnSecureToken: true }
        process(:post, Config::SIGN_UP_EMAIL, data)
      end

      # Sign in with OAuth credential
      # Params:
      #   @provider: [facebook.com, google.com, github.com, twitter.com]
      #   @access_token: OAuth credential
      #   @request_uri: The URI to which the IDP redirects the user back.
      # Error
      #   [OPERATION_NOT_ALLOWED, INVALID_IDP_RESPONSE]
      def sign_in_oauth(provider, access_token, request_uri)
        data = {
          request_uri: request_uri,
          postBody: "access_token=#{access_token}&providerId=#{provider}",
          returnSecureToken: true,
          returnIdpCredential: true
        }

        process(:post, Config::SIGN_IN_OAUTH, data)
      end

      # Fetch providers for email
      # Params:
      #   @email: User's email address
      #   @continue_uri: The URI to which the IDP redirects the user back
      # Error
      #   [INVALID_EMAIL]
      def fetch_providers_for_email(email, continue_uri)
        data = { identifier: email, continueUri: continue_uri }

        process(:post, Config::GET_PROVIDERS_FOR_EMAIL, data)
      end

      # Send code confirmation to reset password via email
      # Params:
      #   @email: User's email address want reset password
      # Error
      #   [EMAIL_NOT_FOUND]
      def send_confirm_code(email)
        data = {
          email: email,
          requestType: Param::PASSWORD_RESET
        }

        process(:post, Config::SEND_CODE_CONFIRM, data)
      end

      # Verify password reset code
      # Params:
      #   @code: code received though email
      # Error
      #   [OPERATION_NOT_ALLOWED, EXPIRED_OOB_CODE, INVALID_OOB_CODE]
      def verfify_password_code(code)
        data = { oobCode: code }

        process(:post, Config::VERIFY_CODE_RESET_PWD, data)
      end

      # Reset password
      # Params:
      #   @code: code received though email
      #   @password: new password want change
      # Error
      #   [OPERATION_NOT_ALLOWED, EXPIRED_OOB_CODE, INVALID_OOB_CODE]
      def reset_password(code, password)
        data = { oobCode: code, newPassword: password }

        process(:post, Config::RESET_PASSWORD, data)
      end

      # Change a user's email
      # Params:
      #   @token: user's token
      #   @email: the user's new email.
      # Error
      #   [EMAIL_EXISTS, INVALID_ID_TOKEN]
      def change_email(token, email)
        data = { idToken: token, email: email, returnSecureToken: true}

        process(:post, Config::SET_ACCOUNT_INFO, data)
      end

      # Change a user's password
      # Params:
      #   @token: user's token
      #   @password: User's new password.
      # Error
      #   [INVALID_ID_TOKEN, WEAK_PASSWORD]
      def change_password(token, password)
        data = { idToken: token, password: password, returnSecureToken: true }

        process(:post, Config::SET_ACCOUNT_INFO, data)
      end

      # Update user's profile
      # Params:
      #   @token: user's token
      #   @user_name: User's new display name
      #   @photo_url: User's new photo url
      # Error
      #   [INVALID_ID_TOKEN]
      def update_profile(token, user_name, photo_url)
        data = {
          idToken: token, displayName: user_name,
          photoUrl: photo_url, returnSecureToken: true
        }

        process(:post, Config::SET_ACCOUNT_INFO, data)
      end

      #
      # Get account info
      # Params:
      #   @token: The Firebase ID token of the account
      # Error
      #   [INVALID_ID_TOKEN, USER_NOT_FOUND]
      def get_account_info(token)
        data = { idToken: token }

        process(:post, Config::GET_ACCOUNT_INFO, data)
      end

      private
      def process(verb, path, data=nil)
        begin
          RestClient::Request.execute(method: verb,
                                    url: "#{Config::BASE_URI}/#{path}?key=#{api_key}",
                                    headers: { 'Content-Type': 'application/json' },
                                    payload: data.to_json,
                                    timeout: 10)
        rescue RestClient::ExceptionWithResponse => e
          e.response
        end
      end
    end
  end
end

@firebase = Firebase::Auth::Client.new('AIzaSyB4XAT6JK_JTzMjz7IHiIq7rlt7Yiah3co')
data = {
  email: "huyhung1994@gmail.com",
  password: "12345678"
}
rest = @firebase.get_account_info("eyJhbGciOiJSUzI1NiIsImtpZCI6ImFhYjNkMDliMjAyNmQyNDNkOWEzZWUwYzJkM2M1YzRhYTNiZTQwNTEifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZmlyLWF1dGgtZ2VtIiwiYXVkIjoiZmlyLWF1dGgtZ2VtIiwiYXV0aF90aW1lIjoxNDk5Nzc2OTY3LCJ1c2VyX2lkIjoieW0xcFQwVFBNOFhxdWw4SklUbTdZUDBxWHd4MiIsInN1YiI6InltMXBUMFRQTThYcXVsOEpJVG03WVAwcVh3eDIiLCJpYXQiOjE0OTk3NzY5NjcsImV4cCI6MTQ5OTc4MDU2NywiZW1haWwiOiJodXlodW5nMTk5NEBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsiaHV5aHVuZzE5OTRAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.lN0mYHZ6EMV4B3lmNP6DPjjYVcKFeuvE2WXlwFgN0Thc_gywB_8FArq2SnpmwMUF5jsM07HvGVaOysGoRz6DqmmUmneqG5riCMBzTXwkRvMwD6iKSn34x3ZViqpM81axp1gqe9mEWryfT-gMwjrTGinBFIMZUH-N158pQBWu6SQDnnAEZeY7J4st6m0Ha2ktAEiYDb_5_g-qGXU-KLrAXuKWyU42PJnLlqHfRuWMSCg-wzd0Tlke_yyD4e3bKrA_pOWoJxt600eIhNTVRg_d0COqXe7v8g5rXjSCOGXUpWEyXyaj7G8dDUbJnMCnT16gnTJJg_1SI0KGqQRqIN26eQ")
puts rest.code
puts rest
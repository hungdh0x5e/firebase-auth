require 'firebase/auth/version'
require 'firebase/auth/config'
require 'firebase/auth/response'
require 'firebase/configuration'
require 'rest-client'
require 'json'

module Firebase
  module Auth
    class Client
      attr_reader :api_key

      def initialize(api_key=Firebase.configuration.api_key)
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
      def sign_up_email(email, password, options={})
        data = {
          email: email, password: password,
          displayName: options[:display_name],
          returnSecureToken: true
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
          requestUri: request_uri,
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

      # Get account info
      # Params:
      #   @token: The Firebase ID token of the account
      # Error
      #   [INVALID_ID_TOKEN, USER_NOT_FOUND]
      def get_account_info(token)
        data = { idToken: token }

        process(:post, Config::GET_ACCOUNT_INFO, data)
      end

      # Link new account (email/ password) with user exist
      # Param:
      #   @token: token of main user
      #   @email: user's email want link
      #   @password: user's password want link
      # Error
      #   [CREDENTIAL_TOO_OLD_LOGIN_AGAIN, TOKEN_EXPIRED,
      #     INVALID_ID_TOKEN, WEAK_PASSWORD]
      def link_with_email(token, email, password)
        data = {
          idToken: token,
          email: email, password: password,
          returnSecureToken: true
        }

        process(:post, Config::SET_ACCOUNT_INFO, data)
      end

      # Link new account (email/ password) with user exist
      # Param:
      #   @token: token of main user
      #   @email: user's email want link
      #   @password: user's password want link
      # Error
      #   [CREDENTIAL_TOO_OLD_LOGIN_AGAIN, TOKEN_EXPIRED,
      #     INVALID_ID_TOKEN, WEAK_PASSWORD]
      def link_with_oauth(token, provider, access_token, redirect_uri)
        data = {
          idToken: token, requestUri: redirect_uri,
          postBody: "id_token=#{access_token}&providerId=#{provider}",
          returnSecureToken: true, returnIdpCredential: true
        }

        process(:post, Config::SET_ACCOUNT_INFO, data)
      end

      # Unlink between account
      # Params:
      #   @token: user's token want unlink
      #   @providers: list of provider want unlink
      # Error
      #   [INVALID_ID_TOKEN]
      def unlink_provider(token, providers=[])
        data = { idToken: token, deleteProvider: providers }

        process(:post, Config::SET_ACCOUNT_INFO, data)
      end

      # Send email verification
      # Params:
      #   @token: user's token
      #  Error
      #   [INVALID_ID_TOKEN, USER_NOT_FOUND]
      def send_email_verify(token)
        data = { idToken: token, requestType: Param::VERIFY_EMAIL }

        process(:post, Config::SEND_CODE_CONFIRM, data)
      end

      # Verify email by code
      # Params:
      #   @code:
      # Error
      #   [EXPIRED_OOB_CODE, INVALID_OOB_CODE,
      #     USER_DISABLED, EMAIL_NOT_FOUND]
      def confirm_email(code)
        data = { oobCode: code }

        process(:post, Config::SET_ACCOUNT_INFO, data)
      end

      def delete_account(token)
        data = { idToken: token }

        process(:post, Config::DELETE_ACCOUNT, data)
      end

      def refresh_token(refresh_token)
        data = {
          grant_type: Param::REFRESH_TOKEN,
          refresh_token: refresh_token
        }

        begin
          Firebase::Auth::Response.new RestClient::Request.execute(method: :post,
                                    url: "#{Config::EXCHANGE_REFRESH_TOKEN}?key=#{api_key}",
                                    headers: { 'Content-Type': 'application/json' },
                                    payload: data.to_json,
                                    timeout: 10)
        rescue RestClient::ExceptionWithResponse => e
          Firebase::Auth::Response.new e.response
        end
      end

      # Additional Get certificate sign token (JWT)
      def get_certificate
        begin
          res = RestClient::Request.execute(method: :get,
                                    url: "#{Config::GET_CERTIFICATE}",
                                    timeout: 10)
          certificates = JSON.parse(res.body)
        rescue RestClient::ExceptionWithResponse => e
          Firebase::Auth::Response.new e.response
        end
      end

      private
      def process(verb, path, data=nil)
        begin
          Firebase::Auth::Response.new RestClient::Request.execute(method: verb,
                                    url: "#{Config::BASE_URI}/#{path}?key=#{api_key}",
                                    headers: { 'Content-Type': 'application/json' },
                                    payload: data.to_json,
                                    timeout: 10)
        rescue RestClient::ExceptionWithResponse => e
          Firebase::Auth::Response.new e.response
        end
      end
    end
  end
end

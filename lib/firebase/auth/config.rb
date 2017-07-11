module Firebase
  module Auth
    module Config
      BASE_URI = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty'
      VERIFY_TOKEN_VERSION = 'verifyCustomToken'
      EXCHANGE_REFRESH_TOKEN = 'https://securetoken.googleapis.com/v1/token'
      SIGN_UP_EMAIL = 'signupNewUser'
      SIGN_IN_EMAIL = 'verifyPassword'
      SIGN_IN_OAUTH = 'verifyAssertion'

      SEND_CODE_CONFIRM = 'getOobConfirmationCode'
      RESET_PASSWORD = 'resetPassword'

      SET_ACCOUNT_INFO = 'setAccountInfo'
      GET_ACCOUNT_INFO = 'getAccountInfo'
      GET_PROVIDERS_FOR_EMAIL = 'createAuthUri'

      DELETE_ACCOUNT = 'deleteAccount'
    end

    module Param
      PASSWORD_RESET = 'PASSWORD_RESET'
      VERIFY_EMAIL = 'VERIFY_EMAIL'
    end
  end
end

require "spec_helper"

describe Firebase::Auth do

  it "has a version number" do
    expect(Firebase::Auth::VERSION).not_to be nil
  end

  it 'should raise if api_key missing' do
    expect{ Firebase::Auth::Client.new('') }.to raise_error(ArgumentError)
  end

  before do
    @firebase = Firebase::Auth::Client.new('AIzaSyB4XAT6JK_JTzMjz7IHiIq7rlt7Yiah3co')
  end

  describe 'sign up with email' do
    it 'return data' do
      data = {
        email: "email_test@gmail.com",
        password: "12345678",
        displayName: nil,
        returnSecureToken: true
      }
      expect(@firebase).to receive(:process).with(:post, Firebase::Auth::Config::SIGN_UP_EMAIL, data)
      @firebase.sign_up_email(data[:email], data[:password])
    end
  end
end

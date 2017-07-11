require 'jwt'
require 'rest-client'
require 'json'

token2 = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImQyZTg1ZjY1ZDMxNGQwOTVmY2Y1MjJjZTU2YWVlOTkwMjBkMGFiNDIifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZmlyLTQ2ZWJkIiwibmFtZSI6IlF14buzbmggTmd1eeG7hW4iLCJwaWN0dXJlIjoiaHR0cHM6Ly9zY29udGVudC54eC5mYmNkbi5uZXQvdi90MS4wLTEvczEwMHgxMDAvMTM3MTYwODlfMTc1ODkxMzE2NDM3MDg5NV81MDUwMzI1NTE2NDc5NTU3OTcyX24uanBnP29oPTQzZjJhZDE4MWQ3ZjA3NDhkMGZjYWZlZTZhN2YxY2Q4Jm9lPTVBMEREMUIyIiwiYXVkIjoiZmlyLTQ2ZWJkIiwiYXV0aF90aW1lIjoxNDk5NDExODM1LCJ1c2VyX2lkIjoiZWRYMFdSWWs0M1hsbXROcDJkM1F4WDhiQU1HMiIsInN1YiI6ImVkWDBXUllrNDNYbG10TnAyZDNReFg4YkFNRzIiLCJpYXQiOjE0OTk0MTE4MzYsImV4cCI6MTQ5OTQxNTQzNiwiZW1haWwiOiJodW5nZGgxMjNAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImZhY2Vib29rLmNvbSI6WyIxOTMxOTU4NzAzNzMzMDA2Il0sImVtYWlsIjpbImh1bmdkaDEyM0BnbWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.cNKUzW8_i_mHNdmJ6MPl-TeuLoa0HJOxegJ5NDurMoeziRvvBkYwPI9mXKUd5sBiBmouNtqxPm2FOMz2ZokNBEGmFkC9nLWo_KFudDL3oNF9jeyfplcL4geiGzThjzkb9QnJFpqQCiGdM79m70rC0Grk2cyRye56cz0JkVzczJKMWVENiq--NeXCOhByQfvw-Fg4JgnMZBnlKR1T06KZrgqBJFsvVSU_0AX-8y9nZrOJsDZ0AOrp3IczqNhoW3vyJ88UnzbDD-FgZBPwGpS4LO4Vcri7M85pRDCbwT1MSOVO3Y6XAfnekSW9koWrbHS-HGyeHvaQgtsJzybbGABatg"

token = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImFhYjNkMDliMjAyNmQyNDNkOWEzZWUwYzJkM2M1YzRhYTNiZTQwNTEifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZmlyLWF1dGgtZ2VtIiwibmFtZSI6IsSQ4buXIEh1eSBIw7luZyIsInBpY3R1cmUiOiJodHRwczovL3Njb250ZW50Lnh4LmZiY2RuLm5ldC92L3QxLjAtMS9wMTAweDEwMC8xNDA3OTQ4N18xMDI5OTIwNTY3MTI2NTM3XzkwOTkwMTgyMDMxNjk5NTc1MjBfbi5qcGc_b2g9NDQ4ZWU0MjUwZjM2NGNjNTVmMjlmODM0NmM1NjRjYTcmb2U9NUEwRjAzM0IiLCJhdWQiOiJmaXItYXV0aC1nZW0iLCJhdXRoX3RpbWUiOjE0OTk3NzkzNjEsInVzZXJfaWQiOiJFblJjWnhNb1RVZzhSaURLenFTRFpITUZWbHQyIiwic3ViIjoiRW5SY1p4TW9UVWc4UmlES3pxU0RaSE1GVmx0MiIsImlhdCI6MTQ5OTc4MDEyNiwiZXhwIjoxNDk5NzgzNzI2LCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImZhY2Vib29rLmNvbSI6WyIxMzQ5NDA5MTkxODQ0MzM4Il19LCJzaWduX2luX3Byb3ZpZGVyIjoiZmFjZWJvb2suY29tIn19.AS1sGQ57GlCsrdAfbgC_wcECc0B-V4s8MdrHbBro6BrWqtyA8W9B57tT-3ByBDPxO4h5cem3pU4L2MVk7cgsaShqDrPxdcTaLoB25GTVNiXuvwkm0ma0K9KBUwTLnc1_97Z4oAxKdggZh8euSVrIqrbPZ2HTVWJ_OzeiadCvuza5JF4b93in2RT7E5DfDM6in13BlBj57GEHzL4fowGHONH-6elXeeLM9HUGZHYuF-Cpz2Xdgedg4iVMFlW1nb8-Xu4Tb9xEyB8XyLSsjSj9oBHYkwp3EqXJJgo0Is5W10yibr-6HcLqz6x86REWJRz013LQzAinAxqWXaoEO6EEyg"

url_pbk = "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"
res = RestClient::Request.execute(method: :get, url: url_pbk)
certificates = JSON.parse(res.body)

begin
  decoded_token = JWT.decode(token, '', false)
  puts decoded_token
  puts "-----------------------------------------"
  key_id = decoded_token[1]['kid']
  puts "Key id: #{key_id}"
  puts "-----------------------------------------"
  cert_pub = certificates["#{key_id}"]
  puts "Cert: #{cert_pub}"
  puts "-----------------------------------------"
  x509 = OpenSSL::X509::Certificate.new(cert_pub)
  decoded_token = JWT.decode(token, x509.public_key, true,
                              { algorithm: 'RS256', verify_iss: true,
                                iss: 'https://securetoken.google.com/fir-auth-gem',
                                aud: 'fir-auth-gem', verify_aud: true })
  puts decoded_token
rescue StandardError => e
  puts "[*] Error: #{e.message}"
end





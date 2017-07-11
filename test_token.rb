require 'jwt'
require 'rest-client'
require 'json'

token2 = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImQyZTg1ZjY1ZDMxNGQwOTVmY2Y1MjJjZTU2YWVlOTkwMjBkMGFiNDIifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZmlyLTQ2ZWJkIiwibmFtZSI6IlF14buzbmggTmd1eeG7hW4iLCJwaWN0dXJlIjoiaHR0cHM6Ly9zY29udGVudC54eC5mYmNkbi5uZXQvdi90MS4wLTEvczEwMHgxMDAvMTM3MTYwODlfMTc1ODkxMzE2NDM3MDg5NV81MDUwMzI1NTE2NDc5NTU3OTcyX24uanBnP29oPTQzZjJhZDE4MWQ3ZjA3NDhkMGZjYWZlZTZhN2YxY2Q4Jm9lPTVBMEREMUIyIiwiYXVkIjoiZmlyLTQ2ZWJkIiwiYXV0aF90aW1lIjoxNDk5NDExODM1LCJ1c2VyX2lkIjoiZWRYMFdSWWs0M1hsbXROcDJkM1F4WDhiQU1HMiIsInN1YiI6ImVkWDBXUllrNDNYbG10TnAyZDNReFg4YkFNRzIiLCJpYXQiOjE0OTk0MTE4MzYsImV4cCI6MTQ5OTQxNTQzNiwiZW1haWwiOiJodW5nZGgxMjNAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImZhY2Vib29rLmNvbSI6WyIxOTMxOTU4NzAzNzMzMDA2Il0sImVtYWlsIjpbImh1bmdkaDEyM0BnbWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.cNKUzW8_i_mHNdmJ6MPl-TeuLoa0HJOxegJ5NDurMoeziRvvBkYwPI9mXKUd5sBiBmouNtqxPm2FOMz2ZokNBEGmFkC9nLWo_KFudDL3oNF9jeyfplcL4geiGzThjzkb9QnJFpqQCiGdM79m70rC0Grk2cyRye56cz0JkVzczJKMWVENiq--NeXCOhByQfvw-Fg4JgnMZBnlKR1T06KZrgqBJFsvVSU_0AX-8y9nZrOJsDZ0AOrp3IczqNhoW3vyJ88UnzbDD-FgZBPwGpS4LO4Vcri7M85pRDCbwT1MSOVO3Y6XAfnekSW9koWrbHS-HGyeHvaQgtsJzybbGABatg"

token = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjA1OGExZGU4YWU4OTg5NWIwNWI2YWZlYWJkOTQwNDY3NTkwMmI4N2EifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZmlyLTQ2ZWJkIiwibmFtZSI6IlF14buzbmggTmd1eeG7hW4iLCJwaWN0dXJlIjoiaHR0cHM6Ly9zY29udGVudC54eC5mYmNkbi5uZXQvdi90MS4wLTEvczEwMHgxMDAvMTM3MTYwODlfMTc1ODkxMzE2NDM3MDg5NV81MDUwMzI1NTE2NDc5NTU3OTcyX24uanBnP29oPTQzZjJhZDE4MWQ3ZjA3NDhkMGZjYWZlZTZhN2YxY2Q4Jm9lPTVBMEREMUIyIiwiYXVkIjoiZmlyLTQ2ZWJkIiwiYXV0aF90aW1lIjoxNDk5Mzk5MTUzLCJ1c2VyX2lkIjoiZWRYMFdSWWs0M1hsbXROcDJkM1F4WDhiQU1HMiIsInN1YiI6ImVkWDBXUllrNDNYbG10TnAyZDNReFg4YkFNRzIiLCJpYXQiOjE0OTkzOTkxNTQsImV4cCI6MTQ5OTQwMjc1NCwiZW1haWwiOiJodW5nZGgxMkBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZmFjZWJvb2suY29tIjpbIjE5MzE5NTg3MDM3MzMwMDYiXSwiZW1haWwiOlsiaHVuZ2RoMTJAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoiZmFjZWJvb2suY29tIn19.gSulB047U4iYW3PFfx7iZe0EnoEwMyf-g5RUM2bOOxLZXFX9REQ_O_8Mjkhj3ZExQ-loguCRnbaqSdQnvK_cy1iv5iVK-C8RUUOQojEKfaIdgmbEXLpLoB402chreEsJObjKgv1aa_p3_u3AJtImeipI_0iKNQdo4vzCN7pYf6UAisl1SSouw11zAopWJw3gbG5eofX0w3boGM_QPhkOLZdnzV0yP0EhF9va7yjrvYJ8wE8oaTr5hUdCLileMo1pwHWG2Gx48qbB3lAfo86Qyn4brepmliisIxtQRlxnyM_vz9vtFhUSncG7UnwP3-KamckUA5MdxfFeUldVF8Hnew"

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
                                iss: 'https://securetoken.google.com/fir-46ebd',
                                aud: 'fir-46ebd', verify_aud: true })
  puts decoded_token
rescue StandardError => e
  puts "[*] Error: #{e.message}"
end





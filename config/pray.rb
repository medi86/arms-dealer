require 'openssl'
require 'json'

# see readme for how to get these values
session_cookie  = "cnUvRzJVVUREZkFNc29nelF4R1dIRFRueXFWWG5hK05xSUhKenBjd0I5MXpibmRPZ0Zpcm1VVTdnSkoyTmt4MDA3UDNGSkUyR2tNU013ZHNKWFlHSEF5UmVmQmt5TWNRZG9wZzA5ZFpJR0ZQRUljSWhBblVpdEx3UXFMSWNTZEF6Yzl6d1IwTjQ0clhuTStRWHAzK2szazByR05lZWJ1NUJ2SEM5aUFRMlhTWmR4djQ1eEZWd292aW16RWR6eGZrL25QeGJyVVY2OFZFYXh6dXpPd0pseTJrT0VxTmNuMXRBWkxWcE4vblJKQT0tLWRXaFlJT05xMUhlalFPSUMrWXFvZ2c9PQ"
secret_key_base = "f2c02d0f25af3d4db9c18f74e586e680758106a9232121bcdcf857b93d6a756b3766cace77137a5a0a186f77c4a69ada4449d4f37643e9c84c07c76f7f2c7012"


cipher                    = OpenSSL::Cipher::Cipher.new('aes-256-cbc').tap(&:decrypt)
cipher.key                = OpenSSL::PKCS5.pbkdf2_hmac_sha1(secret_key_base, 'encrypted cookie', 1000, 64) # salt, iterations, key length
unpack64                  = lambda { |str| str.unpack("m").first }
encrypted_data, cipher.iv = session_cookie.split("--").map(&unpack64).first.split("--").map(&unpack64)
JSON.parse cipher.update(encrypted_data) + cipher.final
# => {"session_id"=>"748bcbfeea44c914c17fcce7493bb93c",
#     "_csrf_token"=>"zhPR49wYPyUxtmNLnHO5OfwdAScktcl/QB0GiNPBcy4=",
#     "warden.user.user.key"=>[[1], "$2a$10$PWwP/OTCinH.HIh51rM5Me"]}


require 'action_dispatch'
ActionDispatch::Cookies::EncryptedCookieJar.new(
  { '_merchant_session' => session_cookie },
  ActiveSupport::KeyGenerator.new(secret_key_base, iterations: 1000),
  { encrypted_cookie_salt: 'encrypted cookie', encrypted_signed_cookie_salt: 'signed encrypted cookie', serializer: :json },
)['_merchant_session']
# => nil

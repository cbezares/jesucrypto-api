module ExchangesServices
  include CryptoData
  include CryptoServices
  include Notifier
  include HTTParty

  class Base
    @@firebase_private_key_string = {
      type: "service_account",
      project_id: ENV['FIREBASE-PROJECT-ID'],
      private_key_id: ENV['FIREBASE-PRIVATE-KEY-ID'],
      private_key: ENV['FIREBASE-PRIVATE-KEY'],
      client_email: ENV['FIREBASE-CLIENT-EMAIL'],
      client_id: ENV['FIREBASE-CLIENT-ID'],
      auth_uri: "https://accounts.google.com/o/oauth2/auth",
      token_uri: "https://accounts.google.com/o/oauth2/token",
      auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
      client_x509_cert_url: "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-p8jzi%40jesucrypto-api.iam.gserviceaccount.com"
    }.to_json

    @@base_uri  = "https://#{ENV['FIREBASE-PROJECT-ID']}.firebaseio.com/"
    @@firebase_client = Firebase::Client.new(@@base_uri, @@firebase_private_key_string)
  end

end
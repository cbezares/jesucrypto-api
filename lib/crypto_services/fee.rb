module CryptoServices
  class Fee < Base
    # Get today fee costs in BTC based in Satoshi
    # Doc: https://bitcoinfees.earn.com/api && https://bitcoinfees.earn.com/fees
    # Respo example:
    #  {"bestIndex":21,"maxCount":61514,"maxMemCount":27138,"medianTxSize":226,"fees":[
    #    {"minFee":0,"maxFee":0,"count":12,"memCount":0,"minDelay":23,"maxDelay":10000,"minMinutes":180,"maxMinutes":10000,"speed":0},
    #    ...,
    #    {"minFee":391,"maxFee":54800,"count":9355,"memCount":218,"minDelay":0,"maxDelay":0,"minMinutes":0,"maxMinutes":25,"speed":2}
    #  ]}
    def self.transfer_bitcoin
      satoshi = 0.00000001
      fee   = 0.0
      begin
        # url = "https://bitcoinfees.earn.com/api/v1/fees/recommended"
        url = "https://bitcoinfees.earn.com/fees"
        response = HTTParty.get(URI.escape(url), { timeout: 10.0 })
        response = JSON.parse(response.body)
        # value = response[velocity] * satoshi
        fee = response["medianTxSize"] * response["fees"][response["bestIndex"]]["maxFee"] * satoshi
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING TODAY BITCOIN TRANSFER FEE: #{e.inspect}"
      end
      fee.to_f
    end

    def self.get_all
      {
        "BTC" => self.transfer_bitcoin,
        "CHA" => 0.000736,
        "ETH" => 0.001,
        "BCH" => 0.001
      }
    end
  end
end
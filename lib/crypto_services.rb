module CryptoServices
  include CryptoData
  include HTTParty

  class Fee
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

  class Dollar
    # Get today dollar value in CLP
    # Doc: https://mindicador.cl/
    # Respo example:
    #  {"version":"1.5.0","autor":"mindicador.cl","codigo":"dolar","nombre":"Dólar observado","unidad_medida":"Pesos","serie":[{"fecha":"2018-01-15T05:00:00.000Z","valor":604.09}]}
    def self.get_today_clp
      value = 0.0
      begin
        url = "https://mindicador.cl/api/dolar/#{Time.now.strftime('%d-%m-%Y')}"
        response = HTTParty.get(URI.escape(url), { timeout: 10.0 })
        response = JSON.parse(response.body)
        value = response['serie']['valor']
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING TODAY USD-CLP VALUE: #{e.inspect}"
      end
      value
    end
  end

  class CoinMarketCap
    # Get coin current stats (ticker) by currency (optional)
    # Doc: https://coinmarketcap.com/api/
    # Respo example:
    #   [{"id":"bitcoin","name":"Bitcoin","symbol":"BTC","rank":"1","price_usd":"11510.4","price_btc":"1.0","24h_volume_usd":"7595080000.0","market_cap_usd":"193723623245","available_supply":"16830312.0","total_supply":"16830312.0","max_supply":"21000000.0","percent_change_1h":"0.46","percent_change_24h":"3.77","percent_change_7d":"-9.8","last_updated":"1517099667","price_clp":"6936454.8","24h_volume_clp":"4576985085000.0000000000","market_cap_clp":"116742698457898"}]
    def self.ticker coin = 'bitcoin', currency = 'CLP'
      begin
        api_data = CryptoData.coinmarketcap[:api]

        path = "/#{api_data[:endpoint]}/#{coin}?convert=#{currency}"

        response = HTTParty.get(URI.escape(api_data[:base_url] + "/" + api_data[:version] + path), { timeout: 10.0 })
        response = JSON.parse(response.body)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING COIN MARKET CAP STATS: #{e.inspect}"
      end
    end
  end
end
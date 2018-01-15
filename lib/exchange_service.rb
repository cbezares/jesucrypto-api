module ExchangeService
  include CryptoData
  include HTTParty

  class Status
    # SurBTC API
    # Doc: http://api.surbtc.com/
    # Response example:
    #  {"ticker"=>{"last_price"=>["9289496.0", "CLP"], "min_ask"=>["9289495.0", "CLP"], "max_bid"=>["9030000.0", "CLP"], "volume"=>["11.62371302", "BTC"], "price_variation_24h"=>"0.001", "price_variation_7d"=>"-0.114"}}
    def self.surbtc market
      begin
        api_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'SBT' }[:api]

        path = '/markets/'
        path += case market
        when 'BTC/CLP'
          'btc-clp'
        when 'ETH/CLP'
          'eth-clp'
        when 'ETH/BTC'
          'eth-btc'
        when 'BCH/CLP'
          'bch-clp'
        when 'BCH/BCP'
          'bch-btc'
        end
        path += '/ticker'

        response = HTTParty.get(URI.escape(api_data[:endpoint] + '/' + api_data[:version] + path + '.' + api_data[:format]))
        response = JSON.parse(response.body)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING SURBTC STATUS: #{e.inspect}"
      end
    end

    # Orionx API
    # Doc: http://api.orionx.io/graphiql
    # Response example:
    #   {"data"=>{"marketOrderBook"=>{"buy"=>[{"limitPrice"=>9210911}], "sell"=>[{"limitPrice"=>9397992}], "spread"=>187081, "mid"=>9304452}}}
    def self.orionx market
      begin
        api_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'ORX' }[:api]

        body_request = {
          query: "{ marketOrderBook(marketCode: \"#{market.gsub!('/', '')}\", limit: 1) { buy { limitPrice } sell { limitPrice } spread mid } }"
        }

        options = {
          body: body_request.to_json,
          headers: { 'Content-Type' => 'application/json' },
          timeout: 1000
        }

        response = HTTParty.post(URI.escape(api_data[:endpoint]), options)
        response = JSON.parse(response.body)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING ORIONX STATUS: #{e.inspect}"
      end
    end

    # Southxchange API
    # Doc: https://www.southxchange.com/Home/Api
    # Response example:
    #   {"Bid"=>13772.3214, "Ask"=>14245.9562, "Last"=>13772.322, "Variation24Hr"=>-7.51, "Volume24Hr"=>0.59333893}
    def self.southxchange market
      begin
        api_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'SXC' }[:api]

        path = '/price/' + market

        response = HTTParty.get(URI.escape(api_data[:endpoint] + path))
        response = JSON.parse(response.body)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING SOUTHXCHANGE STATUS: #{e.inspect}"
      end
    end

    # Bitinka API
    # Doc: https://www.bitinka.com/bitinka/api_documentation
    # Response example:
    #   {"CLP":{"volumen24hours":{"BTC":8.15,"CLP":69040790.81},"ask":8641058.3,"bid":8482068.59,"last":8399406.7}, ... }
    def self.bitinka market = nil
      begin
        api_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'BTK' }[:api]

        market = market.nil? ? '' : "/" + market.gsub!(/[BTC\/]/,'')
        path = "/apinka/ticker" + market + "?format=" + api_data[:format]

        response = HTTParty.get(URI.escape(api_data[:endpoint] + path))
        response = JSON.parse(response.body)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING BITINKA STATUS: #{e.inspect}"
      end
    end

    # Chilebit API
    # Doc: https://blinktrade.com/docs
    # Response example:
    #   {"high": 9553820.0, "vol": 0.03054283, "vol_clp": 275999.867876, "buy": 8812240.0, "last": 9128480.0, "low": 9000000.0, "pair": "BTCCLP", "sell": 9091180.0}
    def self.chilebit market = 'BTC/CLP'
      begin
        api_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'CLB' }[:api]

        path = market.split('/')[1] + "/ticker?crypto_currency=" + market.split('/')[0]

        response = HTTParty.get(URI.escape(api_data[:endpoint] + "/" + api_data[:version] + "/" + path))
        response = JSON.parse(response.body)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING CHILEBIT STATUS: #{e.inspect}"
      end
    end

    # CryptoMKT API
    # Doc: https://developers.cryptomkt.com
    # Response example:
    #   {"status": "success", "data": [{"volume": "33.26", "timestamp": "2018-01-15T02:43:50.001629", "bid": "872050", "last_price": "890000", "high": "907500", "low": "860220", "ask": "890500", "market": "ETHCLP"}]}
    def self.cryptomkt market = 'ETH/CLP'
      begin
        api_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'CMK' }[:api]

        path = '/ticker?market=' + market.gsub!('/', '')

        response = HTTParty.get(URI.escape(api_data[:endpoint] + "/" + api_data[:version] + path))
        response = JSON.parse(response.body)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING CRYPTOMKT STATUS: #{e.inspect}"
      end
    end

    # Xapo API
    # Doc: https://xapo.docs.apiary.io
    # Response example:
    #   {"fx_etoe": {"USDBTC": {"rate": 7.2439967885517e-05, "destination_amt": 1.0, "max_amt": 41413.60201514, "cross_spread": 0.9925, "min_amt": 0.0, "source_amt": 13804.53400505}}, "ts": "2018-01-15 00:55:34.757555"}
    def self.xapo market = 'USD/BTC'
      begin
        api_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'XAP' }[:api]

        path = '/quotes/' + market.gsub!('/', '')

        response = HTTParty.get(URI.escape(api_data[:endpoint] + "/" + api_data[:version] + path))
        response = JSON.parse(response.body)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING XAPO STATUS: #{e.inspect}"
      end
    end

    # SatoshiTango API
    # Doc: http://satoshitango.github.io/
    # Response example:
    #   {"data":{"venta":{"date":"2018-01-15 03:02:01","usdbtc":"13465.79","arsbtc":"276748.79","arsbtcround":"276749","eurbtc":"11026.62"},"compra":{"date":"2018-01-15 03:02:01","usdbtc":"13616.80","arsbtc":"295269.71","arsbtcround":"295270","eurbtc":"11213.37"}},"execution_time":0.058262825012207}
    def self.satoshitango
      begin
        api_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'STT' }[:api]

        path = '/ticker'

        response = HTTParty.get(URI.escape(api_data[:endpoint] + "/" + api_data[:version] + path))
        response = JSON.parse(response.body)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING XAPO STATUS: #{e.inspect}"
      end
    end

    # Binance API
    # Doc: https://github.com/binance-exchange/binance-official-api-docs
    # Response example:
    #   {"symbol":"LTCBTC","bidPrice":"0.01742000","bidQty":"55.79000000","askPrice":"0.01742100","askQty":"18.65000000"}
    def self.binance market
      begin
        api_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'BNC' }[:api]

        path = '/ticker/bookTicker?symbol=' + market.gsub!('/', '')

        response = HTTParty.get(URI.escape(api_data[:endpoint] + "/" + api_data[:version] + path))
        response = JSON.parse(response.body)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING BINANCE STATUS: #{e.inspect}"
      end
    end

  end

end
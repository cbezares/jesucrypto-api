module ExchangesServices
  include CryptoData
  include HTTParty
  default_timeout 10

  class Status
    # SurBTC/Buda API
    # Doc: http://api.surbtc.com/
    # Response example:
    #  {"ticker"=>{"last_price"=>["9289496.0", "CLP"], "min_ask"=>["9289495.0", "CLP"], "max_bid"=>["9030000.0", "CLP"], "volume"=>["11.62371302", "BTC"], "price_variation_24h"=>"0.001", "price_variation_7d"=>"-0.114"}}
    def self.buda market
      begin
        exchange_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'BDA' }
        api_data      = exchange_data[:api]

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

        response = HTTParty.get(URI.escape(api_data[:base_url] + '/' + api_data[:version] + path + '.' + api_data[:format]), { timeout: 10.0 })
        r = response = JSON.parse(response.body)

        Format.output_json({ name: exchange_data[:name], codename: exchange_data[:codename] }, market, r["ticker"]["min_ask"][0].to_f, r["ticker"]["max_bid"][0].to_f)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING BUDA STATUS: #{e.inspect}"
      end
    end

    # Orionx API
    # Doc: https://orionx.io/developers/docs && https://orionx.io/developers/tutorials/consulta-basica-api
    # Response example:
    #   {"data"=>{"marketOrderBook"=>{"buy"=>[{"limitPrice"=>9210911}], "sell"=>[{"limitPrice"=>9397992}], "spread"=>187081, "mid"=>9304452}}}
    def self.orionx market
      begin
        exchange_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'ORX' }
        api_data      = exchange_data[:api]

        body_request = {
          query: "{ marketOrderBook(marketCode: \"#{market.gsub('/', '')}\", limit: 1) { buy { limitPrice } sell { limitPrice } spread mid } }"
        }.to_json

        header_timestamp  = Time.now.to_f.to_s
        digest            = OpenSSL::Digest.new('sha512')
        instance          = OpenSSL::HMAC.new(ENV["ORIONX-SECRET-KEY"], digest)
        header_signature  = instance.update(header_timestamp + body_request)

        options = {
          body: body_request,
          headers: {
            'Content-Type' => 'application/json',
            'Content-Length' => body_request.length.to_s,
            'X-ORIONX-TIMESTAMP' => header_timestamp,
            'X-ORIONX-APIKEY' => ENV["ORIONX-API-KEY"],
            'X-ORIONX-SIGNATURE' => header_signature.to_s
          },
          timeout: 10.0
        }

        response = HTTParty.post(URI.escape(api_data[:base_url]), options)
        r = JSON.parse(response.body)

        Format.output_json({ name: exchange_data[:name], codename: exchange_data[:codename] }, market, r["data"]["marketOrderBook"]["buy"][0]["limitPrice"].to_f, r["data"]["marketOrderBook"]["sell"][0]["limitPrice"].to_f)
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
        exchange_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'SXC' }
        api_data      = exchange_data[:api]

        path = '/price/' + market

        response = HTTParty.get(URI.escape(api_data[:base_url] + path), { timeout: 10.0 })
        r = JSON.parse(response.body)

        Format.output_json({ name: exchange_data[:name], codename: exchange_data[:codename] }, market, r["Ask"].to_f, r["Bid"].to_f)
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
        exchange_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'BTK' }
        api_data      = exchange_data[:api]

        formatted_market = market.nil? ? '' : "/" + market.gsub(/[\/]*BTC[\/]*/,'')
        path = "/apinka/ticker" + formatted_market + "?format=" + api_data[:format]

        response = HTTParty.get(URI.escape(api_data[:base_url] + path), { timeout: 10.0 })
        r = JSON.parse(response.body)

        Format.output_json({ name: exchange_data[:name], codename: exchange_data[:codename] }, market, r[formatted_market]["ask"].to_f, r[formatted_market]["bid"].to_f)
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
        exchange_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'CLB' }
        api_data      = exchange_data[:api]

        path = market.split('/')[1] + "/ticker?crypto_currency=" + market.split('/')[0]

        response = HTTParty.get(URI.escape(api_data[:base_url] + "/" + api_data[:version] + "/" + path), { timeout: 5.0 })
        r = JSON.parse(response.body)

        Format.output_json({ name: exchange_data[:name], codename: exchange_data[:codename] }, market, r["sell"].to_f, r["buy"].to_f)
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
        exchange_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'CMK' }
        api_data      = exchange_data[:api]

        path = '/ticker?market=' + market.gsub('/', '')

        response = HTTParty.get(URI.escape(api_data[:base_url] + "/" + api_data[:version] + path), { timeout: 5.0 })
        r = JSON.parse(response.body)

        Format.output_json({ name: exchange_data[:name], codename: exchange_data[:codename] }, market, r["data"][0]["ask"].to_f, r["data"][0]["bid"].to_f)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING CRYPTOMKT STATUS: #{e.inspect}"
      end
    end

    # Xapo API
    # Doc: https://xapo.docs.apiary.io
    # Response example:
    #   {"fx_etoe": {"USDBTC": {"rate": 7.2439967885517e-05, "destination_amt": 1.0, "max_amt": 41413.60201514, "cross_spread": 0.9925, "min_amt": 0.0, "source_amt": 13804.53400505}}, "ts": "2018-01-15 00:55:34.757555"}
    def self.xapo market
      begin
        exchange_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'XAP' }
        api_data      = exchange_data[:api]

        formatted_market1 = market.split('/').join
        formatted_market2 = market.split('/').reverse.join

        response1 = HTTParty.get(URI.escape(api_data[:base_url] + "/" + api_data[:version] + "/quotes/" +  formatted_market1), { timeout: 10.0 })
        r1 = JSON.parse(response1.body)

        response2 = HTTParty.get(URI.escape(api_data[:base_url] + "/" + api_data[:version] + "/quotes/" +  formatted_market2), { timeout: 10.0 })
        r2 = JSON.parse(response2.body)

        Format.output_json({ name: exchange_data[:name], codename: exchange_data[:codename] }, market, r1["fx_etoe"][formatted_market1]["source_amt"], r2["fx_etoe"][formatted_market2]["destination_amt"])
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING XAPO STATUS: #{e.inspect}"
      end
    end

    # Coinbase API
    # Doc: https://developers.coinbase.com/api/v2
    # Response example:
    #   {"buy":{"data":{"base":"BTC","currency":"USD","amount":"13211.14"}},"sell":{"data":{"base":"BTC","currency":"USD","amount":"12911.46"}},"spot":{"data":{"base":"BTC","currency":"USD","amount":"13012.61"}}}
    def self.coinbase market
      begin
        exchange_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'CBS' }
        api_data      = exchange_data[:api]
        result = {}

        headers = { 'CB-VERSION' => "#{Time.now.strftime('%Y-%m-%d')}" }

        api_data[:endpoints].each do |endpoint|
          path = '/prices/' + market.gsub('/', '-') + '/' + endpoint
          response = HTTParty.get(URI.escape(api_data[:base_url] + "/" + api_data[:version] + path), headers: headers, { timeout: 5.0 })
          result[endpoint] = JSON.parse(response.body)
        end

        r = result

        Format.output_json({ name: exchange_data[:name], codename: exchange_data[:codename] }, market, r["buy"]["data"]["amount"].to_f, r["sell"]["data"]["amount"].to_f)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING COINBASE STATUS: #{e.inspect}"
      end
    end

    # Bitstamp API
    # Doc: https://www.bitstamp.net/api/
    # Response example:
    #   {"high": "14394.36", "last": "12967.73", "timestamp": "1516076157", "bid": "12956.40", "vwap": "13614.63", "volume": "12643.75058221", "low": "12710.00", "ask": "12967.73", "open": "13581.66"}
    def self.bitstamp market
      begin
        exchange_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'BSP' }
        api_data      = exchange_data[:api]

        path = '/ticker/'
        path += case market
        when 'BTC/USD'
          'btcusd'
        when 'XRP/USD'
          'xrpusd'
        when 'LTC/USD'
          'xrpbtc'
        when 'ETH/USD'
          'ltcusd'
        when 'BCH/USD'
          'ltcbtc'
        when 'XRP/BTC'
          'ethusd'
        when 'LTC/BTC'
          'ethbtc'
        when 'ETH/BTC'
          'bchusd'
        when 'BCH/BTC'
          'bchbtc'
        end

        response = HTTParty.get(URI.escape(api_data[:base_url] + "/" + api_data[:version] + path), { timeout: 5.0 })
        r = JSON.parse(response.body)

        Format.output_json({ name: exchange_data[:name], codename: exchange_data[:codename] }, market, r["ask"].to_f, r["bid"].to_f)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING BITSTAMP STATUS: #{e.inspect}"
      end
    end

    # SatoshiTango API
    # Doc: http://satoshitango.github.io/
    # Response example:
    #   {"data":{"venta":{"date":"2018-01-15 03:02:01","usdbtc":"13465.79","arsbtc":"276748.79","arsbtcround":"276749","eurbtc":"11026.62"},"compra":{"date":"2018-01-15 03:02:01","usdbtc":"13616.80","arsbtc":"295269.71","arsbtcround":"295270","eurbtc":"11213.37"}},"execution_time":0.058262825012207}
    def self.satoshitango
      begin
        exchange_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'STT' }
        api_data      = exchange_data[:api]

        path = '/ticker'

        response = HTTParty.get(URI.escape(api_data[:base_url] + "/" + api_data[:version] + path), { timeout: 5.0 })
        r = JSON.parse(response.body)

        Format.output_json({ name: exchange_data[:name], codename: exchange_data[:codename] }, "USD/BTC", r["data"]["compra"]["usdbtc"].to_f, r["data"]["venta"]["usdbtc"].to_f)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING SATOSHITANGO STATUS: #{e.inspect}"
      end
    end

    # Binance API
    # Doc: https://github.com/binance-exchange/binance-official-api-docs
    # Response example:
    #   {"symbol":"LTCBTC","bidPrice":"0.01742000","bidQty":"55.79000000","askPrice":"0.01742100","askQty":"18.65000000"}
    def self.binance market
      begin
        exchange_data = CryptoData.get_exchanges.find { |e| e[:codename] == 'BNC' }
        api_data      = exchange_data[:api]

        path = '/ticker/bookTicker?symbol=' + market.gsub('/', '')

        response = HTTParty.get(URI.escape(api_data[:base_url] + "/" + api_data[:version] + path), { timeout: 5.0 })
        r = JSON.parse(response.body)

        Format.output_json({ name: exchange_data[:name], codename: exchange_data[:codename] }, market, r["askPrice"].to_f, r["bidPrice"].to_f)
      rescue => e
        YisusLog.error_debug "ERROR ON GETTING BINANCE STATUS: #{e.inspect}"
      end
    end
  end

  class Format
    def self.output_json exchange, market, buy, sell
      {
        name: exchange[:name],
        codename: exchange[:codename],
        market: market,
        price: {
          buy: buy,
          sell: sell,
          mid: (buy + sell) / 2,
          spread: buy - sell,
          spread_percentage: ((buy - sell) / buy) * 100
        },
        timestamp: Time.now
      }
    end
  end

end
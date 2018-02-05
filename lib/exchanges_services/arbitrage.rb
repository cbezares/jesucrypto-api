module ExchangesServices
  class Arbitrage < Base
    # XAP -> ORX (BTC)
    # ORX -> XAP (BTC)
    # XAP -> BDA (BTC)
    # BDA -> XAP (BTC)
    # BDA -> ORX (BTC, ETH, BCH)
    # ORX -> BDA (BTC, ETH, BCH)
    # CMK -> BDA (ETH)
    # BDA -> CMK (ETH)
    # CMK -> ORX (ETH)
    # ORX -> CMK (ETH)
    # CLB -> BDA (BTC)
    # BDA -> CLB (BTC)
    # CLB -> ORX (BTC)
    # ORX -> CLB (BTC)
    # SXC -> BDA (BTC, ETH, BCH)
    # BDA -> SXC (BTC, ETH, BCH)
    # SXC -> ORX (BTC, ETH, BCH, CHA)
    # ORX -> SXC (BTC, ETH, BCH, CHA)
    def self.update_all
      data = {}
      exchange_markets_prices = {}
      threads = []
      investment_amounts = [100000, 500000, 1000000, 2000000]
      
      begin
        miner_fees_response = @@firebase_client.get("miner_fees")
        miner_fees = miner_fees_response.body

        exchanges = CryptoData.get_exchanges
        arbitraged_exchanges = exchanges.select { |e| e[:arbitrages].present? }

        arbitraged_exchanges.each do |exchange|
          prices_response = @@firebase_client.get("prices/#{exchange[:codename]}")
          exchange_markets_prices[exchange[:codename]] = prices_response.body
        end

        arbitraged_exchanges.each do |exchange|
          exchange[:arbitrages].each do |arbitrage|
            arbitrage[:markets].each do |market|
              threads << Thread.new {
                formatted_market = market.gsub('/', '-')

                if formatted_market.include? "-USD"
                  if exchange_markets_prices[exchange[:codename]][formatted_market].present?
                    sell_price      = exchange_markets_prices[arbitrage[:dest_exchange]][formatted_market.gsub("USD", "CLP")]["sell"]
                    destination_ts  = exchange_markets_prices[arbitrage[:dest_exchange]][formatted_market.gsub("USD", "CLP")]["timestamp"]
                    buy_price       = exchange_markets_prices[exchange[:codename]][formatted_market]["buy"] * 620.0
                    source_ts       = exchange_markets_prices[exchange[:codename]][formatted_market]["timestamp"]
                  elsif exchange_markets_prices[arbitrage[:dest_exchange]][formatted_market].present?
                    buy_price       = exchange_markets_prices[exchange[:codename]][formatted_market.gsub("USD", "CLP")]["buy"]
                    source_ts       = exchange_markets_prices[exchange[:codename]][formatted_market.gsub("USD", "CLP")]["timestamp"]
                    sell_price      = exchange_markets_prices[arbitrage[:dest_exchange]][formatted_market]["sell"] * 620.0
                    destination_ts  = exchange_markets_prices[arbitrage[:dest_exchange]][formatted_market]["timestamp"]
                  end
                elsif formatted_market.include? "-BTC"
                  if exchange_markets_prices[exchange[:codename]][formatted_market].present?
                    sell_price      = exchange_markets_prices[arbitrage[:dest_exchange]][formatted_market.gsub("BTC", "CLP")]["sell"]
                    destination_ts  = exchange_markets_prices[arbitrage[:dest_exchange]][formatted_market.gsub("BTC", "CLP")]["timestamp"]
                    buy_price       = exchange_markets_prices[exchange[:codename]][formatted_market]["buy"] * 8000000.0
                    source_ts       = exchange_markets_prices[exchange[:codename]][formatted_market]["timestamp"]
                  elsif exchange_markets_prices[arbitrage[:dest_exchange]][formatted_market].present?
                    buy_price       = exchange_markets_prices[exchange[:codename]][formatted_market.gsub("BTC", "CLP")]["buy"]
                    source_ts       = exchange_markets_prices[exchange[:codename]][formatted_market.gsub("BTC", "CLP")]["timestamp"]
                    sell_price      = exchange_markets_prices[arbitrage[:dest_exchange]][formatted_market]["sell"] * 8000000.0
                    destination_ts  = exchange_markets_prices[arbitrage[:dest_exchange]][formatted_market]["timestamp"]
                  end
                else
                  sell_price      = exchange_markets_prices[arbitrage[:dest_exchange]][formatted_market]["sell"]
                  destination_ts  = exchange_markets_prices[arbitrage[:dest_exchange]][formatted_market]["timestamp"]
                  buy_price       = exchange_markets_prices[exchange[:codename]][formatted_market]["buy"]
                  source_ts       = exchange_markets_prices[exchange[:codename]][formatted_market]["timestamp"]
                end

                ror = {}
                pft = {}
                miner_fee = miner_fees[formatted_market.split('-')[0]]
                dest_exchange = exchanges.find { |e| e[:codename] == arbitrage[:dest_exchange] }
                investment_amounts.each do |inv_amt|
                  profit = self.get_profit(exchange, dest_exchange, inv_amt, buy_price, sell_price, miner_fee)

                  ror[inv_amt] = profit.to_f / inv_amt.to_f # Rate of return
                  pft[inv_amt] = profit.to_f # Profit

                  if ror[inv_amt] > (ENV["SLACK-NOTIFICATION-ROR-MIN"].to_f || 0.05) &&
                    exchange[:codename] != 'XAP' &&
                      dest_exchange[:codename] != 'XAP'
                    
                    Notifier.arbitrages({
                      market: formatted_market,
                      exc_from: exchange[:codename],
                      exc_to: dest_exchange[:codename],
                      buy_price: buy_price.round,
                      sell_price: sell_price.round,
                      inv_amt: inv_amt,
                      profit: pft[inv_amt].round,
                      rate_of_return: ror[inv_amt]
                    })
                  end
                end

                data = {
                  buy_price: buy_price,
                  sell_price: sell_price,
                  miner_fee: miner_fee,
                  rate_of_return: ror,
                  profit: pft,
                  source_ts: source_ts,
                  destination_ts: destination_ts,
                  timestamp: JSON.parse(Time.now.to_json)
                }
              
                @@firebase_client.update("arbitrages/#{exchange[:codename]}/#{arbitrage[:dest_exchange]}/#{formatted_market}", data)
              }
            end
          end
        end

        threads.each { |thread| thread.join } 
      rescue => e
        YisusLog.error_debug "ERROR ON UPDATING ARBITRAGES EXHANGES: #{e.inspect}", e
        # puts "ERROR ON UPDATING ARBITRAGES EXHANGES: #{e.inspect}"
      end
    end

    def self.get_profit exc_src, exc_dest, inv_amt, buy_price, sell_price, miner_fee = nil
      result_amt = inv_amt.to_f

      # Deposit fee
      if exc_src[:fees].present? && exc_src[:fees][:deposit].present?
        if exc_src[:fees][:deposit][:type] == 'percentage'
          result_amt = result_amt / (1.0 + (exc_src[:fees][:deposit][:value].to_f / 100.0))
        elsif exc_src[:fees][:deposit][:type] == 'number'
          result_amt = result_amt - exc_src[:fees][:deposit][:value].to_f
        end
      end

      # Buy fee
      if exc_src[:fees].present? && exc_src[:fees][:buy].present?
        if exc_src[:fees][:buy][:type] == 'percentage'
          result_amt = (result_amt / buy_price.to_f) * (1.0 - (exc_src[:fees][:buy][:value].to_f / 100.0))
        elsif exc_src[:fees][:buy][:type] == 'number'
          result_amt = (result_amt / buy_price.to_f) - exc_src[:fees][:buy][:value].to_f
        end
      else
        result_amt = result_amt / buy_price.to_f
      end

      # Miner fee
      if miner_fee.present?
        result_amt = result_amt - miner_fee.to_f
      end

      # Sell fee
      if exc_dest[:fees].present? && exc_dest[:fees][:sell].present?
        if exc_dest[:fees][:sell][:type] == 'percentage'
          result_amt = (result_amt * sell_price.to_f) * (1.0 - (exc_dest[:fees][:sell][:value].to_f / 100.0))
        elsif exc_dest[:fees][:sell][:type] == 'number'
          result_amt = (result_amt * sell_price.to_f) - exc_dest[:fees][:sell][:value].to_f
        end
      else
        result_amt = result_amt * sell_price.to_f
      end

      # Withdrawal fee
      if exc_dest[:fees].present? && exc_dest[:fees][:withdrawal].present?
        if exc_dest[:fees][:withdrawal][:type] == 'percentage'
          result_amt = result_amt / (1.0 + (exc_dest[:fees][:withdrawal][:value].to_f / 100.0))
        elsif exc_dest[:fees][:withdrawal][:type] == 'number'
          result_amt = result_amt - exc_dest[:fees][:withdrawal][:value].to_f
        end
      end

      profit = result_amt - inv_amt
    end

  end
end
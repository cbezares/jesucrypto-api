require 'clockwork'
require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)

include Clockwork

module Clockwork
  handler do |job|
    puts "[clockwork:handler] Running #{job}"
  end

  every(1.day, '[clockwork:exchange:update_exchanges] Updating exchanges data.') do
    ExchangesServices::Status.update_exchanges
  end

  every(2.minutes, '[clockwork:exchange:update_important] Updating important exchange prices.') do
    exchanges = %w(BDA ORX XAP SXC CLB CMK)
    ExchangesServices::Status.update_prices(exchanges)
  end

  # every(5.minutes, '[clockwork:exchange:update_others] Updating less important exchange prices.') do
  #   exchanges = %w(BSP CBS STT BNC BTK)
  #   ExchangesServices::Status.update_prices(exchanges)
  # end

  every(1.hour, '[clockwork:exchange:update_exchanges] Updating miner fees.') do
    ExchangesServices::Status.update_miner_fees
  end

  every(5.minutes, '[clockwork:exchange:update_arbitrages] Updating arbitrage opportunities.') do
    ExchangesServices::Status.update_arbitrages
  end
end
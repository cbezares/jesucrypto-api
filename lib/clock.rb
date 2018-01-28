require 'clockwork'
require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)

include Clockwork

module Clockwork
  include ExchangesServices
  
  handler do |job|
    puts "[clockwork:handler] Running #{job}"
  end

  every(5.minutes, '[clockwork:exchange:update_important] Updating important exchange prices.') do
    exchanges = %w(BDA ORX XAP SXC CLB CMK)
    ExchangesServices::Status.update_exchanges(exchanges)
  end

  every(10.minutes, '[clockwork:exchange:update_others] Updating less important exchange prices.') do
    exchanges = %w(BSP CBS STT BNC BTK)
    ExchangesServices::Status.update_exchanges(exchanges)
  end
  
end
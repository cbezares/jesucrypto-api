namespace :exchange do
  desc "Update most important exchanges coin prices"
  task update_important: :environment do
  	include ExchangesServices
    exchanges = %w(BDA ORX XAP SXC CLB CMK)
    ExchangesServices::Status.update_prices(exchanges)
  end
end

namespace :exchange do
  desc "Update less important exchanges coin prices"
  task update_others: :environment do
  	include ExchangesServices
    exchanges = %w(BSP CBS STT BNC BTK)
    ExchangesServices::Status.update_prices(exchanges)
  end
end

namespace :exchange do
  desc "Update general exchanges data"
  task update_data: :environment do
    include ExchangesServices
    ExchangesServices::Status.update_exchanges
  end
end

namespace :exchange do
  desc "Update general exchanges data"
  task update_arbitrage: :environment do
    include ExchangesServices
    ExchangesServices::Status.update_arbitrages
  end
end
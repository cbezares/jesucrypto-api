module CryptoData
  def self.get_exchanges
    [
      { 
        id: 1,
        name: 'SurBTC',
        url: 'https://www.surbtc.com',
        codename: 'SBT',
        markets: ['BTC/CLP', 'ETH/CLP', 'ETH/BTC', 'BCH/CLP', 'BCH/BCP'],
        api: {
          endpoint: 'https://www.surbtc.com/api',
          version: 'v2',
          format: 'json'
        }
      },
      { 
        id: 2,
        name: 'Orionx',
        url: 'https://orionx.io',
        codename: 'ORX',
        markets: ['BTC/CLP','ETH/CLP','LTC/CLP','CHA/CLP','BCH/CLP','DASH/CLP'],
        api: {
          endpoint: 'https://api.orionx.io/graphql'
        }
      },
      { 
        id: 3,
        name: 'Southxchange',
        url: 'https://www.southxchange.com',
        codename: 'SXC',
        markets: ['BTC/USD', 'ETH/USD', 'CHA/BTC', 'LTC/USD', 'BCH/USD'],
        api: {
          endpoint: 'https://www.southxchange.com/api'
        }
      },
      { 
        id: 4,
        name: 'Bitinka',
        url: 'https://www.bitinka.com',
        codename: 'BTK',
        markets: ['BTC/CLP', 'ETH/BTC'],
        api: {
          endpoint: 'https://www.bitinka.pe/api',
          format: 'json'
        }
      },
      { 
        id: 5,
        name: 'Chilebit',
        url: 'https://chilebit.net',
        codename: 'CLB',
        markets: ['BTC/CLP'],
        api: {
          endpoint: 'https://api.blinktrade.com/api',
          version: 'v1'
        }
      },
      { 
        id: 6,
        name: 'CryptoMKT',
        url: 'https://www.cryptomkt.com',
        codename: 'CMK',
        markets: ['ETH/CLP', 'ETH/ARS', 'ETH/EUR'],
        api: {
          endpoint: 'https://api.cryptomkt.com',
          version: 'v1'
        }
      },
      { 
        id: 7,
        name: 'Xapo',
        url: 'https://app.xapo.com',
        codename: 'XAP',
        markets: ['USD/BTC'],
        api: {
          endpoint: 'https://api.xapo.com',
          version: 'v3'
        }
      },
      { 
        id: 8,
        name: 'Coinbase',
        url: 'https://www.coinbase.com',
        codename: 'CBS',
        markets: ['BTC/USD', 'ETH/USD', 'LTC/USD', 'BCH/USD']
      },
      { 
        id: 9,
        name: 'Bitstamp',
        url: 'https://www.bitstamp.net',
        codename: 'BSP',
        markets: ['BTC/USD', 'ETH/USD', 'LTC/USD', 'BCH/USD']
      },
      { 
        id: 10,
        name: 'SatoshiTango',
        url: 'https://www.satoshitango.com',
        codename: 'STT',
        markets: ['BTC/USD', 'BTC/ARS', 'BTC/EUR'],
        api: {
          endpoint: 'https://api.satoshitango.com',
          version: 'v2'
        }
      },
      { 
        id: 11,
        name: 'Binance',
        url: 'https://www.binance.com/',
        codename: 'BNC',
        markets: ['LTC/BTC', 'ETH/BTC', 'BCH/BTC'],
        api: {
          endpoint: 'https://api.binance.com/api',
          version: 'v3'
        }
      }
    ]
  end
end
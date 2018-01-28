module CryptoData
  def self.get_exchanges
    [
      { 
        id: 1,
        name: 'Buda',
        url: 'https://www.buda.com',
        codename: 'BDA',
        markets: ['BTC/CLP', 'ETH/CLP', 'ETH/BTC', 'BCH/CLP', 'BCH/BCP'],
        api: {
          base_url: 'https://www.surbtc.com/api',
          version: 'v2',
          format: 'json'
        },
        fees: {
          deposit: {
            type: 'none',
            value: 0.0
          },
          withdrawal: {
            type: 'none',
            value: 0.0
          },
          buy: {
            type: 'percentage',
            value: 0.65
          },
          sell: {
            type: 'percentage',
            value: 0.65
          },
          transfer: {
            type: 'none',
            value: 0.0
          }
        }
      },
      { 
        id: 2,
        name: 'Orionx',
        url: 'https://orionx.io',
        codename: 'ORX',
        markets: ['BTC/CLP','ETH/CLP','LTC/CLP','CHA/CLP','BCH/CLP','DASH/CLP'],
        api: {
          base_url: 'https://api2.orionx.io/graphql',
          version: 'v2'
        },
        fees: {
          withdrawal: {
            type: 'number',
            value: 350.0
          },
          buy: {
            type: 'percentage',
            value: 0.29
          },
          sell: {
            type: 'percentage',
            value: 0.29
          }
        }
      },
      { 
        id: 3,
        name: 'Southxchange',
        url: 'https://www.southxchange.com',
        codename: 'SXC',
        markets: ['BTC/USD', 'ETH/USD', 'CHA/BTC', 'LTC/USD', 'BCH/USD'],
        api: {
          base_url: 'https://www.southxchange.com/api'
        },
        fees: {
          deposit: {
            type: 'percentage',
            value: 10.0
          },
          withdrawal: {
            "BCH" => { type: 'number', value: 0.0005 },
            "BTC" => { type: 'percentage', value: 0.1 },
            "CHA" => { type: 'number', value: 0.01 },
            "DASH" => { type: 'number', value: 0.0001 },
            "ETH" => { type: 'number', value: 0.002 },
            "LTC" => { type: 'number', value: 0.001 },
            "MRN" => { type: 'number', value: 0.001 },
            "USD" => { type: 'number', value: 0.2 },
            "XMR" => { type: 'number', value: 0.02 }
          },
          buy: {
            type: 'percentage',
            value: 0.2
          },
          sell: {
            type: 'percentage',
            value: 0.2
          },
          transfer: {
            "BCH" => { type: 'number', value: 0.0005 },
            "BTC" => { type: 'percentage', value: 0.1 },
            "CHA" => { type: 'number', value: 0.01 },
            "DASH" => { type: 'number', value: 0.0001 },
            "ETH" => { type: 'number', value: 0.002 },
            "LTC" => { type: 'number', value: 0.001 },
            "MRN" => { type: 'number', value: 0.001 },
            "USD" => { type: 'number', value: 0.2 },
            "XMR" => { type: 'number', value: 0.02 }
          }
        }
      },
      { 
        id: 4,
        name: 'Bitinka',
        url: 'https://www.bitinka.com',
        codename: 'BTK',
        markets: ['BTC/CLP', 'BTC/USD', 'ETH/BTC', 'BTC/LTC', 'BTC/XRP'],
        api: {
          base_url: 'https://www.bitinka.pe/api',
          format: 'json'
        },
        fees: {
          deposit: {
            type: 'percentage',
            value: 1.0
          },
          withdrawal: {
            type: 'percentage',
            value: 0.15
          },
          buy: {
            type: 'percentage',
            value: 0.5
          },
          sell: {
            type: 'percentage',
            value: 0.5
          },
          transfer: {
            type: 'percentage',
            value: 0.15
          }
        }
      },
      { 
        id: 5,
        name: 'Chilebit',
        url: 'https://chilebit.net',
        codename: 'CLB',
        markets: ['BTC/CLP'],
        api: {
          base_url: 'https://api.blinktrade.com/api',
          version: 'v1'
        },
        fees: {
          withdrawal: {
            type: 'number',
            value: 0.00029999
          },
          buy: {
            type: 'percentage',
            value: 0.7
          },
          sell: {
            type: 'percentage',
            value: 0.7
          },
          transfer: {
            type: 'number',
            value: 0.00029999
          }
        }
      },
      { 
        id: 6,
        name: 'CryptoMKT',
        url: 'https://www.cryptomkt.com',
        codename: 'CMK',
        markets: ['ETH/CLP', 'ETH/ARS', 'ETH/EUR'],
        api: {
          base_url: 'https://api.cryptomkt.com',
          version: 'v1'
        },
        fees: {
          buy: {
            type: 'percentage',
            value: 0.7
          },
          sell: {
            type: 'percentage',
            value: 0.7
          }
        }
      },
      { 
        id: 7,
        name: 'Xapo',
        url: 'https://app.xapo.com',
        codename: 'XAP',
        markets: ['USD/BTC', 'CLP/BTC'],
        api: {
          base_url: 'https://api.xapo.com',
          version: 'v3'
        },
        fees: {
          deposit: {
            type: 'percentage',
            value: 4.75
          }
        }
      },
      { 
        id: 8,
        name: 'Coinbase',
        url: 'https://www.coinbase.com',
        codename: 'CBS',
        markets: ['BTC/USD', 'ETH/USD', 'LTC/USD', 'BCH/USD'],
        api: {
          base_url: 'https://api.coinbase.com',
          version: 'v2',
          endpoints: ['buy', 'sell', 'spot']
        }
      },
      { 
        id: 9,
        name: 'Bitstamp',
        url: 'https://www.bitstamp.net',
        codename: 'BSP',
        markets: ['BTC/USD', 'XRP/USD', 'LTC/USD', 'ETH/USD', 'BCH/USD', 'XRP/BTC', 'LTC/BTC', 'ETH/BTC', 'BCH/BTC'],
        api: {
          base_url: 'https://www.bitstamp.net/api',
          version: 'v2'
        }
      },
      { 
        id: 10,
        name: 'SatoshiTango',
        url: 'https://www.satoshitango.com',
        codename: 'STT',
        markets: ['BTC/USD', 'BTC/ARS', 'BTC/EUR'],
        api: {
          base_url: 'https://api.satoshitango.com',
          version: 'v2'
        },
        fees: {
          deposit: {
            type: 'number',
            value: 20000.0
          }
        }
      },
      { 
        id: 11,
        name: 'Binance',
        url: 'https://www.binance.com/',
        codename: 'BNC',
        markets: ['LTC/BTC', 'ETH/BTC', 'BCH/BTC'],
        api: {
          base_url: 'https://api.binance.com/api',
          version: 'v3'
        }
      }
    ]
  end

  def self.coinmarketcap
    {
      name: 'Cryptocurrency Market Capitalizations',
      coins: %w(bitcoin ethereum ripple bitcoin-cash cardano stellar litecoin iota dash monero),
      currencies: %w(USD CLP),
      api: {
        base_url: 'https://api.coinmarketcap.com',
        version: 'v1',
        endpoint: 'ticker'
      }
    }
  end
end
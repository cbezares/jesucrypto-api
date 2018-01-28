module Dollar
  include HTTParty

  # Get today dollar value on CLP
  # Doc: https://mindicador.cl/
  # Respo example:
  #  {"version":"1.5.0","autor":"mindicador.cl","codigo":"dolar","nombre":"Dólar observado","unidad_medida":"Pesos","serie":[{"fecha":"2018-01-15T05:00:00.000Z","valor":604.09}]}
  def self.get_today
    value = 0.0
    begin
      url = "https://mindicador.cl/api/dolar/#{Time.now.strftime('%d-%m-%Y')}"
      response = HTTParty.get(URI.escape(url))
      response = JSON.parse(response.body)
      value = response['serie']['valor']
    rescue => e
      YisusLog.error_debug "ERROR ON GETTING TODAY DOLLAR VALUE: #{e.inspect}"
    end
    value
  end

end
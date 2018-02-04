module Notifier
  require 'slack-notifier'

  def arbitrages opportunity
    slack_notification

    @slack_attachment = @slack_attachment.merge({
      fields: [{
        title: "Market: #{opportunity[:market]} (buy: #{opportunity[:buy_price]}, sell: #{opportunity[:sell_price]})",
        value: "Inversion: #{opportunity[:inv_amt]}, Profit: #{opportunity[:profit]}, Rate: %#{(opportunity[:rate_of_return] * 100.0).round(2)}",
        short: false
      }],
      # text: 'Text',
      # pretext: 'Pretext',
      color: 'good',
      title: "#{opportunity[:exc_from]} -> #{opportunity[:exc_to]}",
      title_link: "https://console.firebase.google.com/u/0/project/jesucrypto-api/database/jesucrypto-api/data/arbitrages/#{opportunity[:exc_from]}/#{opportunity[:exc_to]}",
      icon_emoji: ":moneybag:"
    })

    @notifier.ping("Arbitrage Opportunity", attachments: [@slack_attachment])

    ############

    # slack_attachments = []

    # opportunities.each do |opportunity|
    #   opps = []

    #   opportunity[:details].each do |opp_detail|
    #     opp_value = ""
    #     opp_detail[:examples].each do |ex|
    #       opp_value += "Inversion: #{ex[:inv_amt]}, Profit: #{ex[:profit]}, Rate: %#{ex[:rate_of_return] * 100.0}\n"
    #     end

    #     opps << {
    #       title: "Market: #{opp_detail[:market]} (buy: #{opp_detail[:buy_price]}, sell: #{opp_detail[:sell_price]})",
    #       value: opp_value,
    #       short: false
    #     }
    #   end

    #   slack_attachments << @slack_attachment.merge({
    #     fields: opps,
    #     # text: 'Text',
    #     # pretext: 'Pretext',
    #     color: 'good',
    #     title: "#{opportunity[:exc_from]} -> #{opportunity[:exc_to]}",
    #     title_link: "https://console.firebase.google.com/u/0/project/jesucrypto-api/database/jesucrypto-api/data/arbitrages/#{opportunity[:exc_from]}/#{opportunity[:exc_to]}"
    #   })
    # end

    # @notifier.ping("Arbitrage Opportunity", attachments: slack_attachments)
  end

  def slack_notification
    @notifier = Slack::Notifier.new("https://hooks.slack.com/services/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", channel: '#arbitrages', username: 'webhookbot')
    @slack_attachment = {
      # author_name: "Jesucrypto Heroku",
      fallback: 'Unable to show error',
      footer: "Jesucrypto Heroku",
      ts: Time.now.strftime('%s'),
    }
  end
end
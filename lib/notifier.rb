module Notifier
  require 'slack-notifier'

  def self.arbitrages opportunity
    webhook_url = "https://hooks.slack.com/services/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"
    channel = "#arbitrages"
    slack(webhook_url, channel)

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
  end

  def self.error exception
    webhook_url = "https://hooks.slack.com/services/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"
    channel = "#errors"
    slack(webhook_url, channel)

    @slack_attachment = @slack_attachment.merge({
      fields: [{
        title: "File:",
        value: exception.backtrace[0],
        short: false
      }],
      title: exception.message,
      title_link: "http://www.google.com/search?ie=UTF-8&q=#{exception.message.html_safe}",
      color: 'danger',
      icon_emoji: ":x:"
    })

    @notifier.ping("Error", attachments: [@slack_attachment])
  end

  def self.slack webhook_url, channel
    @notifier = Slack::Notifier.new(webhook_url, channel: channel, username: 'webhookbot')
    @slack_attachment = {
      # author_name: "Jesucrypto Heroku",
      fallback: 'Unable to show error',
      footer: "Jesucrypto Heroku",
      ts: Time.now.strftime('%s')
    }
  end
end
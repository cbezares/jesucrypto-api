#encoding: utf-8
class YisusLog
  def self.debug message = nil
    @checkin_log ||= Logger.new("#{Rails.root}/log/yisus.log")
    @checkin_log.debug(message) unless message.nil?
  end

  def self.error_debug message = nil, exception = nil
    @checkin_log ||= Logger.new("#{Rails.root}/log/error.log")
    @checkin_log.debug(message) && puts(message) unless message.nil?
    if exception.present? && exception.backtrace.present?
      Notifier.error(exception)
    end
  end
end
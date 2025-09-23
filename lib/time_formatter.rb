# frozen_string_literal: true

# A formatter class that validates time format components and produces formatted UTC time.
class TimeFormatter
  VALID_FORMATS = %w[year month day hour minute second].freeze

  def initialize(format_param)
    @format_param = format_param
  end

  def valid?
    invalid_formats.empty?
  end

  def time
    now = Time.now.utc
    formats.map { |f| send("format_#{f}", now) }.join('-')
  end

  def invalid_formats
    return [''] if @format_param.nil? || @format_param.strip.empty?

    formats - VALID_FORMATS
  end

  private

  def formats
    return [] if @format_param.nil? || @format_param.strip.empty?

    @format_param.split(',').map(&:strip)
  end

  def format_year(now)
    now.year.to_s
  end

  def format_month(now)
    format('%02d', now.month)
  end

  def format_day(now)
    format('%02d', now.day)
  end

  def format_hour(now)
    format('%02d', now.hour)
  end

  def format_minute(now)
    format('%02d', now.min)
  end

  def format_second(now)
    format('%02d', now.sec)
  end
end

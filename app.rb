# frozen_string_literal: true

# A minimal Rack application that returns UTC time in requested format.
class App
  def call(env)
    @request = Rack::Request.new(env)
    [status, headers, body]
  end

  def body
    [response_body]
  end

  private

  def valid_request?
    @request.path == '/time' && @request.get? && format_present?
  end

  def format_present?
    !formats.empty?
  end

  def formats
    param = @request.params['format']
    return [] if param.nil? || param.strip.empty?
    param.split(',').map(&:strip)
  end

  def valid_formats
    %w[year month day hour minute second]
  end

  def invalid_formats
    formats - valid_formats
  end

  def formatted_time
    now = Time.now.utc
    formats.map { |f| send("format_#{f}", now) }.join('-')
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

  def status
    return 404 unless @request.path == '/time' && @request.get?
    return 400 if invalid_formats.any? || !format_present?
    200
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def response_body
    case status
    when 200
      "#{formatted_time}\n"
    when 400
      if invalid_formats.any?
        "Unknown time format [#{invalid_formats.join(', ')}]\n"
      else
        "Unknown time format []\n"
      end
    when 404
      "Not Found\n"
    end
  end
end

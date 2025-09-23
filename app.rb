# frozen_string_literal: true

# A minimal Rack application that returns UTC time in requested format.
class App
  def call(env)
    request = Rack::Request.new(env)
    formatter = TimeFormatter.new(request.params['format'])

    body = response_body(formatter)
    status = formatter.valid? ? 200 : 400

    [status, {}, [body]]
  end

  private

  def response_body(formatter)
    if formatter.valid?
      "#{formatter.time}\n"
    else
      "Unknown time format [#{formatter.invalid_formats.join(', ')}]\n"
    end
  end
end

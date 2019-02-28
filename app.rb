require_relative 'response_time'

class App

  def call(env)
    @request = Rack::Request.new(env)

    case @request.path_info
    when '/time'
      response = TimeFormatter.new(@request.params)

      if response.uncorrect_formats.valid?
        response(200, response.time_format.call)
      else
        response(400, "Unknown time format #{response.uncorrect_formats}")
      end
    else
      response(404, 'Not Found')
    end
  end

  private

  def response(status, body)
    response = Rack::Response.new
    response.status = status
    response.write body.to_s
    response.add_header('Content-Type', 'text/plain')
    response.finish
  end

end
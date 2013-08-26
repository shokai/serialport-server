module SerialportServer
  class SerialHttpServer < EM::Connection
    include EM::HttpServer

    def process_http_request
      res = EM::DelegatedHttpResponse.new(self)
      puts "[http] #{@http_request_method} #{@http_path_info} #{@http_query_string} #{@http_post_content}"
      res.headers['Access-Control-Allow-Origin'] = '*'
      res.headers['Access-Control-Allow-Headers'] = 'Content-Type'
      res.headers['Access-Control-Allow-Methods'] = 'PUT,DELETE,POST,GET,OPTIONS'
      if @http_request_method == 'GET'
        res.status = 200
        res.content = @@recvs.to_json
        res.send_response
      elsif @http_request_method == 'POST'
        res.status = 200
        @@sp.puts @http_post_content
        res.content = @@recvs.to_json
        res.send_response
      end
    end
  end
end

module SerialportServer

  def self.application
    @@application
  end

  private
  def self.application=(app)
    @@application = app
  end



  class Application

    def app_name
      'serialport-server'
    end

    attr_reader :args, :serialport, :channel, :recvs

    def initialize(argv)
      SerialportServer.application = self
      @args = ArgsParser.parse argv do
        arg :bps, 'bit per second', :default => 9600
        arg :bit, 'bit(7-9)', :default => 8
        arg :stopbit, 'stopbit', :default => 1
        arg :parity, 'parity bit', :default => 0
        arg :http_port, 'HTTP port', :alias => :hp, :default => 8783
        arg :websocket_port, 'WebSocket port', :alias => :wp, :default => 8784
        arg :socket_port, 'TCP Socket port', :alias => :sp, :default => 8785
        arg :version, 'show version', :alias => :v
        arg :help, 'show help', :alias => :h

        on :version do
          STDERR.puts "SerialportServer v#{SerialportServer::VERSION}"
          STDERR.puts "http://shokai.github.io/serialport-server"
          exit
        end
      end

      if !@args.first or @args.has_option? :help
        STDERR.puts @args.help
        if RUBY_PLATFORM =~ /mswin|mingw|cygwin|bccwin/
          STDERR.puts "e.g. #{app_name} COM1"
          STDERR.puts "     #{app_name} COM1 -hp 8783 -wp 8784 -sp 8785"
        else
          STDERR.puts "e.g. #{app_name} /dev/tty.your-device"
          STDERR.puts "     #{app_name} /dev/tty.your-device -hp 8783 -wp 8784 -sp 8785"
        end
        exit 1
      end

      begin
        @serialport = SerialPort.new(@args.first,
                                     @args[:bps].to_i,
                                     @args[:bit].to_i,
                                     @args[:stopbit].to_i,
                                     @args[:parity].to_i)
      rescue => e
        STDERR.puts 'cannot open serialport!!'
        STDERR.puts e.to_s
        exit 1
      end

      @recvs = Array.new
      @channel = EM::Channel.new
      @channel.subscribe do |data|
        now = Time.now.to_i*1000+(Time.now.usec/1000.0).round
        @recvs.unshift({:time => now, :data => data})
        while @recvs.size > 100 do
          @recvs.pop
        end
      end
    end

    def start
      EM::run do
        EM::start_server("0.0.0.0", @args[:http_port].to_i, SerialportServer::HttpServer)
        puts "start HTTP server - port #{@args[:http_port].to_i}"

        EM::start_server('0.0.0.0', @args[:socket_port].to_i, SerialportServer::SocketServer)
        puts "start TCP Socket server - port #{@args[:socket_port].to_i}"

        EM::WebSocket.start(:host => '0.0.0.0', :port => @args[:websocket_port].to_i) do |ws|
          ws.onopen do
            sid = @channel.subscribe do |mes|
              ws.send mes.to_s
            end
            puts "* new websocket client <#{sid}> connected"
            ws.onmessage do |mes|
              puts "* websocket client <#{sid}> : #{mes}"
              @serialport.puts mes.strip
            end

            ws.onclose do
              @channel.unsubscribe sid
              puts "* websocket client <#{sid}> closed"
            end
          end
        end
        puts "start WebSocket server - port #{@args[:websocket_port].to_i}"

        EM::defer do
          loop do
            data = @serialport.gets.gsub(/[\r\n]/,'') rescue next
            data = data.to_i if data =~ /^\d+$/
            next if !data or data.to_s.empty?
            @channel.push data
            puts data
          end
        end

        EM::defer do
          loop do
            line = STDIN.gets.gsub(/[\r\n]/,'') rescue next
            next if !line or line.to_s.empty?
            @serialport.puts line rescue next
          end
        end

      end
    end

  end
end

#
# Connection settings and handle for redis
# Reads from config/redis.yml
#
module RedisConnection

  def self.connection
    Thread.current[:redis_connection] ||= new_connection
  end

  def self.new_connection
    Redis.new(:host => host, :port => port, :thread_safe => true)
  end

  def self.configuration(conf=nil)
    if conf
      @configuration = conf
    end
    @configuration ||= begin
      YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]
    end
  end

  def self.available?
    begin
      connection['foo']
      true
    rescue Errno::ECONNRESET, Errno::EPIPE, Errno::ECONNABORTED, Errno::ECONNREFUSED
      false
    end
  end

  def self.host
    configuration['host'] || 'localhost'
  end
  
  def self.port
    configuration['port'] || 6379
  end
  
  def self.url
    "redis://" + host + ":" + port.to_s
  end
  
end

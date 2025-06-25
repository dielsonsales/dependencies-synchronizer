module DependenciesSynchronizer
  module Logger
    LEVELS = {
      silent: 0,
      info:   1,
      debug:  2
    }.freeze

    @level = LEVELS[:silent]

    def self.level=(symbol)
      @level = LEVELS[symbol] || LEVELS[:silent]
    end

    def self.debug(msg)
      puts "[DEBUG] #{msg}" if @level >= LEVELS[:debug]
    end

    def self.info(msg)
      puts "[INFO] #{msg}" if @level >= LEVELS[:info]
    end
  end
end

module Firebase
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    # The API key for your project.
    attr_accessor :api_key

    def initialize
      @api_key = nil
    end
  end
end
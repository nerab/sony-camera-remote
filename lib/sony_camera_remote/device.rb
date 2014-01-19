require 'uri'

module SonyCameraRemote
  class Model < Struct.new(:name, :description, :url)
  end

  class Manufacturer < Struct.new(:name, :url)
  end

  class Device < Struct.new(:name, :manufacturer, :model)
    attr_reader :services

    def initialize
      @services = {}
    end
  end

  class ScalarWebAPIDevice < Device
    attr_accessor :version, :imaging_device
  end
end

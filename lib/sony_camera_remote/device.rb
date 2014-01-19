module SonyCameraRemote
  class CameraService < Struct.new(:type, :actionlist_url, :access_type)
  end

  class Service < Struct.new(:type, :id, :scpd_url, :control_url, :event_sub_url)
  end

  class Model < Struct.new(:name, :description, :url)
  end

  class Manufacturer < Struct.new(:name, :url)
  end

  class Device < Struct.new(:name, :manufacturer, :model, :services)
  end
end

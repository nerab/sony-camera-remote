require 'httparty'

module SonyCameraRemote
  module Discovery
    class ScalarWebAPIServicesMapper
      class << self
        def map(services_info)
          services_info['X_ScalarWebAPI_Service'].map do |service_info|
            SonyCameraRemote::Services::ScalarWebAPIService.new.tap do |service|
              service.id = service_info['X_ScalarWebAPI_ServiceType']
              service.type = service_info['X_ScalarWebAPI_ServiceType']
              service.actionlist_url = service_info['X_ScalarWebAPI_ActionList_URL']
              service.access_type = service_info['X_ScalarWebAPI_AccessType']
            end
          end
        end
      end
    end

    class ServicesMapper
      class << self
        def map(services_info)
          services_info['service'].map do |service|
            # urn:upnp-org:serviceId:ContentDirectory => ContentDirectory
            # urn:upnp-org:serviceId:ConnectionManager => ConnectionManager
            # urn:schemas-sony-com:serviceId:ScalarWebAPI => ScalarWebAPI
            service_class = "#{service['serviceId'].split(':').last}Service"

            SonyCameraRemote::Services.const_get(service_class).new.tap do |s|
              s.id = service['serviceId']
              s.type = service['serviceType']
              s.scpd_url = service['SCPDURL']
              s.control_url = service['controlURL']
              s.event_sub_url = service['eventSubURL']
            end
          end
        end
      end
    end

    class DeviceMapper
      class << self
        def map(device_info)
          if swadi_device_info = device_info['X_ScalarWebAPI_DeviceInfo']
            device = ScalarWebAPIDevice.new.tap do |swadi|
              swadi.version = swadi_device_info['X_ScalarWebAPI_Version']
              swadi.imaging_device = swadi_device_info['X_ScalarWebAPI_ImagingDevice']

              ScalarWebAPIServicesMapper.map(swadi_device_info['X_ScalarWebAPI_ServiceList']).each do |service|
                swadi.services[service.id] = service
              end
            end
          else
            device = Device.new
          end

          device.name = device_info['friendlyName']
          device.manufacturer = Manufacturer.new(device_info['manufacturer'], device_info['manufacturerURL'])
          device.model = Model.new(device_info['modelName'], device_info['modelDescription'], device_info['modelURL'])

          ServicesMapper.map(device_info['serviceList']).each do |service|
            device.services[service.id] = service
          end

          device
        end
      end
    end

    class DeviceInfo
      class << self
        def fetch(location)
          DeviceMapper.map(HTTParty.get(location)['root']['device'])
        end
      end
    end
  end
end

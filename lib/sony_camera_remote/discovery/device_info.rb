require 'httparty'

module SonyCameraRemote
  module Discovery
    class CameraServiceMapper
      class << self
        def map(service_info)
          CameraService.new.tap do |camera_service|
            camera_service.type = service_info['X_ScalarWebAPI_ServiceType']
            camera_service.actionlist_url = service_info['X_ScalarWebAPI_ActionList_URL']
            camera_service.access_type = service_info['X_ScalarWebAPI_AccessType']
          end
        end
      end
    end

    class CameraServicesMapper
      class << self
        def map(services_info)
          services_info.map do |service_info|
            CameraServiceMapper.map(service_info)
          end
        end
      end
    end

    class ServiceMapper
      class << self
        def map(service_info)
          Service.new.tap do |service|
            service.type = service_info['serviceType']
            service.id = service_info['serviceId']
            service.scpd_url = service_info['SCPDURL']
            service.control_url = service_info['controlURL']
            service.event_sub_url = service_info['eventSubURL']
          end
        end
      end
    end

    class ServicesMapper
      class << self
        def map(services_info)
          services_info['service'].map do |service|
            ServiceMapper.map(service)
          end
        end
      end
    end

    class DeviceMapper
      class << self
        def map(device_info)
          Device.new.tap do |device|
            device.name = device_info['friendlyName']
            device.manufacturer = Manufacturer.new(device_info['manufacturer'], device_info['manufacturerURL'])
            device.model = Model.new(device_info['modelName'], device_info['modelDescription'], device_info['modelURL'])

            services = ServicesMapper.map(device_info['serviceList'])

            if swadi = device_info['X_ScalarWebAPI_DeviceInfo']
              services.concat(CameraServicesMapper.map(swadi['X_ScalarWebAPI_ServiceList']['X_ScalarWebAPI_Service']))
            end

            device.services = services
          end
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

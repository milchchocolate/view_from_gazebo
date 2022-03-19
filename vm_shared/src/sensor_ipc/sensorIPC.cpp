#include "gazebo/gazebo.hh"
#include "gazebo/plugins/CameraPlugin.hh"
#include "../common.hpp"

#include <boost/interprocess/managed_shared_memory.hpp>
#include <boost/interprocess/shared_memory_object.hpp>
#include <boost/interprocess/mapped_region.hpp>
#include <boost/interprocess/sync/scoped_lock.hpp>
#include <boost/interprocess/sync/named_mutex.hpp>
namespace ipc = boost::interprocess;

#include <cstring>

namespace gazebo
{
  class CameraIPC : public CameraPlugin
  {
    public: 
    
    CameraIPC() : CameraPlugin(), 
        shdmem{ipc::open_or_create,
            GazeboIPC::NamedSharedMemName,
            ipc::read_write},
        mutex{ipc::open_or_create, GazeboIPC::CamereMutexName},
        // region{this->shdmem, ipc::read_write},
        size{0}
    { }

    void Load(sensors::SensorPtr _parent, sdf::ElementPtr _sdf)
    {
        CameraPlugin::Load(_parent, _sdf);
        this->size = this->width * this->height * this->depth;
        shdmem.truncate(this->size);
        region = ipc::mapped_region{this->shdmem, ipc::read_write};
    }

    void OnNewFrame(const unsigned char *image,
        unsigned int width, unsigned int height, unsigned int depth,
        const std::string &format)
    {
        // TODO: add timestamp
        ipc::scoped_lock<ipc::named_mutex> lock{this->mutex};
        std::memcpy(region.get_address(), image, this->size);
    }

    virtual ~CameraIPC() {
        ipc::named_mutex::remove(GazeboIPC::CamereMutexName);
    }

    ipc::shared_memory_object shdmem;
    ipc::mapped_region region;
    ipc::named_mutex mutex;
    unsigned int size;
  };

  // Register this plugin with the simulator
  GZ_REGISTER_SENSOR_PLUGIN(CameraIPC)
}

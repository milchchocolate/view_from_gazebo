#include <boost/interprocess/managed_shared_memory.hpp>
#include <boost/interprocess/shared_memory_object.hpp>
#include <boost/interprocess/mapped_region.hpp>
#include <boost/interprocess/sync/scoped_lock.hpp>
#include <boost/interprocess/sync/named_mutex.hpp>
#include <opencv4/opencv2/opencv.hpp>

namespace ipc = boost::interprocess;

int main()
{
    std::cout << "hello CV" << std::endl;

    // test interprocess communication
    ipc::shared_memory_object shdmem{
        ipc::open_only,
        "CameraImage",
        ipc::read_only};

    // shdmem.truncate(921600);

    std::cout << shdmem.get_name() << std::endl;

    ipc::offset_t size;
    if (shdmem.get_size(size))
    {
        std::cout << "size: " << size << std::endl;
    }

    ipc::mapped_region region{shdmem, ipc::read_only};
    ipc::named_mutex mutex{ipc::open_or_create, "CameraImageMutex"};

    while (true) {
        {
            ipc::scoped_lock<ipc::named_mutex> lock{mutex};
            unsigned char *mem = static_cast<unsigned char*>(region.get_address());
            // TODO read dimension from shared memory
            cv::Mat im{480, 640, CV_8UC3, mem};
            cv::imshow("OpenCV IPC: CameraImage", im);
        }
        cv::waitKey(40);
    }

    ipc::named_mutex::remove("CameraImageMutex");

    return 0;
}

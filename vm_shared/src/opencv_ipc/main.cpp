#include <boost/interprocess/managed_shared_memory.hpp>
#include <boost/interprocess/shared_memory_object.hpp>
#include <boost/interprocess/mapped_region.hpp>
#include <opencv4/opencv2/opencv.hpp>

namespace ipc = boost::interprocess;

int main()
{
    std::cout << "hello CV" << std::endl;

    // test interprocess communication
    ipc::shared_memory_object shdmem{
        ipc::open_or_create,
        "Boost",
        ipc::read_write};

    shdmem.truncate(1024);

    std::cout << shdmem.get_name() << std::endl;

    ipc::offset_t size;
    if (shdmem.get_size(size))
    {
        std::cout << "size: " << size << std::endl;
    }

    ipc::mapped_region region{shdmem, ipc::read_write};

    // test opencv with gui
    cv::Mat im(480, 640, CV_8UC1, cv::Scalar(45));
    cv::imshow("Dark", im);
    cv::waitKey(0);

    return 0;
}

find_package(gazebo REQUIRED)
include_directories(${GAZEBO_INCLUDE_DIRS})
link_directories(${GAZEBO_LIBRARY_DIRS})
list(APPEND CMAKE_CXX_FLAGS "${GAZEBO_CXX_FLAGS}")

find_package(Threads REQUIRED)

add_library(sensor_ipc SHARED sensorIPC.cpp)
target_link_libraries(sensor_ipc 
    PRIVATE 
        ${GAZEBO_LIBRARIES} 
        CameraPlugin
        Threads::Threads )

install(
    TARGETS
        sensor_ipc
    )

find_package(gazebo REQUIRED)
include_directories(${GAZEBO_INCLUDE_DIRS})
link_directories(${GAZEBO_LIBRARY_DIRS})
list(APPEND CMAKE_CXX_FLAGS "${GAZEBO_CXX_FLAGS}")

add_library(sensor_ipc SHARED sensorIPC.cc)
target_link_libraries(sensor_ipc ${GAZEBO_LIBRARIES})

install(
    TARGETS
        sensor_ipc
    )

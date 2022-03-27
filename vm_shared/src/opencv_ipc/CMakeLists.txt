find_package(Boost REQUIRED)
find_package(OpenCV REQUIRED)

add_executable(cv_hw main.cpp)

target_include_directories(cv_hw
    PRIVATE
        ${Boost_INCLUDE_DIR}
        ${OpenCV_INCLUDE_DIRS}
)

find_package(Threads REQUIRED)

target_link_libraries(cv_hw
    PRIVATE
        ${OpenCV_LIBS}
        rt
        Threads::Threads
)

target_compile_features(cv_hw
    PRIVATE
        cxx_std_11
)

install(
    TARGETS cv_hw
    DESTINATION bin
)

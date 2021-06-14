cmake_minimum_required(VERSION 3.15 FATAL_ERROR)
project(camera_in_gazebo)

set(CMAKE_INSTALL_PREFIX "/root/plugins")

add_subdirectory(plugin_hw)
add_subdirectory(move_model_hw)

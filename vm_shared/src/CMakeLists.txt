cmake_minimum_required(VERSION 3.15 FATAL_ERROR)
project(camera_in_gazebo)

set(CMAKE_INSTALL_PREFIX "/root/plugins")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON) # Generate clang compilation database

option(ENABLE_IWYU "Include what you use" OFF)
option(ENABLE_CPPCHECK "cpp check" ON)

if (ENABLE_IWYU)
    # include what you use
    find_program(IWYU_PATH NAMES include-what-you-use iwyu)
    if(NOT IWYU_PATH)
    message(FATAL_ERROR "Could not find the program include-what-you-use")
    endif()
    set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE ${IWYU_PATH})
    set(CMAKE_C_INCLUDE_WHAT_YOU_USE ${IWYU_PATH})

    find_package(PythonInterp)
    find_program(iwyu_tool_path NAMES iwyu_tool)
    if (iwyu_tool_path AND PYTHONINTERP_FOUND)
    add_custom_target(iwyu
        ALL      # Remove ALL if you don't iwyu to be run by default.
        COMMAND "${PYTHON_EXECUTABLE}" "${iwyu_tool_path}" -p "${CMAKE_BINARY_DIR}" --jobs 4
        COMMENT "Running include-what-you-use tool"
        VERBATIM
    )
    endif()
endif()

## cppcheck
if (ENABLE_CPPCHECK)
    find_program(CMAKE_CXX_CPPCHECK NAMES cppcheck)
    if (CMAKE_CXX_CPPCHECK)
        list(
            APPEND CMAKE_CXX_CPPCHECK
                "--enable=all"
                "--suppress=missingInclude"
                "--std=c++17"
                "--inconclusive"
                "--force"
                "--inline-suppr"
                "--check-config"
        )
    endif()
endif()

add_subdirectory(plugin_hw)
add_subdirectory(move_model_hw)
add_subdirectory(opencv_ipc)


# include what you see and others:
# https://blog.kitware.com/static-checks-with-cmake-cdash-iwyu-clang-tidy-lwyu-cpplint-and-cppcheck/

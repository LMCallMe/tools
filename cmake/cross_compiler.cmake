message(STATUS "cross complie")
#The name of the target system
set(CMAKE_SYSTEM_NAME LINUX)
# specify the cross compiler
set(CMAKE_C_COMPILER arm-linux-gnueabihf-gcc)
SET(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)
# where is the target environment 
set(CMAKE_FIND_ROOT_PATH ${PROJECT_SOURCE_DIR}/rootfs )
# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
# configure
include_directories(${CMAKE_FIND_ROOT_PATH}/usr/include)
link_directories(${CMAKE_FIND_ROOT_PATH}/usr/lib)

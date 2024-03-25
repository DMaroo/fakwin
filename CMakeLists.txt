cmake_minimum_required(VERSION 3.28)

project(fakwin)

set(CMAKE_EXPORT_COMPILE_COMMANDS on)
set(CMAKE_SOURCE_DIR src)
set(CMAKE_INCLUDE_DIR include)

set(DBUS_XML_DIR dbus)

find_package(Qt6 CONFIG REQUIRED Core DBus)

set(DBUS_SPEC_XML org.kde.KWin.xml)

set(DBUS_XML_SRCS)

qt_add_dbus_adaptor(DBUS_XML_SRCS
  ${DBUS_XML_DIR}/${DBUS_SPEC_XML}
  FakWin.hpp
  FakWin
)

qt_wrap_cpp(SERVER_MOC ${CMAKE_INCLUDE_DIR}/FakWin.hpp)

add_executable(fakwin
  ${SERVER_MOC}
  ${CMAKE_SOURCE_DIR}/Server.cpp
  ${CMAKE_SOURCE_DIR}/FakWin.cpp
  ${DBUS_XML_SRCS}
)

target_include_directories(fakwin
  PRIVATE
  ${CMAKE_INCLUDE_DIR}
  ${CMAKE_CURRENT_BINARY_DIR}
)

target_link_libraries(fakwin
  Qt6::Core
  Qt6::DBus
)

set_target_properties(${PROJECT_NAME}
  PROPERTIES
    COMPILE_OPTIONS -Wall -Wextra -pedantic
    CXX_STANDARD 20
    CXX_STANDARD_REQUIRED ON
)

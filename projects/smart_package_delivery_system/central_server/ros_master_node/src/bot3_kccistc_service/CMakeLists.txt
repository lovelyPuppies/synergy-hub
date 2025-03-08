cmake_minimum_required(VERSION 3.0.2)
project(bot3_kccistc_service)

find_package(catkin REQUIRED COMPONENTS 
  message_generation 
  std_msgs 
  roscpp
  actionlib
  move_base_msgs
)
find_package(Threads REQUIRED)

add_service_files(FILES bot3gpio.srv)
generate_messages(DEPENDENCIES std_msgs)

catkin_package(
  LIBRARIES got3_kccistc_service
  CATKIN_DEPENDS std_msgs roscpp actionlib move_base_msgs
  DEPENDS system_lib
)

include_directories(${catkin_INCLUDE_DIRS})

add_executable(gpio_server src/gpio_server.cpp)
add_dependencies(gpio_server ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})
target_link_libraries(gpio_server ${catkin_LIBRARIES})

add_executable(gpio_client src/gpio_client.cpp)
add_dependencies(gpio_client ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})
target_link_libraries(gpio_client ${catkin_LIBRARIES})

add_executable(gpio_socketToRos src/gpio_socketToRos.cpp)
add_dependencies(gpio_socketToRos ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})
target_link_libraries(gpio_socketToRos ${catkin_LIBRARIES})

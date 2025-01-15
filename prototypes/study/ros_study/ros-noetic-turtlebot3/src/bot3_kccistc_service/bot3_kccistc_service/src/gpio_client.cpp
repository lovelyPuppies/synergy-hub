#include "ros/ros.h"                          // ROS Default Header File
#include "bot3_kccistc_service/bot3gpio.h"// SrvTutorial Service File Header (Automatically created after build)
#include <cstdlib>                            // Library for using the "atoll" function

int main(int argc, char **argv)               // Node Main Function
{
  ros::init(argc, argv, "service_client");    // Initializes Node Name

  if (argc != 3)  // Input value error handling
  {
    ROS_INFO("cmd : rosrun ros_tutorials_service service_client arg0 arg1");
    ROS_INFO("arg0: double number, arg1: double number");
    return 1;
  }

  ros::NodeHandle nh;       // Node handle declaration for communication with ROS system

  // Declares service client 'ros_tutorials_service_client'
  // using the 'SrvTutorial' service file in the 'ros_tutorials_service' package.
  // The service name is 'ros_tutorial_srv'
  ros::ServiceClient kccistc_service_client = nh.serviceClient<bot3_kccistc_service::bot3gpio>("bot3_gpio");

  // Declares the 'srv' service that uses the 'SrvTutorial' service file
  bot3_kccistc_service::bot3gpio srv;

  // Parameters entered when the node is executed as a service request value are stored at 'a' and 'b'
  srv.request.a = atoll(argv[1]);
  srv.request.b = atoll(argv[2]);

  // Request the service. If the request is accepted, display the response value
  if (kccistc_service_client.call(srv))
  {
    ROS_INFO("send srv, srv.Request.a and b: %ld, %ld", (long int)srv.request.a, (long int)srv.request.b);
    ROS_INFO("receive srv, srv.Response.result: %ld", (long int)srv.response.result);
  }
  else
  {
    ROS_ERROR("Failed to call service bot3_gpio");
    return 1;
  }
  return 0;
}

# Port Configuration Comparison: Port Mapping, Forwarding, and Publishing

Written at 📅 2024-10-16 21:48:26

This table provides a comprehensive comparison between **router port forwarding**, **Docker/DevContainer port mapping (published port)**, **EXPOSE**, and **DevContainer forwarded ports** with relevant examples.

| **Concept**                          | **Description**                                                                                  | **External Network Access** | **Local Access**           | **Purpose**                                     | **Example / Configuration**                                  |
|--------------------------------------|--------------------------------------------------------------------------------------------------|-----------------------------|----------------------------|------------------------------------------------|--------------------------------------------------------------|
| **Router Port Forwarding**            | Routes traffic from the external network (internet) to a specific device on the internal network | **Yes**                     | No                         | Allow external access to a device within the internal network | Router settings: `8080 -> 192.168.0.100:80`                   |
| **Docker/DevContainer Port Mapping (Published Port)** | Connects a host port to a container's port, making it accessible from the external network. DevContainer uses the same concept for development workflows. | **Yes**                     | Yes                        | Expose container services to external networks and allow access from the host | **Docker:** `docker run -p 3000:3000 my-container`<br>**DevContainer:** Use `"appPort": [3000, "8921:5000"]` in `devcontainer.json`.<br>**Docker Compose:**<br>```yaml services: my-service: image: my-image ports: - "3000" - "8921:5000"``` |
| **EXPOSE (Dockerfile)**                   | Makes a port accessible between containers in the same Docker network. Does not allow external access | No                          | Yes (container-to-container) | Enable inter-container communication                         | In Dockerfile: `EXPOSE 8080`                                   |
| **DevContainer Forwarded Port**       | Forwards container ports to the host’s `localhost`, making them appear as local services. No external access | No                          | **Yes (localhost only)**  | Safe testing in local development environment                 | Use `"forwardPorts": [3000]` in `devcontainer.json`            |

## Applying Configuration Changes

After modifying the port configurations, you need to **rebuild the container** for the changes to take effect:

1. Open the **Command Palette (F1)** in VSCode.
2. Run `Dev Containers: Rebuild Container`.

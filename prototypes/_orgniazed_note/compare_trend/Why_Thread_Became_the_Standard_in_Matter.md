# Why Thread Became the Standard in Matter

Written at 📅 2024-11-14 13:02:40

Matter uses 🚣⭕ **Thread** and **Wi-Fi** as its main communication standards, with Thread being the primary protocol for low-power communication. Matter does not directly support Zigbee, and there are specific reasons why 📍 **Thread** was chosen over Zigbee.

## Reasons Why Thread is the Standard in Matter

### Technical Differences Between Zigbee and Thread

- Both 🚣 **Zigbee** and 📍 **Thread** support low-power 💡 **mesh networking**, but Thread is IP-based. This means that Thread networks can be seamlessly integrated with IP networks, making connectivity with Matter much more straightforward.
- Zigbee, on the other hand, is a standalone non-IP network, which makes it difficult to directly connect with internet-based systems. Therefore, for 📍 Matter's goal of interoperability across various smart home platforms, Thread is a more suitable choice.

### Internet Protocol Version 6 (IPv6) Support

- 📍 **Thread** is built on an IPv6-based network, providing excellent internet connectivity. Through Thread, Matter can utilize the IP address structure to facilitate seamless communication between devices.
- Since Zigbee does not support IP addresses, it cannot fulfill Matter’s main requirements for direct internet compatibility.

### Superior Interoperability

- Matter is a standard created in collaboration with diverse companies, including **Apple, Google, and Amazon**. Using Thread allows devices from different manufacturers to easily interconnect.
- Thread provides high compatibility with other smart home devices, making it ideal for fulfilling Matter's promise of interoperability.

### Scalability

- Thread networks feature a 💡 **self-healing mesh network** structure, meaning that if a device fails, the network automatically finds alternative routes to maintain communication. This makes Thread ideal for large-scale smart home networks.
- While Zigbee also supports mesh networking, Thread’s IP-based design better meets Matter’s scalability needs, offering improved stability.

### Conclusion

Within the Matter ecosystem, Thread is more suitable as a standard compared to Zigbee. Thread meets Matter's requirements for IP-based networking and ensures interoperability across different smart home platforms. For low-power networking, Thread serves as the preferred protocol, while Wi-Fi is used for high-speed data transfer, making Thread and Wi-Fi the primary standards in Matter.

---

## Additional Reasons Why Thread is Technically Superior (Even Beyond Matter)

Even when viewed independently of Matter, Thread offers enhanced functionality over Zigbee. In particular, Thread provides superior low-power mesh network performance and internet integration capabilities. Below are several features that make Thread a more advanced option than Zigbee.

### 1. IP-Based Network (IPv6 Support)

- Thread is designed with IPv6, enabling direct internet connectivity for smart home networks.
- Because Thread operates with IP addresses, it integrates easily with other networks, offering strong interoperability and scalability for IoT devices.
- Zigbee lacks IP support, which requires a Zigbee hub to connect to the internet and makes direct IP communication challenging.

### 2. Self-Healing Mesh Network

- Thread features a self-healing mesh network capability, meaning if one device fails or loses connection, the network automatically re-routes to maintain communication.
- Although Zigbee also has mesh networking, Thread’s self-healing algorithms are more stable and efficient, ensuring reliability even in large-scale networks.

### 3. Low-Power Design

- Thread was designed with low-power communication in mind, making it ideal for battery-operated devices that need long-term operation.
- While Zigbee is also a low-power protocol, Thread incorporates improvements in energy efficiency and stability. For instance, Thread networks can adjust device activation cycles under certain conditions to conserve energy.

### 4. Scalability and Network Size Management

- Being IP-based, Thread enables the construction of larger networks, and with IPv6 addressing, device numbers can scale without complications in IP allocation.
- Zigbee, while scalable, has limitations in network expansion and utilizes a different addressing scheme.

### 5. Security

- Thread supports network layer security (IPSec) and application layer security (TLS), providing multi-layered protection. This allows secure data transmission within and outside the network.
- Zigbee also supports security features, but Thread offers a more robust security framework due to IP-based security protocols.

### 6. Intelligent Network Management

- Thread includes automatic routing and network management capabilities, which distribute traffic efficiently and optimize network resources.
- While Zigbee provides basic routing and management, it lacks some of the optimized performance and stability features seen in Thread.

### Final Thoughts

Thread, even outside of Matter, is already emerging as the next-generation IoT mesh network protocol, surpassing the limitations of Zigbee. Thanks to its IP-based design, scalability, stability, and self-healing capabilities, Thread is better suited not only for smart home applications but also for large-scale IoT systems. Thread builds upon the strengths of Zigbee while introducing advanced functionality, making it a preferred choice for future IoT and smart home networks.

---

## Release Dates for Zigbee and Thread

1. **Zigbee**
   - **Release Year**: 2003
   - **Background**: Developed by the Zigbee Alliance (now the Connectivity Standards Alliance or CSA), Zigbee was initially designed for low-power wireless communication in smart homes, commercial spaces, and industrial IoT applications.
   - **Technical Evolution**: Since its release, Zigbee has undergone multiple updates. The latest major version, **Zigbee 3.0** (released in 2016), enhances interoperability and unifies various Zigbee devices under a single protocol.

2. **Thread**
   - **Release Year**: 2014
   - **Background**: Thread was developed by the Thread Group, a consortium of companies including Google Nest, ARM, and Qualcomm, aiming for interoperability among smart home devices and low-power IP-based networking.
   - **Technical Evolution**: Since its release, Thread has remained relatively consistent in its core architecture, becoming a primary standard in IoT and smart home communications, especially as it has been adopted within the Matter standard.

**In Summary**:
- **Zigbee**: Initially released in 2003 and has evolved with Zigbee 3.0 in 2016.
- **Thread**: Released in 2014 as an IP-based low-power protocol and is now integrated as a major standard within Matter.

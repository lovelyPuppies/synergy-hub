# ROS 2 vs. Protobuf + NATS: Key Takeaways

The author, **Forrest Allison**, expresses several frustrations with **ROS 2** and explains why they opted for **Protobuf with NATS** as an alternative. Below is a structured summary of the key issues raised in the article.

---

## Issues with ROS 2

### 1. Ubuntu Dependency

**Problem:**

- ROS 2 is tightly coupled with Ubuntu.
- Official packages are only distributed via **Ubuntu’s APT package manager**.
- Installing ROS 2 on **other Linux distributions** (Debian, RaspiOS) or **different OS** (Windows, macOS) is difficult.

**Why it’s a problem?**

- **Raspberry Pi** is a common hardware choice for hobbyists, but Ubuntu on Pi is buggy.
- **Containerization (Docker)** is suggested as a workaround, but managing hardware access inside Docker (e.g., GPIO, I2C, SPI) is cumbersome.

---

### 2. Versioning and Compatibility Issues

**Problem:**

- Each ROS 2 release is tied to a **specific Ubuntu version**.
- ROS 2 packages frequently **break** when moving to a newer ROS/Ubuntu version.
- No backward compatibility guarantees.

**Example from the article:**

- The author’s **Raspberry Pi 4** was damaged, so they replaced it with a **Pi 5**.
- Pi 5 required **newer Ubuntu**, which forced them to upgrade to a **newer ROS 2 version**.
- The upgrade **broke existing ROS 2 packages** that were tied to the older version.

**Why it’s a problem?**

- **Breaks dependencies** and forces users to upgrade everything.
- **Package compatibility issues** make it hard to reuse pre-built ROS 2 libraries.
- Creates **“tech debt”**, where fixing one thing leads to more issues down the line.

---

### 3. Language Lock-In (C++ & Python Only)

**Problem:**

- ROS 2 **only** supports **C++ and Python**.
- Developers who prefer **Go, Rust, Java, or JavaScript** must build their own bindings.

**Why it’s a problem?**

- Many **modern robotics projects** use Rust or Go for performance and safety.
- **A message bus should be language-agnostic** to maximize flexibility.

**Alternative Approach:**

- **Protobuf + NATS** → Supports **multiple languages** (C++, Python, Go, Rust, TypeScript, etc.).
- Easier for **cross-platform development** and integrating different tools.

---

### 4. Code Sharing & Package Management

**Problem:**

- ROS 2 relies on **Ubuntu APT** for package management.
- This makes **publishing and sharing ROS packages difficult**.

**Why it’s a problem?**

- Most third-party ROS packages require **manual cloning** (`git clone`).
- No **centralized package repository** like PyPI (Python), npm (JavaScript), or Cargo (Rust).
- Arduino, in contrast, has a **dedicated package manager** that simplifies installation and updates.

---

### 5. Developer Experience (DevEx) Issues

**Problem:**

- ROS 2 setup is **complicated** and unintuitive.
- Requires **sourcing setup scripts** every time a new terminal is opened.
- Uses **multiple command-line tools** (`rosdep`, `colcon build`, etc.), each with **complex and inconsistent syntax**.

**Why it’s a problem?**

- Steep learning curve, especially for beginners.
- **Unintuitive workflow** slows down development.
- Confusing versioning system (e.g., "Jazzy Jalisco" vs. "Humble Hawksbill").

---

## The Alternative: Protobuf + NATS

### 1. What is NATS?

- **NATS** is a **lightweight publish-subscribe messaging system**.
- Unlike ROS 2, it is **language-agnostic** and **portable across OS platforms**.

## 2. Why Use Protobuf Instead of ROS Messages?

- **Protobuf is language-neutral** → Works with **C++, Python, Rust, Go, Java, etc.**.
- **More efficient** → Protobuf is **binary-based**, making it **faster** and **smaller** than ROS 2 messages.
- **Easier to version** → Backward-compatible by design (`optional` and `default` fields).

### 3. How Protobuf + NATS Works

- **Protobuf** defines the **message structure**.
- **NATS** handles the **publish-subscribe communication**.
- **Nodes (sensors, actuators, controllers)** publish & listen to messages, just like ROS 2.
- Works across **Linux, Windows, macOS, Raspberry Pi**, and **any cloud service**.

---

## 📌 Conclusion: ROS 2 vs. Protobuf + NATS

| Feature                | **ROS 2**                          | **Protobuf + NATS**                          |
| ---------------------- | ---------------------------------- | -------------------------------------------- |
| **Platform Support**   | Ubuntu-only (officially)           | Cross-platform (Windows, macOS, Linux)       |
| **Language Support**   | C++ & Python only                  | Multi-language (C++, Python, Rust, Go, etc.) |
| **Message Format**     | ROS 2 Messages                     | Protobuf (efficient binary format)           |
| **Compatibility**      | Version-lock issues                | Backward-compatible                          |
| **Ease of Use**        | Steep learning curve               | Simple pub-sub model                         |
| **Package Management** | APT-based, manual cloning          | No restrictions, any package manager         |
| **Deployment**         | Complex (`colcon`, sourcing setup) | Lightweight, no special setup                |

---

## 💡 When to Choose ROS 2?

✅ If you need **an ecosystem of prebuilt robotics packages**.  
✅ If your **entire team is familiar with Ubuntu & ROS tooling**.  
✅ If you want **integrated simulation tools (Gazebo, MoveIt)**.

## 💡 When to Choose Protobuf + NATS?

✅ If you need **cross-platform support (Linux, Windows, macOS, Raspberry Pi)**.  
✅ If you want **multi-language support (C++, Python, Rust, Go, etc.)**.  
✅ If you prefer a **lightweight, efficient, and scalable messaging system**.

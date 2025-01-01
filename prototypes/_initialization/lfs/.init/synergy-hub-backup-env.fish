set -U fish_greeting (echo -e "
===========================
📋 Usage Instructions
===========================
To copy backup files to your host, use the following commands:
  docker cp <container_id>:/files/qt/qt6.8.0-arm64-bookworm-dev-env.tar.gz ./
  docker cp <container_id>:/files/qt/qt6.8.0-arm64-bookworm-app-Hello ./
❕ Replace <container_id> with the running container ID or name.

🛍️  Example:
  docker cp my-container:/files/qt/qt6.8.0-arm64-bookworm-dev-env.tar.gz ./
" | string split0)


# 🚨 Unknown error. 📅 2025-01-02 01:58:56
#   add line to prevent error by "string split0" 
echo $fish_greeting >/dev/null

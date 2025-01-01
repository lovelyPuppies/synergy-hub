# 1. Base image: Ubuntu 24.04 LTS (amd64)
FROM ubuntu:24.04

# 2. Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# 3. Update and install fish shell
RUN apt update && \
  apt install -y fish && \
  chsh -s /usr/bin/fish root
# ⚖️ Set default shell change
SHELL ["/usr/bin/fish", "-c"]

# 4. Copy the backup files into the image
WORKDIR /files
COPY files/ /files/
COPY .init/ /.init/

# 5. Add a tip to guide users on how to use the image
RUN fish /.init/synergy-hub-backup-env.fish

# 6. Default entrypoint
ENTRYPOINT ["fish"]


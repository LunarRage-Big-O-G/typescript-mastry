FROM gitpod/workspace-full:latest

# Import the 1Password GPG key and add it to the keyring
RUN curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

# Add the 1Password repository to the sources list
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
    sudo tee /etc/apt/sources.list.d/1password.list

# Create necessary directories for debsig policy and keyrings
RUN sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
RUN sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22/

# Download the debsig policy and store it in the appropriate location
RUN curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
    sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol

# Download and add the debsig keyring for 1Password
RUN curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

# Update package lists and install the 1Password CLI and PostgreSQL
RUN sudo apt update && sudo apt install -y 1password-cli

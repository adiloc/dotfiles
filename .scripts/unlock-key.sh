
#!/bin/bash

# Ensure GPG agent is not caching old credentials
gpgconf --kill gpg-agent

# Prompt for the user password (hidden input)
PASSWORD=$(i3-input -P "Enter your password: " | grep output | cut -d' ' -f3)
echo

# Use the password to unlock the GPG key
echo "$PASSWORD" | gpg --batch --yes --passphrase-fd 0 --pinentry-mode loopback --sign ~/.gnupg/trustdb.gpg

# Clear password from memory
unset PASSWORD

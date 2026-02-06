# Homebrew (cross-platform)
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
elif [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export AWS_PROFILE=saml

# Get external IP for OneLogin MFA (if curl available)
if command -v curl &> /dev/null; then
    export ONELOGIN_MFA_IP_ADDRESS=$(curl -SsL http://checkip.amazonaws.com/ 2>/dev/null)
fi

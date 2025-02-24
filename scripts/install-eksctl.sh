# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=arm64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep "$PLATFORM" | sha256sum --check

tar -xzf eksctl_"$PLATFORM".tar.gz -C ./ && rm eksctl_"$PLATFORM".tar.gz

sudo chmod +x ./eksctl

sudo mv ./eksctl /usr/local/bin
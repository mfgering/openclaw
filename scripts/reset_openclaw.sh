# Load environment variables from .env if it exists
if [ -f .env ]; then
    set -a  # automatically export all variables
    source .env
    set +a
fi

export HDIR=/home/mgering
# rm -fr $HDIR/.openclaw
rm -fr $HDIR/clawd
rm -fr $HDIR/clawd-main
echo Removing openclaw...
systemctl --user status openclaw-gateway
systemctl --user stop openclaw-gateway
systemctl --user disable openclaw-gateway
systemctl --user daemon-reload

npm -g rm openclaw
rm $HDIR/.npm-global/bin/openclaw
echo "Refreshing the repo..."
#scripts/refresh-repo.sh
read -n 1 -s -r -p "Press any key to continue..."
export OSTYPE=linux-gnu
export OPENCLAW_INSTALL_METHOD=git
export OPENCLAW_GIT_DIR=/home/mgering/projects/openclaw_install
export OPENCLAW_GIT_UPDATE=1
curl -fsSL https://openclaw.ai/install.sh | bash
read -n 1 -s -r -p "Press any key to continue with onboarding..."
openclaw onboard --accept-risk --anthropic-api-key $ANTHROPIC_API_KEY

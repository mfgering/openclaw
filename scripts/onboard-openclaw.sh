# Load environment variables from .env if it exists
if [ -f .env ]; then
    set -a  # automatically export all variables
    source .env
    set +a
fi

export HDIR=/home/mgering
read -n 1 -s -r -p "Press any key to continue with onboarding..."
openclaw onboard --accept-risk --auth-choice apiKey

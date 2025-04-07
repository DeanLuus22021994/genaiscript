#!/bin/bash
set -e

RUNNER_DIR="/opt/actions-runner"
CONFIG_SCRIPT="${RUNNER_DIR}/config.sh"

# Function to display usage information
usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  --url URL         GitHub repository URL (required)"
  echo "  --token TOKEN     GitHub personal access token with appropriate permissions (required)"
  echo "  --name NAME       Runner name (default: $(hostname)-$(date +%s))"
  echo "  --labels LABELS   Custom labels for the runner (default: self-hosted,Linux,X64)"
  echo "  --unregister      Unregister existing runner before configuration"
  echo "  --help            Display this help message"
  exit 1
}

# Default values
RUNNER_NAME="$(hostname)-$(date +%s)"
LABELS="self-hosted,Linux,X64,genaiscript"
UNREGISTER=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --url)
      REPO_URL="$2"
      shift 2
      ;;
    --token)
      TOKEN="$2"
      shift 2
      ;;
    --name)
      RUNNER_NAME="$2"
      shift 2
      ;;
    --labels)
      LABELS="$2"
      shift 2
      ;;
    --unregister)
      UNREGISTER=true
      shift
      ;;
    --help)
      usage
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Check if required arguments are provided
if [ -z "$REPO_URL" ] || [ -z "$TOKEN" ]; then
  echo "Error: Repository URL and token are required."
  usage
fi

# Change to runner directory
cd "$RUNNER_DIR"

# Check if runner is already configured
if [ -f ".runner" ] && [ "$UNREGISTER" = true ]; then
  echo "🔄 Unregistering existing runner..."
  ./config.sh remove --token "$TOKEN"
fi

# Configure the runner
echo "🚀 Configuring GitHub Actions runner..."
echo "  Repository: $REPO_URL"
echo "  Runner name: $RUNNER_NAME"
echo "  Labels: $LABELS"

# Run the configuration script
$CONFIG_SCRIPT --url "$REPO_URL" --token "$TOKEN" --name "$RUNNER_NAME" --labels "$LABELS" --unattended

echo "✅ Runner configured successfully! To start the runner, run:"
echo "  cd $RUNNER_DIR && ./run.sh"

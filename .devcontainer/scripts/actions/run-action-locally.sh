#!/bin/bash
set -e

# Function to display usage information
usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  --workflow WORKFLOW   Workflow file to run (e.g., .github/workflows/ci.yml)"
  echo "  --event EVENT         Event to trigger (default: push)"
  echo "  --job JOB             Specific job to run (runs all jobs if not specified)"
  echo "  --platform PLATFORM   Platform to run on (e.g., ubuntu-latest)"
  echo "  --verbose             Enable verbose output"
  echo "  --help                Display this help message"
  exit 1
}

# Default values
EVENT="push"
VERBOSE=""
PLATFORM_ARG=""
JOB_ARG=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --workflow)
      WORKFLOW="$2"
      shift 2
      ;;
    --event)
      EVENT="$2"
      shift 2
      ;;
    --job)
      JOB="$2"
      JOB_ARG="--job $JOB"
      shift 2
      ;;
    --platform)
      PLATFORM="$2"
      PLATFORM_ARG="--platform $PLATFORM"
      shift 2
      ;;
    --verbose)
      VERBOSE="-v"
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

# Check if workflow is provided
if [ -z "$WORKFLOW" ]; then
  echo "Error: Workflow file is required."
  usage
fi

# Check if workflow file exists
if [ ! -f "$WORKFLOW" ]; then
  echo "Error: Workflow file '$WORKFLOW' does not exist."
  exit 1
fi

echo "🚀 Running GitHub Action locally with act:"
echo "  Workflow: $WORKFLOW"
echo "  Event: $EVENT"
if [ -n "$JOB" ]; then
  echo "  Job: $JOB"
fi
if [ -n "$PLATFORM" ]; then
  echo "  Platform: $PLATFORM"
fi

# Run the action
echo "📋 Executing action..."
act $EVENT -W $WORKFLOW $JOB_ARG $PLATFORM_ARG $VERBOSE

echo "✅ GitHub Action execution completed."

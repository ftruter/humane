#!/bin/bash
# Script to configure branch protection for the main branch
# This script requires GitHub CLI (gh) to be installed and authenticated

set -e

REPO="ftruter/humane"
BRANCH="main"
AUTHORIZED_USER="ftruter"

echo "======================================"
echo "Branch Protection Setup Script"
echo "======================================"
echo ""
echo "Repository: $REPO"
echo "Branch: $BRANCH"
echo "Authorized User: $AUTHORIZED_USER"
echo ""

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed."
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "Error: Not authenticated with GitHub CLI."
    echo "Please run: gh auth login"
    exit 1
fi

echo "Setting up branch protection rules..."
echo ""

# Create branch protection rule
# Note: This uses the REST API to set comprehensive protection rules
gh api \
  --method PUT \
  "repos/$REPO/branches/$BRANCH/protection" \
  --field required_status_checks='{"strict":true,"contexts":["check-author"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"dismiss_stale_reviews":true,"require_code_owner_reviews":false,"required_approving_review_count":0}' \
  --field restrictions='{"users":["'"$AUTHORIZED_USER"'"],"teams":[],"apps":[]}' \
  --field required_linear_history=true \
  --field allow_force_pushes=false \
  --field allow_deletions=false \
  > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✓ Branch protection rules successfully configured!"
    echo ""
    echo "Protection includes:"
    echo "  - Only $AUTHORIZED_USER can push to $BRANCH"
    echo "  - Required status check: check-author workflow"
    echo "  - Pull requests required before merging"
    echo "  - Linear history required"
    echo "  - Force pushes disabled"
    echo "  - Branch deletion disabled"
    echo ""
    echo "View protection rules at:"
    echo "https://github.com/$REPO/settings/branches"
else
    echo "✗ Failed to configure branch protection rules"
    echo ""
    echo "You may need to configure them manually via GitHub's web interface."
    echo "See .github/BRANCH_PROTECTION.md for instructions."
    exit 1
fi

# Branch Protection Setup Guide

This guide explains how to protect the main branch of this repository so that only the repository owner (ftruter) can push to it.

## Automated Workflow Protection

A GitHub Actions workflow (`.github/workflows/protect-main-branch.yml`) has been added that will:
- Check every push to the main branch
- Verify that the push is from the authorized user (ftruter)
- Reject pushes from unauthorized users

**Note:** This workflow runs *after* the push, so it won't prevent the push but will mark the workflow as failed, providing visibility into unauthorized attempts.

## GitHub Branch Protection Rules (Recommended)

For complete protection, you should also configure GitHub's native branch protection rules. Follow these steps:

### Step 1: Navigate to Branch Protection Settings
1. Go to your repository on GitHub: https://github.com/ftruter/humane
2. Click on **Settings** (top right)
3. Click on **Branches** (left sidebar)
4. Under "Branch protection rules", click **Add rule**

### Step 2: Configure Protection Rules
Configure the following settings:

**Branch name pattern:**
```
main
```

**Recommended Settings:**
- ✓ **Require a pull request before merging**
  - ✓ Require approvals (set to 0 if you want to approve your own PRs)
  - ✓ Dismiss stale pull request approvals when new commits are pushed
- ✓ **Require status checks to pass before merging**
  - Add the workflow: `check-author`
- ✓ **Require conversation resolution before merging**
- ✓ **Require signed commits** (optional but recommended)
- ✓ **Require linear history** (optional)
- ✓ **Do not allow bypassing the above settings**
- ✓ **Restrict who can push to matching branches**
  - Add yourself (ftruter) to the list
  - This is the key setting that prevents others from pushing directly

### Step 3: Save and Apply
Click **Create** to save the branch protection rule.

## Alternative: Using GitHub CLI (Quick Setup)

A helper script has been provided to automatically configure branch protection. If you have the GitHub CLI (`gh`) installed and authenticated, simply run:

```bash
./.github/setup-branch-protection.sh
```

This script will configure all the recommended protection rules automatically.

## Verification

Once configured, you can verify the protection is active by:
1. Checking that the branch shows a protection badge in the GitHub UI
2. Attempting to push directly to main from another account (should be rejected)
3. Viewing the branch protection rules in Settings > Branches

## Notes

- **Repository Administrator:** As the repository owner, you may still have the ability to bypass these protections. Be careful!
- **Organization Repositories:** If this becomes an organization repository, adjust the restrictions accordingly
- **Workflow Protection:** The workflow provides an additional layer of verification but should be combined with GitHub's native branch protection for maximum security

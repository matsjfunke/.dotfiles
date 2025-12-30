## Git Config

- **User Details & SSH Signing**: Sets your name, email, and SSH signing key for commit verification
- **GPG Configuration**: Uses SSH format for commit signing
- **Core Settings**:
  - Neovim as the default editor
  - Delta as the pager for enhanced diff viewing (req: `brew install delta`)
- **Branch Management**:
  - Sets default branch name to main
  - Enables automatic rebase on pull
  - Configures rebase with auto-squash, auto-stash, and update-refs
- **Fetch & Push**:
  - Automatically prunes remote-tracking references
  - Auto-setup remote when pushing new branches
- **Display & UI**:
  - Automatic color UI
  - Column UI for better output formatting
  - Help autocorrect with prompt
  - Tags sorted by version
  - Branches sorted by most recent commit date
- **Git LFS**: Ensures large file handling is managed
- **Delta Integration**: Enhanced diff viewing with line numbers

**Aliases**:

- `st`: concise status
- `co`: checkout
- `sw`: switch branch
- `swc`: switch and create new branch
- `p`: pull
- `staash`: stash all changes
- `lg`: compact, colorful log view with graph
- `uncommit`: undo last commit (soft reset)
- `lfg "message"`: add, commit, and push in one command
- `pr "title"`: create GitHub PR with title (requires GitHub CLI)

**Steps to set up commit signing**:

```sh
# Step 1: Generate a new SSH key for commit signing
ssh-keygen -t ed25519 -f ~/.ssh/github_signing

# Step 2: Configure Git to use SSH for commit signing
git config --global gpg.format ssh

# Set the newly created key as your signing key
git config --global user.signingkey ~/.ssh/github_signing

# Set default to automatic signing for all commits
git config --global commit.gpgsign true

# Step 3: Display the public key to add to GitHub
cat ~/.ssh/github_signing.pub
```

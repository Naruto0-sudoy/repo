#!/bin/bash

# 📌 Base directory ที่จะสแกน repo ทั้งหมด
BASE_DIR="$HOME/OneDrive/GitBackup"
GITHUB_USER="thalindaac2218918"

process_git_repo() {
  local dir="$1"

  # ถ้าเป็น Git repo
  if [ -d "$dir/.git" ]; then
    REPO_NAME=$(basename "$dir")
    echo "========================================="
    echo "Processing repository: $REPO_NAME"

    # อัปเดต remote เป็น SSH
    git -C "$dir" remote set-url origin git@github.com:$GITHUB_USER/$REPO_NAME.git
    echo "✅ Updated remote origin for $REPO_NAME"
    git -C "$dir" remote -v

    # แสดง commit ล่าสุด
    echo "🔹 Last commits (simplified):"
    git -C "$dir" log --pretty=format:"%h %ad | %s [%an]" \
      --date=short --name-only --simplify-by-decoration | head -n 10

    # หาชื่อ branch ปัจจุบันแล้ว push
    CURRENT_BRANCH=$(git -C "$dir" branch --show-current)
    if [ -n "$CURRENT_BRANCH" ]; then
      echo "⬆️ Pushing $CURRENT_BRANCH to origin..."
      git -C "$dir" push -u origin "$CURRENT_BRANCH"
      echo "✅ Pushed $REPO_NAME/$CURRENT_BRANCH"
    else
      echo "⚠️ Cannot determine current branch for $REPO_NAME"
    fi

    echo "-----------------------------------------"
  fi

  # วนเข้า subfolder ต่อ
  for sub in "$dir"/*; do
    [ -d "$sub" ] && process_git_repo "$sub"
  done
}

# เริ่ม process จาก BASE_DIR
echo "📌 Starting from: $BASE_DIR"
process_git_repo "$BASE_DIR"

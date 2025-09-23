

#!/bin/bash

# โฟลเดอร์โปรเจกต์ทั้งหมด
PROJECTS_DIR=~/projects
OUTPUT_SUMMARY=$PROJECTS_DIR/open-source-summary.txt
MAIL_TEMPLATE=$PROJECTS_DIR/open-source-mail-template.txt

# ใบอนุญาตที่ถือเป็น Open Source
OPEN_SOURCE_LICENSES=("MIT" "GPL" "LGPL" "Apache-2.0" "BSD" "MPL-2.0" "EPL" "AGPL" "CC")

# สร้างไฟล์สรุปใหม่
echo "Open Source License Summary Report" > "$OUTPUT_SUMMARY"
echo "==================================" >> "$OUTPUT_SUMMARY"

# วนลูปตรวจสอบทุก repo
for repo in $(find "$PROJECTS_DIR" -name ".git" | sed 's|/\.git||'); do
  PROJECT_NAME=$(basename "$repo")
  cd "$repo" || continue

  # ตรวจสอบ license
  LICENSE=$(licensee detect . | grep "License:" | awk '{print $2}')

  # ตรวจสอบว่าเป็นโอเพ่นซอร์สไหม
  IS_OPEN="No"
  for l in "${OPEN_SOURCE_LICENSES[@]}"; do
    if [[ "$LICENSE" == "$l"* ]]; then
      IS_OPEN="Yes"
      break
    fi
  done

  # ถ้าเป็น Open Source ให้บันทึกข้อมูล
  if [[ "$IS_OPEN" == "Yes" ]]; then
    LAST_COMMIT=$(git log -1 --pretty=format:"%h - %an (%ae) %ad")
    REMOTE_URL=$(git remote get-url origin 2>/dev/null)
    echo "$PROJECT_NAME : $LICENSE : Last commit: $LAST_COMMIT : Remote: $REMOTE_URL" >> "$OUTPUT_SUMMARY"
  fi
done

echo "Open source check done. Summary saved to $OUTPUT_SUMMARY"

# สร้าง template เมลสำหรับ Open Source
cat <<EOM > "$MAIL_TEMPLATE"
To: nurlindaspj@gmail.com, 214227724+spjthalinda@users.noreply.github.com
Subject: Open Source Projects License Summary

Dear Team,

Please find attached the summary of all Open Source projects under our repositories:

$(cat "$OUTPUT_SUMMARY")

Best regards,
Thalinda Sripraj
EOM

echo "Mail template created at $MAIL_TEMPLATE"

#!/data/data/com.termux/files/usr/bin/bash

# ชื่อ remote ของ Google Drive
REMOTE="gdrive"

# โฟลเดอร์โปรเจกต์บนมือถือ
LOCAL_PROJECT="/storage/emulated/0/my_projects/google_project"

# โฟลเดอร์ปลายทางบน Google Drive
REMOTE_PROJECT="projects/google_project"

echo "เริ่มย้ายไฟล์ Google Project ไป Google Drive..."

# ตรวจสอบว่ามีโฟลเดอร์ local อยู่ไหม
if [ ! -d "$LOCAL_PROJECT" ]; then
    echo "โฟลเดอร์ $LOCAL_PROJECT ไม่พบ!"
    exit 1
fi

# ย้ายไฟล์ไป Google Drive พร้อม progress
rclone move "$LOCAL_PROJECT" "$REMOTE:$REMOTE_PROJECT" -P

# ตรวจสอบผลลัพธ์
if [ $? -eq 0 ]; then
    echo "ย้ายไฟล์เรียบร้อย ✅"
else
    echo "เกิดข้อผิดพลาดระหว่างย้ายไฟล์ ❌"
fi

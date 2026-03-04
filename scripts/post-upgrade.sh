
#!/bin/sh
# هذا السكربت يتنفذ تلقائياً بعد ما يخلص التحديث
echo "Starting Post-Upgrade Tasks..."

# تحديث التصاريح للأدوات الجديدة
chmod +x /usr/bin/k-tools 2>/dev/null

# تنظيف الكاش (المجلد اللي تنزل فيه الملفات المؤقتة)
rm -rf /var/cache/kynx/inbox/*

echo "System Optimization Complete."

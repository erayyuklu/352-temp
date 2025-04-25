#!/bin/bash

# Test sonuçları için dosya
OUTPUT_FILE="test_results.txt"

# Testleri çalıştır
python manage.py test \
  core.tests.test_user_models \
  core.tests.test_task_models \
  core.tests.test_volunteer_models \
  core.tests.test_notification_models \
  core.tests.test_review_models \
  core.tests.test_bookmark_models \
  core.tests.test_tag_models \
  core.tests.test_photo_models \
  core.tests.test_comment_models \
  core.tests.test_feed_class \
  core.tests.test_search_class \
  core.tests.test_integration > "$OUTPUT_FILE" 2>&1

# Test sonuçlarını kontrol et
if [ $? -eq 0 ]; then
  echo "Testler başarıyla tamamlandı. Sonuçlar $OUTPUT_FILE dosyasına kaydedildi."
else
  echo "Testler başarısız oldu. Detaylar $OUTPUT_FILE dosyasında."
fi

echo "Sonuç dosyası: $(pwd)/$OUTPUT_FILE"

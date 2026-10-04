TutorNote v6 for iPhone — PWA

РЕКОМЕНДОВАНИЙ ЗАПУСК
Не відкривайте index.html через «Файли»/Quick Look. Для нормальної роботи JavaScript та PWA використовуйте HTTPS (GitHub Pages) і Safari, після чого додайте TutorNote на початковий екран.

ОНОВЛЕННЯ З v5
- Перед оновленням бажано: Ще → Експорт резервної копії.
- Замініть файли index.html, app.js, styles.css, sw.js, manifest.webmanifest та іконки у GitHub.
- Дані localStorage під ключем tutornote_v1 не очищаються при звичайній заміні коду.
- Service Worker v6 має новий cache key і видалить старий кеш після активації.

ХМАРНА КОПІЯ
Supabase зберігає зашифрований ciphertext. Фраза відновлення не відправляється у Supabase. Не використовуйте secret/service_role key у TutorNote — лише Publishable/anon key.

/* Adds an accessible formative check to Networking lessons without a custom quiz. */
(() => {
  "use strict";
  const isLesson = /\/learning\/networking\/week-\d{2}\/day-\d{2}(?:\.html)?$/
    .test(window.location.pathname);
  if (!isLesson || document.querySelector("[data-nf-quiz]")) return;

  const host = document.createElement("section");
  host.className = "nf-quiz";
  host.dataset.nfQuiz = "true";
  host.setAttribute("aria-label", "آزمون پایان جلسه");
  host.innerHTML = `
    <div class="nf-quiz-header"><div><div class="nf-quiz-eyebrow">NETFLEET / KNOWLEDGE CHECK</div><h2>آزمون پایان جلسه</h2></div><div class="nf-quiz-stats">امتیاز: <strong data-score>0</strong></div></div>
    <p>سنجش پایهٔ فهم و روش کار مهندسی.</p>
    <div class="nf-quiz-progress" role="progressbar" aria-label="پیشرفت آزمون" aria-valuemin="0" aria-valuemax="100"><div class="nf-quiz-progress-bar" data-progress></div></div><div class="nf-quiz-progress-label" data-progress-text></div>
    <div data-content><h3 class="nf-quiz-question" data-question></h3><div class="nf-quiz-options" data-options></div><div class="nf-quiz-feedback" data-feedback aria-live="polite"></div><div class="nf-quiz-actions"><button class="nf-quiz-primary" type="button" data-next hidden>سؤال بعدی</button></div></div>
    <div class="nf-quiz-result" data-result hidden aria-live="polite"><div class="nf-quiz-eyebrow">ASSESSMENT COMPLETE</div><h3>نتیجه آزمون</h3><div class="nf-quiz-result-score" data-final-score></div><div class="nf-quiz-result-score" data-percentage></div><p data-result-message></p><button class="nf-quiz-primary" type="button" data-restart>تلاش مجدد</button></div>
    <script type="application/json" data-quiz-questions>[{"question":"پیش از تغییر یک تنظیم شبکه، کدام کار حرفه‌ای‌تر است؟","options":["تغییر هم‌زمان چند گزینه","ثبت وضعیت فعلی، فرضیه و یک آزمون کم‌خطر","کپی‌کردن پیکربندی ناشناس","Restart کردن همهٔ تجهیزات"],"answer":1,"explanation":"ثبت شواهد و آزمودن یک فرضیه در هر مرحله، علت واقعی را قابل تشخیص می‌کند."},{"question":"اگر یک ابزار نتیجهٔ موفق نشان دهد، کدام نتیجه‌گیری درست‌تر است؟","options":["کل شبکه حتماً سالم است","فقط همان ارتباط آزموده‌شده شواهد اولیه دارد","هیچ اطلاعاتی نداریم","همهٔ تنظیمات باید تغییر کنند"],"answer":1,"explanation":"هر آزمون محدوده دارد؛ نتیجه را به همان چیزی که واقعاً آزموده شده محدود کن."}]</script>`;
  document.querySelector("main.content")?.append(host);
})();

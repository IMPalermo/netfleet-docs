
$ErrorActionPreference = "Stop"

$root = (Get-Location).Path
$backup = Join-Path $root ("_backups\quiz-install-" + (Get-Date -Format "yyyyMMdd-HHmmss"))

$filesToBackup = @(
    "_quarto.yml",
    "learning\networking\week-01\day-01.qmd"
)

New-Item -ItemType Directory -Force $backup | Out-Null
New-Item -ItemType Directory -Force ".\assets\js\labs" | Out-Null
New-Item -ItemType Directory -Force ".\assets\css" | Out-Null

foreach ($file in $filesToBackup) {
    Copy-Item $file (Join-Path $backup (Split-Path $file -Leaf))
}

# 1. Quarto configuration
@'
project:
  type: website
  output-dir: _site
  resources:
    - assets/

website:
  title: "NetFleet Docs"
  description: "Infrastructure Engineering Knowledge Hub"

  navbar:
    title: "NETFLEET"
    left:
      - text: "Home"
        href: index.qmd
      - text: "Networking"
        href: learning/networking/index.qmd

  page-navigation: true

format:
  html:
    theme:
      - darkly
      - styles/custom.scss
    toc: true
    toc-depth: 3
    code-copy: true
    code-overflow: wrap
    smooth-scroll: true
    anchor-sections: true
    link-external-newwindow: true

language:
  title-block-author: "Author"
'@ | Set-Content .\_quarto.yml -Encoding UTF8

# 2. Quiz JavaScript engine
@'
(() => {
  "use strict";

  const questions = [
    {
      question: "کدام دستگاه برای اتصال چند دستگاه در یک شبکه محلی و ارسال فریم بر اساس MAC Address استفاده می‌شود؟",
      options: ["Router", "Switch", "Modem", "DNS Server"],
      answer: 1,
      explanation: "Switch با یادگیری MAC Addressها، فریم‌های Ethernet را به پورت مناسب در شبکه محلی هدایت می‌کند."
    },
    {
      question: "وظیفه اصلی Default Gateway چیست؟",
      options: [
        "تخصیص آدرس MAC",
        "تبدیل نام دامنه به IP",
        "ارسال ترافیک به خارج از شبکه محلی",
        "تخصیص آدرس IP به کلاینت"
      ],
      answer: 2,
      explanation: "وقتی مقصد خارج از Subnet محلی باشد، سیستم بسته را به Default Gateway می‌فرستد تا به شبکه مقصد مسیریابی شود."
    },
    {
      question: "کدام سرویس معمولاً آدرس IP را به‌صورت خودکار به کلاینت اختصاص می‌دهد؟",
      options: ["DNS", "HTTP", "DHCP", "ARP"],
      answer: 2,
      explanation: "DHCP اطلاعاتی مانند IP Address، Subnet Mask، Default Gateway و DNS Server را در اختیار کلاینت قرار می‌دهد."
    },
    {
      question: "سیستم شما آدرس 169.254.20.15 دریافت کرده است. محتمل‌ترین علت چیست؟",
      options: [
        "ارتباط موفق با DHCP Server",
        "عدم دریافت پاسخ DHCP و اختصاص آدرس APIPA",
        "وجود یک DNS Server معتبر",
        "اتصال موفق به Default Gateway"
      ],
      answer: 1,
      explanation: "آدرس‌های 169.254.0.0/16 معمولاً به‌صورت خودکار در Windows و در شرایط عدم دریافت پاسخ DHCP استفاده می‌شوند."
    },
    {
      question: "چرا ممکن است Ping به 8.8.8.8 موفق باشد اما Ping به google.com شکست بخورد؟",
      options: [
        "احتمال وجود مشکل در DNS",
        "خرابی قطعی کارت شبکه",
        "اشتباه بودن MAC Address",
        "خاموش بودن Switch"
      ],
      answer: 0,
      explanation: "ارتباط با IP برقرار است، اما ممکن است تبدیل نام دامنه به آدرس IP توسط DNS انجام نشود."
    }
  ];

  function initQuiz(root) {
    let current = 0;
    let score = 0;
    let answered = false;

    const questionNode = root.querySelector("[data-question]");
    const optionsNode = root.querySelector("[data-options]");
    const feedbackNode = root.querySelector("[data-feedback]");
    const progressNode = root.querySelector("[data-progress]");
    const progressText = root.querySelector("[data-progress-text]");
    const scoreNode = root.querySelector("[data-score]");
    const nextButton = root.querySelector("[data-next]");
    const restartButton = root.querySelector("[data-restart]");
    const resultNode = root.querySelector("[data-result]");
    const contentNode = root.querySelector("[data-content]");

    function renderQuestion() {
      const item = questions[current];
      answered = false;

      questionNode.textContent = item.question;
      optionsNode.replaceChildren();
      feedbackNode.textContent = "";
      feedbackNode.className = "nf-quiz-feedback";
      nextButton.hidden = true;
      resultNode.hidden = true;
      contentNode.hidden = false;

      item.options.forEach((option, index) => {
        const button = document.createElement("button");
        button.type = "button";
        button.className = "nf-quiz-option";
        button.textContent = option;
        button.addEventListener("click", () => selectAnswer(index));
        optionsNode.appendChild(button);
      });

      progressNode.style.width = `${(current / questions.length) * 100}%`;
      progressText.textContent = `سؤال ${current + 1} از ${questions.length}`;
      scoreNode.textContent = String(score);
    }

    function selectAnswer(selected) {
      if (answered) return;
      answered = true;

      const item = questions[current];
      const buttons = [...optionsNode.querySelectorAll("button")];
      const correct = selected === item.answer;

      buttons.forEach((button, index) => {
        button.disabled = true;
        if (index === item.answer) button.classList.add("is-correct");
        if (index === selected && !correct) button.classList.add("is-wrong");
      });

      if (correct) {
        score++;
        feedbackNode.classList.add("is-correct");
        feedbackNode.textContent = "درست است! " + item.explanation;
      } else {
        feedbackNode.classList.add("is-wrong");
        feedbackNode.textContent = "این پاسخ درست نیست. " +
          "پاسخ صحیح: " + item.options[item.answer] + ". " + item.explanation;
      }

      scoreNode.textContent = String(score);
      progressNode.style.width = `${((current + 1) / questions.length) * 100}%`;
      nextButton.hidden = false;
      nextButton.textContent =
        current === questions.length - 1 ? "مشاهده نتیجه" : "سؤال بعدی";
    }

    function showResult() {
      contentNode.hidden = true;
      resultNode.hidden = false;
      progressNode.style.width = "100%";

      const percentage = Math.round((score / questions.length) * 100);
      root.querySelector("[data-final-score]").textContent =
        `${score} از ${questions.length}`;
      root.querySelector("[data-percentage]").textContent = `${percentage}%`;

      let message = "نیاز به تمرین بیشتر داری. مفاهیم را مرور کن و دوباره امتحان بده.";
      if (percentage === 100) message = "عالی! تمام سؤال‌ها را درست پاسخ دادی.";
      else if (percentage >= 80) message = "عملکرد خوبی داشتی. آماده‌ای برای چالش‌های بعدی.";
      else if (percentage >= 60) message = "پایه‌ها را خوب شروع کرده‌ای. چند مفهوم را دوباره مرور کن.";

      root.querySelector("[data-result-message]").textContent = message;
    }

    nextButton.addEventListener("click", () => {
      if (!answered) return;

      if (current === questions.length - 1) {
        showResult();
      } else {
        current++;
        renderQuestion();
      }
    });

    restartButton.addEventListener("click", () => {
      current = 0;
      score = 0;
      renderQuestion();
    });

    renderQuestion();
  }

  document.querySelectorAll("[data-nf-quiz]").forEach(initQuiz);
})();
'@ | Set-Content .\assets\js\labs\network-fundamentals.js -Encoding UTF8

# 3. Responsive quiz stylesheet
@'
.nf-quiz {
  direction: rtl;
  margin: 3rem 0;
  padding: clamp(1.2rem, 3vw, 2rem);
  background: var(--nf-surface, #111813);
  border: 1px solid var(--nf-border, #29352d);
  border-radius: 18px;
  color: var(--nf-text, #e5eae6);
  text-align: right;
  overflow: hidden;
}

.nf-quiz-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.nf-quiz-eyebrow {
  color: var(--nf-green, #6faf88);
  font-family: "JetBrains Mono", monospace;
  font-size: .75rem;
  letter-spacing: .08em;
  text-transform: uppercase;
}

.nf-quiz h2,
.nf-quiz h3 {
  color: var(--nf-text, #e5eae6);
  margin: .4rem 0;
}

.nf-quiz-stats {
  display: flex;
  gap: .7rem;
  flex-wrap: wrap;
}

.nf-quiz-stat {
  background: var(--nf-card, #151e18);
  border: 1px solid var(--nf-border, #29352d);
  border-radius: 10px;
  padding: .45rem .8rem;
  font-size: .85rem;
}

.nf-quiz-progress {
  height: 7px;
  background: var(--nf-card, #151e18);
  border-radius: 20px;
  overflow: hidden;
  margin: 1.2rem 0 .6rem;
}

.nf-quiz-progress-bar {
  height: 100%;
  width: 0;
  background: var(--nf-green, #6faf88);
  border-radius: inherit;
  transition: width .25s ease;
}

.nf-quiz-progress-label {
  color: var(--nf-muted, #929d94);
  font-size: .8rem;
}

.nf-quiz-question {
  font-size: clamp(1.05rem, 2vw, 1.3rem);
  line-height: 1.9;
  margin: 1.6rem 0;
  font-weight: 600;
}

.nf-quiz-options {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: .8rem;
}

.nf-quiz-option {
  width: 100%;
  min-height: 58px;
  padding: .9rem 1rem;
  text-align: right;
  color: var(--nf-text, #e5eae6);
  background: var(--nf-card, #151e18);
  border: 1px solid var(--nf-border, #29352d);
  border-radius: 12px;
  cursor: pointer;
  font: inherit;
  line-height: 1.7;
  transition: background .2s ease, border-color .2s ease;
}

.nf-quiz-option:hover:not(:disabled) {
  background: var(--nf-hover, #1b2820);
  border-color: var(--nf-green, #6faf88);
}

.nf-quiz-option:focus-visible,
.nf-quiz button:focus-visible {
  outline: 2px solid var(--nf-light, #a8d5b6);
  outline-offset: 3px;
}

.nf-quiz-option:disabled {
  cursor: default;
  opacity: 1;
}

.nf-quiz-option.is-correct {
  border-color: #4eae78;
  background: rgba(46, 125, 78, .18);
}

.nf-quiz-option.is-wrong {
  border-color: #d16c6c;
  background: rgba(160, 55, 55, .15);
}

.nf-quiz-feedback {
  margin-top: 1rem;
  padding: 1rem;
  border-radius: 10px;
  line-height: 1.9;
  background: var(--nf-card, #151e18);
  border: 1px solid var(--nf-border, #29352d);
}

.nf-quiz-feedback:empty {
  display: none;
}

.nf-quiz-feedback.is-correct {
  border-color: #4eae78;
}

.nf-quiz-feedback.is-wrong {
  border-color: #d16c6c;
}

.nf-quiz-actions {
  display: flex;
  justify-content: flex-start;
  gap: .7rem;
  margin-top: 1.3rem;
}

.nf-quiz-primary,
.nf-quiz-secondary {
  border: 1px solid var(--nf-green, #6faf88);
  border-radius: 10px;
  padding: .7rem 1.2rem;
  font: inherit;
  cursor: pointer;
}

.nf-quiz-primary {
  color: #09110c;
  background: var(--nf-green, #6faf88);
  font-weight: 700;
}

.nf-quiz-secondary {
  color: var(--nf-light, #a8d5b6);
  background: transparent;
}

.nf-quiz-primary:hover,
.nf-quiz-secondary:hover {
  filter: brightness(1.1);
}

.nf-quiz-result {
  text-align: center;
  padding: 2rem 1rem;
}

.nf-quiz-result-score {
  font-size: clamp(2rem, 7vw, 3.5rem);
  font-weight: 700;
  color: var(--nf-light, #a8d5b6);
  margin: 1rem 0;
}

.nf-quiz-result p {
  color: var(--nf-muted, #929d94);
}

.nf-quiz [hidden] {
  display: none !important;
}

@media (max-width: 650px) {
  .nf-quiz-options {
    grid-template-columns: 1fr;
  }

  .nf-quiz-header {
    align-items: flex-start;
  }

  .nf-quiz-actions {
    flex-direction: column;
  }

  .nf-quiz-primary,
  .nf-quiz-secondary {
    width: 100%;
  }
}
'@ | Set-Content .\assets\css\quiz.css -Encoding UTF8

# 4. Add quiz to Day 01
$lessonPath = ".\learning\networking\week-01\day-01.qmd"
$lesson = Get-Content $lessonPath -Raw

if ($lesson -notmatch 'data-nf-quiz') {
    $quizMarkup = @'

```{=html}
<link rel="stylesheet" href="../../../../assets/css/quiz.css">

<section class="nf-quiz" data-nf-quiz aria-labelledby="nf-quiz-title">
  <div class="nf-quiz-header">
    <div>
      <div class="nf-quiz-eyebrow">NETFLEET / KNOWLEDGE CHECK</div>
      <h2 id="nf-quiz-title">آزمون تعاملی جلسه اول</h2>
    </div>
    <div class="nf-quiz-stats">
      <div class="nf-quiz-stat">امتیاز: <strong data-score>0</strong></div>
    </div>
  </div>

  <div class="nf-quiz-progress" role="progressbar" aria-label="پیشرفت آزمون" aria-valuemin="0" aria-valuemax="100">
    <div class="nf-quiz-progress-bar" data-progress></div>
  </div>
  <div class="nf-quiz-progress-label" data-progress-text></div>

  <div data-content>
    <h3 class="nf-quiz-question" data-question></h3>
    <div class="nf-quiz-options" data-options></div>
    <div class="nf-quiz-feedback" data-feedback aria-live="polite"></div>
    <div class="nf-quiz-actions">
      <button class="nf-quiz-primary" type="button" data-next hidden>سؤال بعدی</button>
    </div>
  </div>

  <div class="nf-quiz-result" data-result hidden aria-live="polite">
    <div class="nf-quiz-eyebrow">ASSESSMENT COMPLETE</div>
    <h3>نتیجه آزمون</h3>
    <div class="nf-quiz-result-score" data-final-score></div>
    <div class="nf-quiz-result-score" data-percentage></div>
    <p data-result-message></p>
    <button class="nf-quiz-primary" type="button" data-restart>تلاش مجدد</button>
  </div>
</section>

<script src="../../../../assets/js/labs/network-fundamentals.js" defer></script>
```
'@

    Add-Content -Path $lessonPath -Value $quizMarkup -Encoding UTF8
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host " NETFLEET INTERACTIVE QUIZ INSTALLED" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host "Backup: $backup"
Write-Host "Updated: _quarto.yml"
Write-Host "Created: assets\js\labs\network-fundamentals.js"
Write-Host "Created: assets\css\quiz.css"
Write-Host "Updated: learning\networking\week-01\day-01.qmd"
Write-Host ""
Write-Host "Next step: run quarto render"

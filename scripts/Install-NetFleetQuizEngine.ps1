
$ErrorActionPreference = "Stop"

$root = (Get-Location).Path
$day1 = Join-Path $root "learning\networking\week-01\day-01.qmd"
$day2 = Join-Path $root "learning\networking\week-01\day-02.qmd"
$enginePath = Join-Path $root "assets\js\labs\quiz-engine.js"

foreach ($file in @($day1, $day2)) {
    if (-not (Test-Path $file)) {
        throw "File not found: $file"
    }
}

# --------------------------------------------------
# 1. Generic quiz engine
# --------------------------------------------------

$engine = @'
(() => {
  "use strict";

  function initQuiz(root) {
    if (root.dataset.quizInitialized === "true") return;

    const dataNode = root.querySelector("[data-quiz-questions]");
    if (!dataNode) {
      console.error("NetFleet Quiz: question data not found.", root);
      return;
    }

    let questions;

    try {
      questions = JSON.parse(dataNode.textContent);
    } catch (error) {
      console.error("NetFleet Quiz: invalid question JSON.", error);
      return;
    }

    if (!Array.isArray(questions) || questions.length === 0) {
      console.error("NetFleet Quiz: no questions configured.");
      return;
    }

    for (const item of questions) {
      if (
        typeof item.question !== "string" ||
        !Array.isArray(item.options) ||
        item.options.length < 2 ||
        !Number.isInteger(item.answer) ||
        item.answer < 0 ||
        item.answer >= item.options.length
      ) {
        console.error("NetFleet Quiz: invalid question configuration.", item);
        return;
      }
    }

    root.dataset.quizInitialized = "true";

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
    const finalScore = root.querySelector("[data-final-score]");
    const percentageNode = root.querySelector("[data-percentage]");
    const resultMessage = root.querySelector("[data-result-message]");

    const required = [
      questionNode, optionsNode, feedbackNode, progressNode,
      progressText, scoreNode, nextButton, restartButton,
      resultNode, contentNode, finalScore, percentageNode,
      resultMessage
    ];

    if (required.some(node => !node)) {
      console.error("NetFleet Quiz: required HTML elements are missing.", root);
      root.dataset.quizInitialized = "false";
      return;
    }

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

      progressNode.style.width =
        `${(current / questions.length) * 100}%`;

      const progress = root.querySelector(".nf-quiz-progress");
      if (progress) {
        progress.setAttribute("aria-valuenow", String(
          Math.round((current / questions.length) * 100)
        ));
      }

      progressText.textContent =
        `سؤال ${current + 1} از ${questions.length}`;

      scoreNode.textContent = String(score);
    }

    function selectAnswer(selected) {
      if (answered) return;

      answered = true;

      const item = questions[current];
      const buttons = [
        ...optionsNode.querySelectorAll("button")
      ];

      const correct = selected === item.answer;

      buttons.forEach((button, index) => {
        button.disabled = true;

        if (index === item.answer) {
          button.classList.add("is-correct");
        }

        if (index === selected && !correct) {
          button.classList.add("is-wrong");
        }
      });

      if (correct) {
        score++;
        feedbackNode.classList.add("is-correct");
        feedbackNode.textContent =
          "درست است! " + (item.explanation || "");
      } else {
        feedbackNode.classList.add("is-wrong");
        feedbackNode.textContent =
          "این پاسخ درست نیست. پاسخ صحیح: " +
          item.options[item.answer] + ". " +
          (item.explanation || "");
      }

      scoreNode.textContent = String(score);

      const percentage = Math.round(
        ((current + 1) / questions.length) * 100
      );

      progressNode.style.width = `${percentage}%`;

      const progress = root.querySelector(".nf-quiz-progress");
      if (progress) {
        progress.setAttribute("aria-valuenow", String(percentage));
      }

      nextButton.hidden = false;
      nextButton.textContent =
        current === questions.length - 1
          ? "مشاهده نتیجه"
          : "سؤال بعدی";
    }

    function showResult() {
      contentNode.hidden = true;
      resultNode.hidden = false;

      progressNode.style.width = "100%";

      const progress = root.querySelector(".nf-quiz-progress");
      if (progress) {
        progress.setAttribute("aria-valuenow", "100");
      }

      const percentage = Math.round(
        (score / questions.length) * 100
      );

      finalScore.textContent =
        `${score} از ${questions.length}`;

      percentageNode.textContent = `${percentage}%`;

      let message =
        "نیاز به تمرین بیشتر داری. مفاهیم را مرور کن و دوباره امتحان بده.";

      if (percentage === 100) {
        message = "عالی! تمام سؤال‌ها را درست پاسخ دادی.";
      } else if (percentage >= 80) {
        message = "عملکرد خوبی داشتی. آماده‌ای برای چالش‌های بعدی.";
      } else if (percentage >= 60) {
        message = "پایه‌ها را خوب شروع کرده‌ای. چند مفهوم را دوباره مرور کن.";
      }

      resultMessage.textContent = message;
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
'@

New-Item -ItemType Directory -Force `
    (Split-Path $enginePath) | Out-Null

Set-Content -Path $enginePath -Value $engine -Encoding UTF8

# --------------------------------------------------
# 2. Day 01 questions (original questions preserved)
# --------------------------------------------------

$questions1 = @(
    @{
        question = "کدام دستگاه برای اتصال چند دستگاه در یک شبکه محلی و ارسال فریم بر اساس MAC Address استفاده می‌شود؟"
        options = @("Router", "Switch", "Modem", "DNS Server")
        answer = 1
        explanation = "Switch با یادگیری MAC Addressها، فریم‌های Ethernet را به پورت مناسب در شبکه محلی هدایت می‌کند."
    },
    @{
        question = "وظیفه اصلی Default Gateway چیست؟"
        options = @(
            "تخصیص آدرس MAC",
            "تبدیل نام دامنه به IP",
            "ارسال ترافیک به خارج از شبکه محلی",
            "تخصیص آدرس IP به کلاینت"
        )
        answer = 2
        explanation = "وقتی مقصد خارج از Subnet محلی باشد، سیستم بسته را به Default Gateway می‌فرستد."
    },
    @{
        question = "کدام سرویس معمولاً آدرس IP را به‌صورت خودکار به کلاینت اختصاص می‌دهد؟"
        options = @("DNS", "HTTP", "DHCP", "ARP")
        answer = 2
        explanation = "DHCP اطلاعاتی مانند IP Address، Subnet Mask، Default Gateway و DNS Server را در اختیار کلاینت قرار می‌دهد."
    },
    @{
        question = "سیستم شما آدرس 169.254.20.15 دریافت کرده است. محتمل‌ترین علت چیست؟"
        options = @(
            "ارتباط موفق با DHCP Server",
            "عدم دریافت پاسخ DHCP و اختصاص آدرس APIPA",
            "وجود یک DNS Server معتبر",
            "اتصال موفق به Default Gateway"
        )
        answer = 1
        explanation = "آدرس‌های 169.254.0.0/16 معمولاً در شرایط عدم دریافت پاسخ DHCP به‌صورت خودکار استفاده می‌شوند."
    },
    @{
        question = "چرا ممکن است Ping به 8.8.8.8 موفق باشد اما Ping به google.com شکست بخورد؟"
        options = @(
            "احتمال وجود مشکل در DNS",
            "خرابی قطعی کارت شبکه",
            "اشتباه بودن MAC Address",
            "خاموش بودن Switch"
        )
        answer = 0
        explanation = "ارتباط با IP برقرار است، اما ممکن است تبدیل نام دامنه به آدرس IP توسط DNS انجام نشود."
    }
)

# --------------------------------------------------
# 3. Day 02 questions
# --------------------------------------------------

$questions2 = @(
    @{
        question = "مهم‌ترین دلیل استفاده از معماری لایه‌ای در شبکه چیست؟"
        options = @(
            "حذف کامل نیاز به پروتکل‌ها",
            "تقسیم وظایف و کاهش پیچیدگی طراحی و عیب‌یابی",
            "افزایش تعداد آدرس‌های MAC",
            "جلوگیری از استفاده از Router"
        )
        answer = 1
        explanation = "معماری لایه‌ای وظایف را تفکیک می‌کند و امکان توسعه، تعامل‌پذیری و عیب‌یابی ساختاریافته را فراهم می‌سازد."
    },
    @{
        question = "کدام مورد وظیفه اصلی Physical Layer است؟"
        options = @(
            "مسیریابی بسته‌ها",
            "مدیریت نشست‌های برنامه",
            "انتقال بیت‌ها روی رسانه فیزیکی",
            "تبدیل نام دامنه به IP"
        )
        answer = 2
        explanation = "لایه فیزیکی سیگنال‌ها، رسانه انتقال، کانکتورها و نحوه انتقال بیت‌ها را تعریف می‌کند."
    },
    @{
        question = "کدام PDU معمولاً به لایه Network در مدل OSI مربوط است؟"
        options = @("Frame", "Packet", "Segment", "Bit")
        answer = 1
        explanation = "در لایه Network داده معمولاً به شکل Packet بررسی می‌شود."
    },
    @{
        question = "وظیفه اصلی Transport Layer چیست؟"
        options = @(
            "ارسال سیگنال الکتریکی",
            "آدرس‌دهی MAC",
            "ارتباط انتها به انتها و استفاده از Port Number",
            "انتخاب مسیر بین شبکه‌ها"
        )
        answer = 2
        explanation = "Transport Layer ارتباط بین پردازش‌های دو میزبان را با سازوکارهایی مانند TCP و UDP فراهم می‌کند."
    },
    @{
        question = "در مدل TCP/IP چهارلایه، پروتکل IP در کدام لایه قرار می‌گیرد؟"
        options = @("Application", "Transport", "Internet", "Link")
        answer = 2
        explanation = "IP در Internet Layer مدل چهارلایه TCP/IP قرار می‌گیرد."
    },
    @{
        question = "در فرایند Encapsulation چه اتفاقی می‌افتد؟"
        options = @(
            "حذف تمام Headerها",
            "اضافه شدن اطلاعات کنترلی هر لایه به داده",
            "تبدیل IP به MAC در تمام مسیر",
            "تبدیل TCP به DNS"
        )
        answer = 1
        explanation = "هر لایه اطلاعات موردنیاز خود را معمولاً در قالب Header و در برخی لایه‌ها Trailer اضافه می‌کند."
    },
    @{
        question = "کدام گزینه درباره TCP و UDP صحیح است؟"
        options = @(
            "هر دو همیشه اتصال‌گرا هستند",
            "UDP تضمین تحویل و ترتیب دارد",
            "TCP سازوکارهای تحویل قابل‌اعتماد و ترتیب‌دهی دارد",
            "TCP فقط برای DNS استفاده می‌شود"
        )
        answer = 2
        explanation = "TCP تحویل قابل‌اعتماد و مرتب‌سازی جریان داده را فراهم می‌کند؛ UDP چنین تضمین‌هایی را به‌صورت ذاتی ارائه نمی‌دهد."
    },
    @{
        question = "چرا در ارتباط بین دو شبکه، MAC Address در هر Hop تغییر می‌کند؟"
        options = @(
            "چون IP در هر Router حذف می‌شود",
            "چون هر لینک لایه دو فریم مخصوص خودش را دارد",
            "چون DNS در هر Hop آدرس را عوض می‌کند",
            "چون TCP آدرس MAC تولید می‌کند"
        )
        answer = 1
        explanation = "Router بسته IP را در فریم جدید لینک خروجی قرار می‌دهد. آدرس‌های MAC مربوط به همان لینک محلی هستند."
    },
    @{
        question = "موفق بودن Ping به یک سرور اما شکست TCP Port 443 بیشتر چه چیزی را نشان می‌دهد؟"
        options = @(
            "قطعاً کابل شبکه خراب است",
            "ممکن است سرویس، فایروال یا مسیر TCP مشکل داشته باشد",
            "حتماً DNS خراب است",
            "قطعاً کارت شبکه خاموش است"
        )
        answer = 1
        explanation = "Ping و TCP Port Test دو آزمایش متفاوت‌اند. پاسخ ICMP به معنی در دسترس بودن سرویس HTTPS نیست."
    },
    @{
        question = "برای مشاهده فریم‌ها و تحلیل پروتکل‌ها در شبکه از کدام ابزار استفاده می‌شود؟"
        options = @("Wireshark", "Notepad", "Task Manager", "Paint")
        answer = 0
        explanation = "Wireshark بسته‌ها و فریم‌های Capture شده را برای تحلیل پروتکل‌ها نمایش می‌دهد."
    }
)

# --------------------------------------------------
# 4. Update an existing quiz section
# --------------------------------------------------

function Set-QuizData {
    param(
        [string]$Content,
        [string]$Json
    )

    $sectionPattern = '(?s)(<section class="nf-quiz"[^>]*>)(.*?)(</section>)'

    if (-not [regex]::IsMatch($Content, $sectionPattern)) {
        throw "Quiz HTML section not found."
    }

    $Content = [regex]::Replace(
        $Content,
        $sectionPattern,
        [System.Text.RegularExpressions.MatchEvaluator]{
            param($match)

            $inner = $match.Groups[2].Value

            $inner = [regex]::Replace(
                $inner,
                '(?s)<script type="application/json" data-quiz-questions>.*?</script>',
                ''
            )

            $jsonScript = @"
<script type="application/json" data-quiz-questions>
$Json
</script>
"@

            return $match.Groups[1].Value +
                $inner +
                "`n" +
                $jsonScript +
                $match.Groups[3].Value
        },
        1
    )

    return $Content
}

$json1 = ConvertTo-Json -InputObject $questions1 -Depth 5
$json2 = ConvertTo-Json -InputObject $questions2 -Depth 5

# --------------------------------------------------
# 5. Update Day 01
# --------------------------------------------------

$content1 = Get-Content $day1 -Raw

$content1 = Set-QuizData -Content $content1 -Json $json1

$content1 = [regex]::Replace(
    $content1,
    '<script src="[^"]*network-fundamentals\.js" defer></script>',
    '<script src="../../../../assets/js/labs/quiz-engine.js" defer></script>'
)

$content1 = [regex]::Replace(
    $content1,
    '<script src="[^"]*quiz-engine\.js" defer></script>',
    '<script src="../../../../assets/js/labs/quiz-engine.js" defer></script>'
)

Set-Content -Path $day1 -Value $content1 -Encoding UTF8

# --------------------------------------------------
# 6. Add Day 02 quiz
# --------------------------------------------------

$content2 = Get-Content $day2 -Raw

if ($content2 -notmatch 'data-nf-quiz') {

    $quiz2 = @'
 
```{=html}
<link rel="stylesheet" href="../../../../assets/css/quiz.css">

<section class="nf-quiz" data-nf-quiz aria-labelledby="nf-quiz-title">
  <div class="nf-quiz-header">
    <div>
      <div class="nf-quiz-eyebrow">NETFLEET / KNOWLEDGE CHECK</div>
      <h2 id="nf-quiz-title">آزمون تعاملی جلسه دوم</h2>
    </div>
    <div class="nf-quiz-stats">
      <div class="nf-quiz-stat">امتیاز: <strong data-score>0</strong></div>
    </div>
  </div>

  <div class="nf-quiz-progress" role="progressbar"
       aria-label="پیشرفت آزمون"
       aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
    <div class="nf-quiz-progress-bar" data-progress></div>
  </div>

  <div class="nf-quiz-progress-label" data-progress-text></div>

  <div data-content>
    <h3 class="nf-quiz-question" data-question></h3>
    <div class="nf-quiz-options" data-options></div>
    <div class="nf-quiz-feedback" data-feedback aria-live="polite"></div>
    <div class="nf-quiz-actions">
      <button class="nf-quiz-primary" type="button" data-next hidden>
        سؤال بعدی
      </button>
    </div>
  </div>

  <div class="nf-quiz-result" data-result hidden aria-live="polite">
    <div class="nf-quiz-eyebrow">ASSESSMENT COMPLETE</div>
    <h3>نتیجه آزمون</h3>
    <div class="nf-quiz-result-score" data-final-score></div>
    <div class="nf-quiz-result-score" data-percentage></div>
    <p data-result-message></p>
    <button class="nf-quiz-primary" type="button" data-restart>
      تلاش مجدد
    </button>
  </div>

  <script type="application/json" data-quiz-questions>
__DAY02_JSON__
  </script>
</section>

<script src="../../../../assets/js/labs/quiz-engine.js" defer></script>
```
'@

    $quiz2 = $quiz2.Replace("__DAY02_JSON__", $json2)

    $content2 = $content2.TrimEnd() + "`r`n`r`n" + $quiz2

    Set-Content -Path $day2 -Value $content2 -Encoding UTF8
}
else {
    Write-Host "Day 02 quiz already exists. Skipped adding duplicate markup."
}

# --------------------------------------------------
# 7. Verification
# --------------------------------------------------

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " NETFLEET QUIZ ENGINE INSTALLATION"
Write-Host "==========================================" -ForegroundColor Cyan

$checks = @(
    @{
        Name = "Generic quiz engine"
        Path = $enginePath
    },
    @{
        Name = "Day 01 quiz"
        Path = $day1
    },
    @{
        Name = "Day 02 quiz"
        Path = $day2
    }
)

foreach ($check in $checks) {
    $exists = Test-Path $check.Path
    Write-Host ("{0}: {1}" -f $check.Name, $exists)
}

Write-Host ""
Write-Host "Day 01 question count: $($questions1.Count)"
Write-Host "Day 02 question count: $($questions2.Count)"
Write-Host ""
Write-Host "Installation completed." -ForegroundColor Green

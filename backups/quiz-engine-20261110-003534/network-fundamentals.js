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

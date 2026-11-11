
/* =========================================================
   NETFLEET | GENERIC NETWORK FUNDAMENTALS QUIZ ENGINE
   Version: 2.0.0
   Supports multiple independent quizzes on one page.
   ========================================================= */

(() => {
  "use strict";

  const SELECTORS = {
    quiz: "[data-nf-quiz]",
    questions: 'script[type="application/json"][data-quiz-questions]',
    question: "[data-question]",
    options: "[data-options]",
    feedback: "[data-feedback]",
    next: "[data-next]",
    score: "[data-score]",
    progress: "[data-progress]",
    progressText: "[data-progress-text]",
    content: "[data-content]",
    result: "[data-result]",
    finalScore: "[data-final-score]",
    percentage: "[data-percentage]",
    resultMessage: "[data-result-message]",
    restart: "[data-restart]"
  };

  const query = (root, selector) => root.querySelector(selector);

  function shuffle(items) {
    const result = [...items];

    for (let i = result.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [result[i], result[j]] = [result[j], result[i]];
    }

    return result;
  }

  function validateQuestions(questions) {
    if (!Array.isArray(questions) || questions.length === 0) {
      return false;
    }

    return questions.every((item) => {
      if (
        !item ||
        typeof item.question !== "string" ||
        !Array.isArray(item.options) ||
        item.options.length < 2 ||
        !item.options.every(option => typeof option === "string")
      ) {
        return false;
      }

      if (Number.isInteger(item.answer)) {
        return item.answer >= 0 &&
          item.answer < item.options.length;
      }

      if (typeof item.answer === "string") {
        return item.options.includes(item.answer);
      }

      return false;
    });
  }

  function getCorrectIndex(question) {
    if (Number.isInteger(question.answer)) {
      return question.answer;
    }

    return question.options.indexOf(question.answer);
  }

  function getResultMessage(percentage) {
    if (percentage === 100) {
      return "عالی! تمام سؤال‌ها را درست پاسخ دادی. تسلط فوق‌العاده‌ای داری.";
    }

    if (percentage >= 80) {
      return "بسیار خوب! مفاهیم اصلی را به‌خوبی یاد گرفته‌ای.";
    }

    if (percentage >= 60) {
      return "خوب پیش رفتی. چند مفهوم را دوباره مرور کن تا تسلطت بیشتر شود.";
    }

    if (percentage >= 40) {
      return "شروع خوبی است. پیشنهاد می‌کنیم بخش‌های آموزشی این جلسه را دوباره بخوانی.";
    }

    return "هنوز جای یادگیری وجود دارد. درس را مرور کن و دوباره به آزمون برگرد.";
  }

  function initializeQuiz(root) {
    if (root.dataset.quizInitialized === "true") {
      return;
    }

    const elements = {};

    for (const [key, selector] of Object.entries(SELECTORS)) {
      elements[key] = query(root, selector);
    }

    const requiredElements = [
      "questions",
      "question",
      "options",
      "feedback",
      "next",
      "score",
      "progress",
      "progressText",
      "content",
      "result",
      "finalScore",
      "percentage",
      "resultMessage",
      "restart"
    ];

    const missingElements = requiredElements.filter(
      key => !elements[key]
    );

    if (missingElements.length > 0) {
      console.error(
        "[NetFleet Quiz] Missing HTML elements:",
        missingElements,
        root
      );
      return;
    }

    let questions;

    try {
      questions = JSON.parse(elements.questions.textContent);
    } catch (error) {
      console.error("[NetFleet Quiz] Invalid quiz JSON:", error);
      elements.feedback.textContent =
        "خطا در بارگذاری سؤال‌های آزمون. ساختار JSON را بررسی کنید.";
      return;
    }

    if (!validateQuestions(questions)) {
      console.error("[NetFleet Quiz] Invalid question structure:", questions);
      elements.feedback.textContent =
        "ساختار سؤال‌های آزمون معتبر نیست.";
      return;
    }

    // Mark the quiz initialized only after successful validation.
    root.dataset.quizInitialized = "true";

    let currentQuestion = 0;
    let score = 0;
    let answered = false;

    function updateProgress() {
      const percentage = Math.round(
        (currentQuestion / questions.length) * 100
      );

      elements.progress.style.width = `${percentage}%`;

      const progressContainer = elements.progress.parentElement;

      if (progressContainer?.getAttribute("role") === "progressbar") {
        progressContainer.setAttribute(
          "aria-valuenow",
          String(percentage)
        );
      }

      elements.progressText.textContent =
        `سؤال ${currentQuestion + 1} از ${questions.length}`;
    }

    function renderQuestion() {
      answered = false;

      const question = questions[currentQuestion];
      const correctIndex = getCorrectIndex(question);

      elements.question.textContent =
        `${currentQuestion + 1}. ${question.question}`;

      elements.options.replaceChildren();
      elements.feedback.textContent = "";
      elements.feedback.className = "nf-quiz-feedback";
      elements.next.hidden = true;

      elements.score.textContent = String(score);

      updateProgress();

      // Keep original indexes so shuffled options remain correct.
      const options = shuffle(
        question.options.map((text, originalIndex) => ({
          text,
          originalIndex
        }))
      );

      options.forEach((option, index) => {
        const button = document.createElement("button");

        button.type = "button";
        button.className = "nf-quiz-option";
        button.textContent = option.text;
        button.dataset.originalIndex = String(option.originalIndex);
        button.setAttribute("aria-label", option.text);

        button.addEventListener("click", () => {
          selectAnswer(button, option.originalIndex, correctIndex);
        });

        elements.options.appendChild(button);
      });

      elements.content.hidden = false;
      elements.result.hidden = true;
    }

    function selectAnswer(selectedButton, selectedIndex, correctIndex) {
      if (answered) return;

      answered = true;

      const isCorrect = selectedIndex === correctIndex;

      if (isCorrect) {
        score++;
        elements.score.textContent = String(score);
      }

      const allOptions = elements.options.querySelectorAll(
        ".nf-quiz-option"
      );

      allOptions.forEach(button => {
        button.disabled = true;

        const originalIndex = Number(button.dataset.originalIndex);

        if (originalIndex === correctIndex) {
          button.classList.add("is-correct");
        }
      });

      if (!isCorrect) {
        selectedButton.classList.add("is-wrong");
      }

      elements.feedback.classList.add(
        isCorrect ? "is-correct" : "is-wrong"
      );

      const explanation =
        questions[currentQuestion].explanation || "";

      elements.feedback.textContent = isCorrect
        ? `✓ پاسخ صحیح است. ${explanation}`
        : `✗ پاسخ اشتباه است. پاسخ صحیح: ${
            questions[currentQuestion].options[correctIndex]
          }. ${explanation}`;

      elements.next.textContent =
        currentQuestion === questions.length - 1
          ? "مشاهده نتیجه"
          : "سؤال بعدی";

      elements.next.hidden = false;
      elements.next.focus();
    }

    function showResult() {
      const percentage = Math.round(
        (score / questions.length) * 100
      );

      elements.content.hidden = true;
      elements.result.hidden = false;

      elements.progress.style.width = "100%";

      const progressContainer = elements.progress.parentElement;

      if (progressContainer?.getAttribute("role") === "progressbar") {
        progressContainer.setAttribute("aria-valuenow", "100");
      }

      elements.progressText.textContent = "آزمون تکمیل شد";

      elements.finalScore.textContent =
        `${score} / ${questions.length}`;

      elements.percentage.textContent =
        `${percentage}%`;

      elements.resultMessage.textContent =
        getResultMessage(percentage);

      elements.result.scrollIntoView({
        behavior: "smooth",
        block: "nearest"
      });
    }

    function nextQuestion() {
      if (!answered) return;

      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
        renderQuestion();
      } else {
        showResult();
      }
    }

    function restartQuiz() {
      currentQuestion = 0;
      score = 0;
      answered = false;

      elements.score.textContent = "0";

      renderQuestion();

      root.scrollIntoView({
        behavior: "smooth",
        block: "nearest"
      });
    }

    elements.next.addEventListener("click", nextQuestion);
    elements.restart.addEventListener("click", restartQuiz);

    renderQuestion();

    console.info(
      `[NetFleet Quiz] Initialized successfully: ${questions.length} questions.`,
      root
    );
  }

  function initializeAllQuizzes() {
    document.querySelectorAll(SELECTORS.quiz).forEach(initializeQuiz);
  }

  if (document.readyState === "loading") {
    document.addEventListener(
      "DOMContentLoaded",
      initializeAllQuizzes,
      { once: true }
    );
  } else {
    initializeAllQuizzes();
  }

})();

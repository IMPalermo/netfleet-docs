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

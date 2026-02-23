/**
 * Bot Factory — Chat Module
 *
 * Handles chat messaging, typing indicators, and suggestion chips.
 * Configurable via BOT_CONFIG object set in the HTML page.
 *
 * Required: Set window.BOT_CONFIG before loading this script.
 *   window.BOT_CONFIG = {
 *     apiUrl: '/api/guitar',
 *     botName: 'The Fret Detective',
 *     placeholder: 'Ask about guitar...'
 *   };
 *
 * Optional: Set window.BOT_CONFIG.formatMessage to a function that
 * takes (text, containerDiv) and handles custom rendering.
 * If not set, messages render as plain text.
 */

const chatMessages = document.getElementById("chatMessages");
const chatInput = document.getElementById("chatInput");
const chatSuggestions = document.getElementById("chatSuggestions");

const config = window.BOT_CONFIG || {
  apiUrl: "/api/bot",
  botName: "Bot",
  placeholder: "Type a message...",
};

// Conversation history — persists for the browser session.
// Resets on page refresh, which is fine for a casual chatbot.
const conversationHistory = [];

/**
 * Default message formatter — renders text as plain text with line breaks.
 * Bot-specific formatters (e.g. guitar/formatter.js) can override this
 * by setting BOT_CONFIG.formatMessage.
 */
function defaultFormatMessage(text, container) {
  const lines = text.split("\n");
  lines.forEach((line, i) => {
    const span = document.createElement("span");
    span.textContent = line;
    container.appendChild(span);
    if (i < lines.length - 1) {
      container.appendChild(document.createElement("br"));
    }
  });
}

/**
 * Stream a welcome message into the chat on first load.
 * Simulates the streaming UX so the message appears character by character.
 */
function streamWelcomeMessage() {
  const welcomeText =
    `Welcome to The Fret Detective 🔎🎸\n\n` +
    `Got a guitar question? I'll solve it. New player, returning player, or stuck on a "why does this sound wrong?" moment ` +
    `just ask and I'll give you clean, step-by-step answers.`;

  const div = document.createElement("div");
  div.className = "chat-message bot";
  const label = document.createElement("div");
  label.className = "bot-label";
  label.textContent = config.botName;
  div.appendChild(label);
  chatMessages.appendChild(div);

  let index = 0;
  const chunkSize = 3; // characters per tick for natural speed
  const interval = 15; // ms between ticks

  function streamNext() {
    if (index >= welcomeText.length) return;

    index = Math.min(index + chunkSize, welcomeText.length);
    const partial = welcomeText.substring(0, index);

    // Clear previous content (keep the bot-label)
    while (div.childNodes.length > 1) {
      div.removeChild(div.lastChild);
    }

    const formatter = config.formatMessage || defaultFormatMessage;
    formatter(partial, div);
    chatMessages.scrollTop = chatMessages.scrollHeight;

    requestAnimationFrame(() => setTimeout(streamNext, interval));
  }

  streamNext();
}

/**
 * Send a suggestion chip's text as a message
 */
function sendSuggestion(chip) {
  chatInput.value = chip.textContent;
  sendMessage();
}

/**
 * Send the current input as a message (with streaming)
 */
async function sendMessage() {
  const message = chatInput.value.trim();
  if (!message) return;

  addMessage(message, "user");
  chatInput.value = "";

  // Hide suggestions after first message
  if (chatSuggestions) {
    chatSuggestions.style.display = "none";
  }

  const typing = showTyping();

  try {
    const isLocal =
      window.location.hostname === "localhost" ||
      window.location.hostname === "127.0.0.1";

    // Use Lambda Function URL for streaming in production
    const streamingBaseUrl =
      "https://3ettzcchtayaww5ff7pxowx7ka0tapuw.lambda-url.us-east-1.on.aws";
    const endpoint = isLocal
      ? `${config.apiUrl}/chat/stream`
      : `${streamingBaseUrl}${config.apiUrl}/chat/stream`;

    const response = await fetch(endpoint, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        message,
        conversation_history: conversationHistory,
      }),
    });

    let fullResponse = "";
    let div = null;

    const reader = response.body.getReader();
    const decoder = new TextDecoder();

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      const chunk = decoder.decode(value, { stream: true });
      fullResponse += chunk;

      // On first chunk: remove typing dots and create the bot bubble
      if (!div) {
        typing.remove();
        div = document.createElement("div");
        div.className = "chat-message bot";
        const label = document.createElement("div");
        label.className = "bot-label";
        label.textContent = config.botName;
        div.appendChild(label);
        chatMessages.appendChild(div);
      }

      // Clear previous content (keep the bot-label)
      while (div.childNodes.length > 1) {
        div.removeChild(div.lastChild);
      }

      const formatter = config.formatMessage || defaultFormatMessage;
      formatter(fullResponse, div);
      chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    // Safety net: remove typing if stream ended with no chunks
    if (!div) {
      typing.remove();
    }

    conversationHistory.push(
      { role: "user", content: message },
      { role: "assistant", content: fullResponse },
    );

    const maxMessages = 20;
    if (conversationHistory.length > maxMessages) {
      conversationHistory.splice(0, conversationHistory.length - maxMessages);
    }
  } catch (error) {
    typing.remove();
    addMessage("Sorry, I couldn't connect. Try again in a moment.", "bot");
  }
}

/**
 * Add a message bubble to the chat
 */
function addMessage(text, type) {
  const div = document.createElement("div");
  div.className = `chat-message ${type}`;

  if (type === "bot") {
    const label = document.createElement("div");
    label.className = "bot-label";
    label.textContent = config.botName;
    div.appendChild(label);

    // Use custom formatter if registered, otherwise plain text
    const formatter = config.formatMessage || defaultFormatMessage;
    formatter(text, div);
  } else {
    div.textContent = text;
  }

  chatMessages.appendChild(div);
  chatMessages.scrollTop = chatMessages.scrollHeight;
}

/**
 * Show typing indicator, returns the element for removal
 */
function showTyping() {
  const div = document.createElement("div");
  div.className = "typing-indicator";
  div.innerHTML = "<span></span><span></span><span></span>";
  chatMessages.appendChild(div);
  chatMessages.scrollTop = chatMessages.scrollHeight;
  return div;
}

// Enter key sends message
chatInput.addEventListener("keydown", function (e) {
  if (e.key === "Enter") sendMessage();
});

// Stream the welcome message when the chat section becomes visible
streamWelcomeMessage();

const warmupUrl =
  window.location.hostname === "localhost" ||
  window.location.hostname === "127.0.0.1"
    ? `${config.apiUrl}/warmup`
    : `https://3ettzcchtayaww5ff7pxowx7ka0tapuw.lambda-url.us-east-1.on.aws${config.apiUrl}/warmup`;
fetch(warmupUrl).catch(() => {});

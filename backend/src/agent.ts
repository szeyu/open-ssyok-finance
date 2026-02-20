import { LlmAgent, InMemoryRunner, isFinalResponse, stringifyContent, StreamingMode } from '@google/adk';
import { createUserContent } from '@google/genai';
import { ChatMessage, UserData } from './types.js';

const SYSTEM_INSTRUCTION = `You are ssyok Finance AI, a friendly and knowledgeable financial advisor for young Malaysians.

The user's complete financial profile will be provided at the start of each message. Use this data to give personalised, specific advice.

**Your guidelines:**
- Always use RM for Malaysian Ringgit
- Reference Malaysian-specific financial instruments when relevant:
  - EPF (Employees Provident Fund) — employer + employee contributions
  - ASB (Amanah Saham Bumiputera) — guaranteed returns unit trust
  - PTPTN — student loan with 1% service charge
  - Unit trusts (Public Mutual, Maybank AM, Kenanga, etc.)
  - REITs listed on Bursa Malaysia (Pavilion REIT, IGB REIT, etc.)
  - Tabung Haji — halal savings and pilgrimage fund
  - PRS (Private Retirement Scheme) — tax-deductible retirement savings
- Consider Malaysian cost of living: mamak meals, LRT/MRT commute, rental prices
- Use encouraging, friendly language — like a knowledgeable kawan (friend)
- Format responses with markdown headers and bullet points for clarity
- Keep responses concise (under 300 words) but actionable
- If the user has no data yet, give general Malaysian financial advice and encourage them to add their details

Always end with a concrete next step the user can take today.`;

// Initialise agent once per cold start — reused across requests
const agent = new LlmAgent({
  name: 'ssyok_finance_advisor',
  model: 'gemini-2.5-flash',
  instruction: SYSTEM_INSTRUCTION,
  description: 'Friendly Malaysian financial advisor with access to user financial data',
});

const runner = new InMemoryRunner({ agent });

/**
 * Build the full message string combining financial profile, history and current question.
 */
function buildFullMessage(messages: ChatMessage[], userData: UserData): string {
  const latestMessage = messages[messages.length - 1];
  const priorMessages = messages.slice(0, -1);
  const historySection =
    priorMessages.length > 0
      ? '\n\n---\n**Our conversation so far:**\n' +
      priorMessages
        .map((m: ChatMessage) => `**${m.role === 'user' ? 'You' : 'ssyok AI'}:** ${m.content}`)
        .join('\n\n')
      : '';
  return (
    `**My Financial Profile:**\n${userData.context}` +
    historySection +
    `\n\n---\n**My Question:**\n${latestMessage.content}`
  );
}

/**
 * Validate that a Gemini API key is present.
 */
function validateApiKey(): void {
  if (!process.env.GEMINI_API_KEY && !process.env.GOOGLE_GENAI_API_KEY) {
    throw new Error('GEMINI_API_KEY is not configured');
  }
}

/**
 * Stream chat response as an async generator, yielding text chunks as they arrive.
 * Each yielded string is a partial token from Gemini. The generator completes
 * when the final response event is received.
 */
export async function* chatWithAgentStream({
  messages,
  userData,
}: {
  messages: ChatMessage[];
  userData: UserData;
}): AsyncGenerator<string> {
  validateApiKey();

  const session = await runner.sessionService.createSession({
    appName: runner.appName,
    userId: 'user',
  });

  const fullMessage = buildFullMessage(messages, userData);

  for await (const event of runner.runAsync({
    userId: session.userId,
    sessionId: session.id,
    newMessage: createUserContent(fullMessage),
    runConfig: { streamingMode: StreamingMode.SSE },
  })) {
    const text = stringifyContent(event);
    if (!text) continue;

    if (event.partial) {
      // Streaming chunk — emit immediately
      yield text;
    } else if (isFinalResponse(event)) {
      // Final event — emit and stop
      yield text;
      return;
    }
  }
}

/**
 * Chat with the ssyok Finance ADK agent (non-streaming, kept for compatibility).
 * Each call creates a fresh session (Cloud Functions are stateless).
 * Conversation history is replayed as formatted context in the message.
 */
export async function chatWithAgent({
  messages,
  userData,
}: {
  messages: ChatMessage[];
  userData: UserData;
}): Promise<string> {
  validateApiKey();

  const session = await runner.sessionService.createSession({
    appName: runner.appName,
    userId: 'user',
  });

  const fullMessage = buildFullMessage(messages, userData);

  let finalResponse = '';

  for await (const event of runner.runAsync({
    userId: session.userId,
    sessionId: session.id,
    newMessage: createUserContent(fullMessage),
  })) {
    if (isFinalResponse(event)) {
      finalResponse = stringifyContent(event) || '';
    }
  }

  return (
    finalResponse ||
    "Sorry, I couldn't generate a response. Please try again! 🙏"
  );
}

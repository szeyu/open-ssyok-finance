// Dynamic imports — @google/adk and @google/genai are loaded on first request,
// not at module load time. This avoids the Firebase emulator's 10-second
// function discovery timeout (the ADK dependency tree is too large to resolve
// within that window).
import type { InMemoryRunner } from '@google/adk';
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

// Cached dynamic imports — loaded once, reused across requests.
let _adk: typeof import('@google/adk') | null = null;
let _genai: typeof import('@google/genai') | null = null;
let _runner: InMemoryRunner | null = null;

async function loadDeps() {
  if (!_adk) _adk = await import('@google/adk');
  if (!_genai) _genai = await import('@google/genai');
  return { adk: _adk, genai: _genai };
}

async function getRunner(): Promise<InMemoryRunner> {
  const { adk } = await loadDeps();
  if (!_runner) {
    const agent = new adk.LlmAgent({
      name: 'ssyok_finance_advisor',
      model: 'gemini-2.5-flash',
      instruction: SYSTEM_INSTRUCTION,
      description: 'Friendly Malaysian financial advisor with access to user financial data',
    });
    _runner = new adk.InMemoryRunner({ agent });
  }
  return _runner;
}

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

  const { adk, genai } = await loadDeps();
  const runner = await getRunner();
  const session = await runner.sessionService.createSession({
    appName: runner.appName,
    userId: 'user',
  });

  const fullMessage = buildFullMessage(messages, userData);

  for await (const event of runner.runAsync({
    userId: session.userId,
    sessionId: session.id,
    newMessage: genai.createUserContent(fullMessage),
    runConfig: { streamingMode: adk.StreamingMode.SSE },
  })) {
    const text = adk.stringifyContent(event);
    if (!text) continue;

    if (event.partial) {
      // Streaming chunk — emit immediately
      yield text;
    } else if (adk.isFinalResponse(event)) {
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

  const { adk, genai } = await loadDeps();
  const runner = await getRunner();
  const session = await runner.sessionService.createSession({
    appName: runner.appName,
    userId: 'user',
  });

  const fullMessage = buildFullMessage(messages, userData);

  let finalResponse = '';

  for await (const event of runner.runAsync({
    userId: session.userId,
    sessionId: session.id,
    newMessage: genai.createUserContent(fullMessage),
  })) {
    if (adk.isFinalResponse(event)) {
      finalResponse = adk.stringifyContent(event) || '';
    }
  }

  return (
    finalResponse ||
    "Sorry, I couldn't generate a response. Please try again! 🙏"
  );
}

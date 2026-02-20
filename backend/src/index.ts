import { onRequest } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import { logger } from 'firebase-functions';
import { chatWithAgentStream } from './agent.js';
import { ChatRequest } from './types.js';

const geminiApiKey = defineSecret('GEMINI_API_KEY');

/**
 * POST /chat
 *
 * Proxies user messages to Gemini 2.5 Flash via Google ADK.
 * The Gemini API key is stored as a Firebase secret — never exposed to the client.
 *
 * Request body: { userId, messages, userData }
 * Response:     { response: string }
 */
export const chat = onRequest(
  {
    region: 'asia-southeast1',
    secrets: [geminiApiKey],
    cors: true,
    timeoutSeconds: 60,
    memory: '256MiB',
  },
  async (req, res) => {
    if (req.method !== 'POST') {
      res.status(405).json({ error: 'Method not allowed' });
      return;
    }

    try {
      const { userId, messages, userData } = req.body as ChatRequest;

      // Basic validation
      if (!userId) {
        res.status(400).json({ error: 'Missing userId' });
        return;
      }
      if (!messages || !Array.isArray(messages) || messages.length === 0) {
        res.status(400).json({ error: 'Missing or empty messages array' });
        return;
      }
      if (!userData) {
        res.status(400).json({ error: 'Missing userData' });
        return;
      }

      logger.info('Chat request received', { userId, messageCount: messages.length });

      // Set SSE headers
      res.setHeader('Content-Type', 'text/event-stream');
      res.setHeader('Cache-Control', 'no-cache');
      res.setHeader('Connection', 'keep-alive');
      res.setHeader('X-Accel-Buffering', 'no'); // Disable nginx buffering if present
      res.status(200);

      let totalLength = 0;
      try {
        for await (const chunk of chatWithAgentStream({ messages, userData })) {
          const payload = JSON.stringify({ chunk });
          res.write(`data: ${payload}\n\n`);
          totalLength += chunk.length;
        }
      } catch (streamError) {
        logger.error('Stream error', streamError);
        res.write(`data: ${JSON.stringify({ error: 'Stream error' })}\n\n`);
      } finally {
        res.write('data: [DONE]\n\n');
        res.end();
        logger.info('Chat stream completed', { userId, totalLength });
      }
    } catch (error) {
      logger.error('Chat error', error);
      // Headers not yet sent if we hit an error during setup/validation
      if (!res.headersSent) {
        res.status(500).json({ error: 'Internal server error' });
      }
    }
  }
);

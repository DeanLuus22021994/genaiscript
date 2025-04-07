import { LLMProvider } from './TestBase';

export class MockLLMProvider implements LLMProvider {
  private responses: Map<string, string> = new Map();
  private defaultResponse: string = 'Default mock response';
  
  setResponse(prompt: string, response: string): void {
    this.responses.set(prompt, response);
  }
  
  setDefaultResponse(response: string): void {
    this.defaultResponse = response;
  }
  
  async generateText(prompt: string): Promise<string> {
    const response = this.responses.get(prompt);
    if (response) {
      return response;
    }
    return this.defaultResponse;
  }
  
  async chat(messages: Array<{role: string, content: string}>): Promise<string> {
    const lastMessage = messages[messages.length - 1];
    return this.generateText(lastMessage.content);
  }
}
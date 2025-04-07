// Define a simple LLMProvider interface for testing
export interface LLMProvider {
    generateText(prompt: string): Promise<string>;
    chat(messages: Array<{role: string, content: string}>): Promise<string>;
    setResponse?(prompt: string, response: string): void;
    setDefaultResponse?(response: string): void;
  }

export abstract class TestBase {
  protected testContext: Record<string, any> = {};
  
  constructor() {
    this.setUp = this.setUp.bind(this);
    this.tearDown = this.tearDown.bind(this);
  }
  
  async setUp(): Promise<void> {
    this.testContext = {};
  }
  
  async tearDown(): Promise<void> {
    this.testContext = {};
  }
  
  async withSetupAndTeardown(testFn: () => Promise<void>): Promise<void> {
    await this.setUp();
    try {
      await testFn();
    } finally {
      await this.tearDown();
    }
  }
}

export class GenAIScriptTest extends TestBase {
    public mockLLMProvider: LLMProvider;
    
    async setUp(): Promise<void> {
      await super.setUp();
      const { MockLLMProvider } = await import('./MockLLMProvider');
      this.mockLLMProvider = new MockLLMProvider();
    }
  }
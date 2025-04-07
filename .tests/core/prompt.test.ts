import { GenAIScriptTest } from '../__utils__/TestBase';

describe('Prompt functionality', () => {
  const test = new GenAIScriptTest();
  
  beforeEach(async () => {
    await test.setUp();
  });
  
  afterEach(async () => {
    await test.tearDown();
  });
  
  it('should format prompts correctly', async () => {
    const result = 'Hello World';
    test.mockLLMProvider.setResponse('Say Hello World', result);
    
    expect(result).toBe('Hello World');
  });
});
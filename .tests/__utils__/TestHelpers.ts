import * as fs from 'fs';
import * as path from 'path';

export function getFixturePath(relativePath: string): string {
  return path.join(__dirname, '..', '__fixtures__', relativePath);
}

export function loadFixture(relativePath: string): string {
  return fs.readFileSync(getFixturePath(relativePath), 'utf-8');
}

export function createTempDir(): string {
  const tempDir = path.join(__dirname, '..', '__fixtures__', 'temp', Date.now().toString());
  fs.mkdirSync(tempDir, { recursive: true });
  return tempDir;
}

export function cleanupTempDir(tempDir: string): void {
  if (fs.existsSync(tempDir)) {
    fs.rmSync(tempDir, { recursive: true, force: true });
  }
}

export async function runWithTimeout<T>(
  promise: Promise<T>, 
  timeoutMs: number = 5000
): Promise<T> {
  let timeoutId: NodeJS.Timeout;
  
  const timeoutPromise = new Promise<never>((_, reject) => {
    timeoutId = setTimeout(() => {
      reject(new Error(`Operation timed out after ${timeoutMs}ms`));
    }, timeoutMs);
  });
  
  return Promise.race([
    promise.then(result => {
      clearTimeout(timeoutId);
      return result;
    }),
    timeoutPromise
  ]);
}
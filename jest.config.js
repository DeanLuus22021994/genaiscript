module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: [
    '<rootDir>/.tests'
  ],
  testMatch: [
    '**/*.test.ts'
  ],
  transform: {
    '^.+\\.tsx?$': ['ts-jest', {
      tsconfig: '.tests/tsconfig.json'
    }]
  },
  moduleNameMapper: {
    '^@core/(.*)$': '<rootDir>/packages/core/src/$1',
    '^@cli/(.*)$': '<rootDir>/packages/cli/src/$1',
    '^@vscode/(.*)$': '<rootDir>/packages/vscode/src/$1',
    '^@utils/(.*)$': '<rootDir>/.tests/__utils__/$1'
  },
  setupFilesAfterEnv: [
    '<rootDir>/.tests/config/jest.setup.js'
  ],
  collectCoverageFrom: [
    'packages/*/src/**/*.ts',
    '!packages/*/src/**/*.d.ts'
  ],
  coverageDirectory: 'coverage',
  verbose: true
}
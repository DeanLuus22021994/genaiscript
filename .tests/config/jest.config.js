module.exports = {
    preset: 'ts-jest',
    testEnvironment: 'node',
    roots: ['<rootDir>/../.tests'],
    testMatch: ['**/*.test.ts'],
    collectCoverageFrom: [
      '<rootDir>/../packages/**/*.ts',
      '<rootDir>/../genaisrc/**/*.ts',
      '<rootDir>/../genaisrc/**/*.mts',
      '<rootDir>/../genaisrc/**/*.mjs',
      '!**/node_modules/**',
      '!**/dist/**'
    ],
    coverageDirectory: '<rootDir>/../.tests/coverage',
    setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
    moduleNameMapper: {
      '^@core/(.*)$': '<rootDir>/../packages/core/src/$1',
      '^@cli/(.*)$': '<rootDir>/../packages/cli/src/$1',
      '^@vscode/(.*)$': '<rootDir>/../packages/vscode/src/$1'
    },
    transform: {
      '^.+\\.tsx?$': ['ts-jest', {
        tsconfig: '<rootDir>/../.tests/tsconfig.json'
      }]
    }
  }
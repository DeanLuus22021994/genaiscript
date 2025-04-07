// Sample JavaScript file for testing
const greeting = "Hello, World!";

/**
 * A simple function that returns a greeting message
 * @param {string} name - The name to greet
 * @returns {string} - The greeting message
 */
function greet(name) {
  return `${greeting} My name is ${name}.`;
}

/**
 * Calculate the sum of two numbers
 * @param {number} a - First number
 * @param {number} b - Second number
 * @returns {number} - The sum of a and b
 */
function add(a, b) {
  return a + b;
}

module.exports = {
  greet,
  add
};
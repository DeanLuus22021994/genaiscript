// Sample TypeScript file for testing
interface Person {
  name: string;
  age: number;
  email?: string;
}

/**
 * Creates a new person object
 * @param name - The person's name
 * @param age - The person's age
 * @param email - Optional email address
 * @returns A Person object
 */
export function createPerson(name: string, age: number, email?: string): Person {
  return {
    name,
    age,
    ...(email ? { email } : {})
  };
}

/**
 * Formats a person's information as a string
 * @param person - The person object
 * @returns Formatted string with person's information
 */
export function formatPerson(person: Person): string {
  let result = `Name: ${person.name}, Age: ${person.age}`;
  if (person.email) {
    result += `, Email: ${person.email}`;
  }
  return result;
}
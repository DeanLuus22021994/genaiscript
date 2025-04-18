// This module provides functions to parse and stringify INI formatted strings,
// with error handling and utility support for cleaning up the input content.

// Import the parse and stringify functions from the "ini" library
import { parse, stringify } from "ini"

// Import a utility function to log errors
import { logError } from "./util"

// Import a custom function to clean up INI content by removing any fencing
import { unfence } from "./unwrappers"
import { filenameOrFileToContent } from "./unwrappers"

/**
 * Parses an INI formatted string after cleaning it by removing fencing and resolving file content.
 *
 * @param text - INI formatted string or file content to process
 * @returns Parsed object
 */
export function INIParse(text: string) {
    text = filenameOrFileToContent(text)
    const cleaned = unfence(text, "ini") // Remove any fencing from the text
    return parse(cleaned) // Parse the cleaned text into an object
}

/**
 * Parses an INI formatted string, logs errors if parsing fails, and returns a default value.
 *
 * @param text - The INI formatted string or file content to parse
 * @param defaultValue - The value to return if parsing fails
 * @returns The parsed object or the default value
 */
export function INITryParse(text: string, defaultValue?: any) {
    try {
        return INIParse(text) // Attempt to parse the text
    } catch (e) {
        logError(e) // Log any parsing errors
        return defaultValue // Return the default value if parsing fails
    }
}

/**
 * Converts an object into an INI formatted string.
 *
 * @param o - The object to stringify
 * @returns The INI formatted string
 */
export function INIStringify(o: any) {
    return stringify(o) // Convert the object to an INI formatted string
}

import _ci from "ci-info"
import { confirm } from "@inquirer/prompts"
import { logVerbose } from "../../core/src/util"
import { indent } from "../../core/src/indent"

const confirmed: string[] = []

/**
 * Prompts the user for confirmation or skips the prompt in a CI environment.
 *
 * @param message - The prompt message to display to the user.
 * @param options - Optional configuration for the prompt.
 * @param options.preview - An optional preview message to display before the prompt.
 * @returns A promise that resolves to `true` if the user confirmed or if running in CI, and `false` otherwise.
 */
export async function confirmOrSkipInCI(
    message: string,
    options?: { preview?: string }
): Promise<boolean> {
    if (ci.isCI || confirmed.includes(message)) return true

    const { preview } = options || {}

    if (preview) {
        logVerbose(indent(`preview:`, " "))
        logVerbose(indent(preview, "  "))
    }
    const res = await confirm({
        message,
        default: true,
    })
    if (res) confirmed.push(message)
    return res
}

export const ci = _ci

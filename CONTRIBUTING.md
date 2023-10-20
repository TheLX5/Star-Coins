# Contributing

## General Rules

These are the general rules if you want to contribute to Star Coins, code or otherwise:

- Please write descriptive commit messages.
- Do not upload any copyrighted material, most notable ROM files.
- Keep comments civil, no personal attacks on other people.
- Dates are in the format `D/Mon/YY`.

## ASM

For ASM codes, the following rules apply:

- Use lowercase letters for opcodes.
- Indentations are four spaces wide and be replaced with spaces.
  - Make sure the comments all start on the same column. This only applies within thea single file.
- Code is indented at least once and never all the way to the left.
  - The exception applies to labels, defines and conditionals which are indented one level lower than code.
  - Conditionals increase the indentation by one.
- Keep labels however short on separate lines.
- Also keep them as descriptive as possible, don't overuse +/- labels, keep them for skipping at most two opcodes.
- General defines (i.e. defines in `star_coins_defs.asm` of external resources) should be prefixed with `star_coin` to avoid naming conflicts.
  - There are few defines which have no mention of `star_coin` whatsoever but they're mostly grandfathered.
- Defines, labels, macros and functions specific to Star Coins are in snake_case.


---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled, or mentions "grill me".
---

Interview the user about every aspect of the plan until shared understanding is reached. Walk down each branch of the decision tree, resolving dependencies between decisions one-by-one.

## Process

Ask one question at a time and wait for the answer before moving on.

For each question, lead with a recommendation and reasoning. When real alternatives exist, present 2–3 options with their trade-offs — generating the option space is part of the work, don't make the user do it. When there are no real alternatives, don't manufacture them.

Explore the codebase to answer your own questions before asking. A question the code can answer shouldn't be asked.

As the plan takes shape, present it back incrementally and get confirmation on each piece before moving on. Don't reveal the whole design in one go at the end.

Go back and re-clarify when a later answer contradicts an earlier one. The decision tree isn't strictly linear.

End when the decisions are resolved enough to start implementing, or when the user signals they have what they need. Don't keep grilling for its own sake.

## Principles

- **One question at a time** — don't overwhelm with multiple questions.
- **Multiple choice preferred** — easier to react to than open-ended when the option space can be enumerated.
- **YAGNI ruthlessly** — remove unnecessary features from all designs and push back on speculative scope ("might also want", "could eventually need").
- **Explore alternatives** — propose 2–3 approaches before settling, when real alternatives exist.
- **Incremental validation** — present design pieces, get approval, then move on.
- **Be flexible** — go back and re-clarify when something doesn't make sense.

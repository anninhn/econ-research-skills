# Economics Research Project

## Research Mode

When discussing research design, analysis, or results in this project, follow these rules:

### Always-On Quality Scanner

Scan every message for these red flags and alert the user immediately when detected:

**Data Flags:**
- "I'll collect data later" → STOP. Confirm data exists before proceeding.
- "Treatment affects everyone" → Need control group or variation in treatment intensity.
- "I have a lot of data" → Quantity does not equal quality. What is the source of exogenous variation?

**Method Flags:**
- "controls will fix it" → Controls cannot fix identification problems.
- "just correlation" → What is the identification strategy?
- "I'll use matching" → Matching only controls for observables. What about unobservables?
- "natural experiment" → What makes this exogenous? Can you prove it?

**Result Flags:**
- Effect size > 100% → Flag as implausible. Suggest: check coding, drop outliers, run placebo tests.
- "significant in all specifications" → Possible p-hacking. Ask about unreported tests.
- "IV estimate is much larger than OLS" → Check for weak IV or exclusion violation.

**Language Flags:**
- "proves" → suggest "provides evidence for"
- "proves causality" → "provides causal evidence"
- "clearly" / "obviously" → Remove. If it is clear, you don't need to say it.
- "perfectly identified" → "credibly identified"
- "no endogeneity" → "addresses endogeneity concerns"

### Conversation Rules

1. **Data first.** Always ask about data availability before discussing method or specification.
2. **Identification before specification.** Confirm the source of exogenous variation before recommending a regression.
3. **Flag inline.** Raise problems as part of the natural conversation, not as separate alerts.
4. **One question at a time.** Ask progressive follow-ups rather than dumping a full checklist.
5. **Be specific.** Don't say "check robustness" — say "run the event study with leads at t-4 through t-1 and test that pre-trend coefficients are jointly zero."

## Code Conventions

- Default to Stata for econometrics unless R or Python is specified.
- Use clean variable names: `treat`, `post`, `treat_post` for DiD variables.
- Always report: coefficient, standard error, N, R-squared, fixed effects used.

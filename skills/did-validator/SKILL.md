---
name: did-validator
description: Validate difference-in-differences research design. Use when user mentions DiD, parallel trends, before-and-after with treatment and control, or comparing outcomes across groups over time.
user-invocable: true
---


# Difference-in-Differences Validator

## ROLE

You are a DiD specialist who validates difference-in-differences research designs. Your job is to ensure the user's DiD setup is valid, assumptions are testable, and common pitfalls are avoided.

## KNOWLEDGE

### The DiD Estimator

**Basic 2×2 DiD:**

$$\hat{\beta}^{DiD} = (\bar{Y}_{T,post} - \bar{Y}_{T,pre}) - (\bar{Y}_{C,post} - \bar{Y}_{C,pre})$$

**Regression form:**

$$Y_{ist} = \alpha + \beta(Treat_i \times Post_t) + \gamma Treat_i + \delta_t + \varepsilon_{ist}$$

Or with two-way fixed effects:

$$Y_{ist} = \beta(Treat_i \times Post_t) + \gamma_i + \delta_t + \varepsilon_{ist}$$

Where:
- $Y_{ist}$ = Outcome for unit $i$, in group $s$, at time $t$
- $Treat_i$ = 1 if treated, 0 if control
- $Post_t$ = 1 if post-treatment period, 0 if pre
- $\gamma_i$ = Unit fixed effects
- $\delta_t$ = Time fixed effects
- $\beta$ = **ATT (Average Treatment Effect on Treated)**

### Intuition

DiD answers: "How much MORE did the treatment group change compared to what it WOULD have changed without treatment?"

```
         ┌───────────── AFTER ─────────────┐
         │                                  │
    Y_T  │         ×───────×                │
         │        /                         │
         │       /  β = treatment effect    │
         │      /   (the jump)              │
    Y_C  │  ×──×──×─────────×────×          │
         │ /    ↘  (counterfactual)         │
         │/      ↘                          │
         ×───────────────────────────────── TIME
              BEFORE    │    AFTER
                        │
                    TREATMENT
```

### Key Assumptions

| Assumption | Definition | Mathematical | How to Test |
|------------|------------|--------------|-------------|
| **Parallel Trends** | T and C would follow same trend absent treatment | $E[Y_{T,post}^0 - Y_{T,pre} \mid D=1] = E[Y_{C,post} - Y_{C,pre} \mid D=0]$ | Pre-treatment trends, event study |
| **No Anticipation** | Treatment doesn't affect behavior before it happens | $E[Y_{T,pre} \mid D=1] = E[Y_{T,pre}^0 \mid D=1]$ | Pre-treatment coefficients = 0 |
| **SUTVA** | No spillovers between units | $Y_i(D) = Y_i(D_i)$ | Theoretical argument, geographic buffer |
| **Stable Composition** | No selective entry/exit | $P(D=1 \mid X)$ stable over time | Check composition, test attrition |
| **Common Shocks** | Time effects same for T and C | $\delta_t$ captures all time variation | Time fixed effects |

### Modern DiD: The TWFE Problem

**The Goodman-Bacon (2021) Decomposition:**

With staggered adoption, TWFE can be biased because:
- "Already treated" units serve as controls for "newly treated"
- This is problematic if treatment effects are heterogeneous

**When TWFE is biased:**
- Staggered adoption (different treatment times)
- Heterogeneous treatment effects (β varies over time or across groups)

**Solutions:**

| Solution | Citation | When to Use |
|----------|----------|-------------|
| Callaway-Sant'Anna | 2021 | Staggered adoption, want ATT |
| Sun-Abraham | 2021 | Heterogeneous effects, want cohort ATT |
| de Chaisemartin-D'Haultfoeuille | 2020 | Any staggered design |
| Borusyak et al. | 2024 | Imputation approach, efficient |
| Gardner | 2022 | Two-stage imputation |

### Event Study Specification

$$Y_{ist} = \sum_{k \neq -1} \beta_k (Treat_i \times \mathbf{1}[t = k]) + \gamma_i + \delta_t + \varepsilon_{ist}$$

Where $k$ indexes time relative to treatment.

**Interpretation:**
- $\beta_k = 0$ for $k < 0$ → Parallel trends ✓
- $\beta_0$ → Immediate effect
- $\beta_k$ for $k > 0$ → Dynamic effects

```
        β_k
         │
    +5   │              ×────×
         │             /
     0 ──┼────×──×────×───────────
         │   /  \
    -5   │  ×    ×
         │
         └────────────────────────── k
              -3 -2 -1 0 1 2 3
                    ↑
               treatment
```

## WORKFLOW

### Step 1: Verify Setup

Ask these questions IN ORDER:

```
SETUP VERIFICATION
==================

1. TREATMENT DEFINITION
   Q: What exactly is the treatment?
   - Is it binary (treated/not treated)?
   - Is timing sharp (all treated at same time)?
   - Is there variation in treatment intensity?

   ⚠️ RED FLAG: "Everyone is treated" → No control group
   ⚠️ RED FLAG: "Treatment is gradual" → Staggered adoption issues

2. TREATMENT GROUP
   Q: Who is treated?
   - How do you define the treatment group?
   - Is assignment observable?
   - Could assignment be endogenous?

   ⚠️ RED FLAG: Self-selected into treatment → Endogeneity

3. CONTROL GROUP
   Q: Who is NOT treated?
   - Are they comparable to treated?
   - Why weren't they treated?
   - Could they be affected by treatment (spillovers)?

   ⚠️ RED FLAG: "Control group is all other units" → May be contaminated
   ⚠️ RED FLAG: No clear control → Cannot identify

4. TIMING
   Q: When does treatment occur?
   - Exact date?
   - Different times for different units? (staggered)
   - Was timing anticipated?

   ⚠️ RED FLAG: "Treatment timing varies" → Staggered DiD needed
   ⚠️ RED FLAG: "Announced in advance" → Anticipation effects

5. OUTCOME
   Q: What is the outcome variable?
   - Measured at what level?
   - Available before AND after treatment?
   - Measured consistently over time?

   ⚠️ RED FLAG: Outcome definition changed → Measurement error
```

### Step 2: Check Data Structure

```
DATA STRUCTURE REQUIREMENTS
===========================

MINIMUM:
┌────────────────────────┬─────────────────────────────────┐
│       Requirement      │              Check              │
├────────────────────────┼─────────────────────────────────┤
│ Panel or repeated CS   │ Same units OR same population   │
│ ≥ 1 pre-period         │ Can observe baseline            │
│ ≥ 1 post-period        │ Can observe effect              │
│ Treatment varies       │ Some treated, some not          │
└────────────────────────┴─────────────────────────────────┘

IDEAL:
┌────────────────────────┬─────────────────────────────────┐
│       Requirement      │              Benefit            │
├────────────────────────┼─────────────────────────────────┤
│ ≥ 3 pre-periods        │ Can test parallel trends        │
│ Multiple post-periods  │ Can study dynamics              │
│ Balanced panel         │ No attrition concerns           │
│ Many units             │ Statistical power               │
└────────────────────────┴─────────────────────────────────┘
```

### Step 3: Validate Assumptions

For each assumption, run through this checklist:

```
ASSUMPTION: PARALLEL TRENDS
===========================

Q1: Can you test it?
├── YES (≥ 3 pre-periods) → Run event study
│   └── Check: β_k ≈ 0 for k < 0
└── NO (< 3 pre-periods) → ⚠️ WEAK
    └── Need: Theoretical justification

Q2: Why would trends be parallel?
├── Similar characteristics? → Show balance table
├── Same region/industry? → Include fixed effects
└── Random assignment? → Strongest case

Q3: What would violate it?
├── Differential shocks? → Check for coincident events
├── Selection into treatment? → Address with matching/IV
└── Mean reversion? → Check for it

TEST STRATEGY:
1. Visual: Plot Y over time for T and C
2. Statistical: Event study with pre-trend coefficients
3. Falsification: Fake treatment dates (placebo tests)
```

```
ASSUMPTION: NO ANTICIPATION
===========================

Q1: Could agents anticipate treatment?
├── Announced in advance? → Anticipation likely
├── Predictable eligibility? → Anticipation possible
└── Surprise policy? → Anticipation unlikely

Q2: How to test?
├── Event study: Check β_k for k < 0
├── Look for pre-treatment changes in behavior
└── Interview/survey about expectations

IF ANTICIPATION:
- Redefine "treatment" as announcement date
- Or use only post-implementation periods
```

```
ASSUMPTION: SUTVA (NO SPILLOVERS)
=================================

Q1: Could treatment affect control units?
├── Geographic proximity? → Migration, trade
├── Economic linkages? → Supply chains, competition
└── Information? → Learning, imitation

Q2: How to address?
├── Theoretical: Argue spillovers are small
├── Empirical: Drop units near treatment border
├── Design: Use "far" control group
└── Test: Check if outcomes in control near T change

EXAMPLE: Provincial merger
├── Spillover concern: Workers move from lost to kept capital
├── Test: Do kept-capital areas near border increase?
└── Fix: Compare to distant controls only
```

### Step 4: Check for Red Flags

```
DiD RED FLAGS
=============

┌─────────────────────────────────┬────────────────────────────┐
│            Red Flag             │        How to Address       │
├─────────────────────────────────┼────────────────────────────┤
│ Treatment affects everyone      │ Find intensity variation   │
│ No clear control group          │ Find comparison population │
│ Treatment timing unclear        │ Define sharp treatment date│
│ Treatment is endogenous         │ Use IV or find shock       │
│ Different pre-trends            │ Don't use DiD, or fix      │
│ Anticipation effects            │ Redefine treatment timing  │
│ Spillovers to control           │ Use distant controls       │
│ Attrition in panel              │ Test for selective exit    │
│ Simultaneous interventions      │ Control for them, or drop  │
│ Staggered adoption              │ Use Callaway-Sant'Anna     │
│ Heterogeneous effects           │ Use Sun-Abraham            │
└─────────────────────────────────┴────────────────────────────┘
```

### Step 5: Recommend Specification

Based on the setup, recommend:

```
SPECIFICATION RECOMMENDATION
============================

IF classic 2×2 (single treatment time, binary treatment):
├── Baseline: Y_it = β(Treat_i × Post_t) + γ_i + δ_t + X_it'Γ + ε_it
├── Event study: Y_it = Σ β_k(Treat_i × 1[t=k]) + γ_i + δ_t + ε_it
└── Clustering: Cluster at treatment assignment level

IF staggered adoption (different treatment times):
├── DO NOT USE: Standard TWFE (biased)
├── USE: Callaway-Sant'Anna (2021)
│   └── att_gt(Y, treat, time, control)
├── OR: Sun-Abraham (2021)
│   └── eventstudyinteract
└── OR: Borusyak et al. (2024)
    └── did_imputation

IF heterogeneous effects expected:
├── Report: Group-specific ATT
├── Test: Effect heterogeneity by characteristics
└── Don't pool if effects are meaningfully different
```

## OUTPUT FORMAT

```
DiD VALIDATION REPORT
=====================

RESEARCH QUESTION
- Question: [What is the effect of X on Y?]
- Treatment: [What is X?]
- Outcome: [What is Y?]
- Timing: [When does treatment occur?]

SETUP VERIFICATION
┌────────────────────┬─────────┬───────────────────────────────┐
│       Check        │ Status  │             Notes             │
├────────────────────┼─────────┼───────────────────────────────┤
│ Treatment defined  │ ✅/❌   │ [binary/sharp/observable]     │
│ Treatment group    │ ✅/❌   │ [N units, selection rule]     │
│ Control group      │ ✅/❌   │ [N units, comparable?]        │
│ Timing sharp       │ ✅/❌   │ [date, staggered?]            │
│ Outcome measurable │ ✅/❌   │ [level, frequency]            │
└────────────────────┴─────────┴───────────────────────────────┘

DATA STRUCTURE
- Type: [Panel / Repeated cross-section / Time series cross-section]
- Units: [N treatment, N control]
- Time periods: [T pre, T post]
- Total observations: [N × T]

ASSUMPTION CHECKS
┌─────────────────┬────────┬───────────────────────────────────┐
│   Assumption    │ Status │            Evidence               │
├─────────────────┼────────┼───────────────────────────────────┤
│ Parallel Trends │ ✅/❓/❌│ [Can test? Results of test?]      │
│ No Anticipation │ ✅/❓/❌│ [Announced? Pre-coefficients?]    │
│ SUTVA           │ ✅/❓/❌│ [Spillover mechanism? Buffer?]    │
│ Stable Compos.  │ ✅/❓/❌│ [Attrition? Entry/exit?]          │
└─────────────────┴────────┴───────────────────────────────────┘

RED FLAGS
┌─────────────────────────────┬──────────────────────────────┐
│           Flag              │        How to Address        │
├─────────────────────────────┼──────────────────────────────┤
│ [flag 1]                    │ [suggestion 1]               │
│ [flag 2]                    │ [suggestion 2]               │
└─────────────────────────────┴──────────────────────────────┘

RECOMMENDED SPECIFICATION

Baseline:
Y_it = β(Treat_i × Post_t) + γ_i + δ_t + X_it'Γ + ε_it

Event Study:
Y_it = Σ_{k≠-1} β_k(Treat_i × 1[t=k]) + γ_i + δ_t + ε_it

Where:
- γ_i = [unit] fixed effects
- δ_t = [time] fixed effects
- X_it = [controls]
- Cluster SE at [level]

IF staggered: Use Callaway-Sant'Anna (2021)

ROBUSTNESS CHECKS
1. Event study (parallel trends test)
2. Placebo treatment dates
3. Alternative control groups
4. Different bandwidths (drop transition periods)
5. Balance test (covariates pre-treatment)
6. [Study-specific checks]

MECHANISM TESTS
- Channel: [proposed mechanism]
- Test: [how to measure]
- Falsification: [what would disprove]

VERDICT
├── ✅ VALID: Proceed with DiD
├── ⚠️ CONDITIONAL: Address [issues] before proceeding
└── ❌ INVALID: DiD not appropriate

IF INVALID:
- Problem: [what]
- Alternative methods: [suggestions]

NEXT STEPS
1. [Action 1]
2. [Action 2]
3. [Action 3]
```

## EXAMPLES

### Example 1: Valid Classic DiD

**Input:**
"I want to study the effect of Vietnam's 2025 provincial merger on night lights. On June 12, 2025, 63 provinces merged into 34. Among the merged provinces, 31 lost their capital (treatment) and 21 kept their capital (control). I have monthly night lights data for 2024-2025."

**Output:**
```
DiD VALIDATION REPORT

RESEARCH QUESTION
- Question: What is the effect of losing provincial capital on economic activity?
- Treatment: Lost capital status (binary)
- Outcome: Night lights (monthly)
- Timing: June 12, 2025 (sharp)

SETUP VERIFICATION
┌────────────────────┬─────────┬─────────────────────────────────┐
│       Check        │ Status  │             Notes               │
├────────────────────┼─────────┼─────────────────────────────────┤
│ Treatment defined  │   ✅    │ Binary: lost vs kept capital    │
│ Treatment group    │   ✅    │ 31 provinces lost capital       │
│ Control group      │   ✅    │ 21 provinces kept capital       │
│ Timing sharp       │   ✅    │ Single date: June 12, 2025      │
│ Outcome measurable │   ✅    │ VIIRS monthly, 500m resolution  │
└────────────────────┴─────────┴─────────────────────────────────┘

DATA STRUCTURE
- Type: Panel (province-month)
- Units: 52 provinces (31 treatment, 21 control)
- Time periods: 6 pre (Jan-Jun 2024), 6 post (Jul-Dec 2025)
- Total observations: 52 × 18 = 936

ASSUMPTION CHECKS
┌─────────────────┬────────┬─────────────────────────────────────┐
│   Assumption    │ Status │              Evidence               │
├─────────────────┼────────┼─────────────────────────────────────┤
│ Parallel Trends │   ❓   │ Testable: Run event study           │
│ No Anticipation │   ⚠️   │ Merger announced months before      │
│ SUTVA           │   ⚠️   │ Workers may move between provinces  │
│ Stable Compos.  │   ✅   │ No entry/exit of provinces          │
└─────────────────┴────────┴─────────────────────────────────────┘

RED FLAGS
┌─────────────────────────────┬──────────────────────────────────┐
│           Flag              │         How to Address           │
├─────────────────────────────┼──────────────────────────────────┤
│ Selection: Why kept/lost?   │ Use within-merger fixed effects  │
│ Anticipation: Announced     │ Check pre-June 2025 effects      │
│ Spillovers: Worker movement │ Compare to distant controls      │
└─────────────────────────────┴──────────────────────────────────┘

RECOMMENDED SPECIFICATION

Baseline:
Y_ist = β(Lost_i × Post_t) + γ_s + δ_t + X_i'Γ + ε_ist

Where:
- γ_s = Merger (new province) fixed effects ← KEY for selection
- δ_t = Month-year fixed effects
- X_i = Pre-treatment controls (population, area)
- Cluster SE at old province level

Event Study:
Y_ist = Σ_{k≠-1} β_k(Lost_i × 1[t=k]) + γ_s + δ_t + ε_ist

ROBUSTNESS CHECKS
1. Event study (test parallel trends)
2. Within-merger comparison only
3. Drop transition period (June 2025)
4. Propensity score matching + DiD
5. Distance-based intensity (commune level)

VERDICT: ⚠️ CONDITIONAL

Address before proceeding:
1. Run event study to test parallel trends
2. Use within-merger FE to address selection
3. Test for anticipation effects
4. Consider commune-level analysis for more precision

NEXT STEPS
1. Download remaining night lights data
2. Create panel dataset at commune level
3. Run event study specification
4. Check pre-trend coefficients (β_k for k < 0)
```

### Example 2: Staggered DiD

**Input:**
"I want to study the effect of minimum wage increases on restaurant employment. Different states increased minimum wage at different times between 2010-2020."

**Output:**
```
DiD VALIDATION REPORT

RESEARCH QUESTION
- Question: What is the effect of minimum wage on restaurant employment?
- Treatment: Minimum wage increase
- Outcome: Restaurant employment
- Timing: Staggered (2010-2020)

SETUP VERIFICATION
┌────────────────────┬─────────┬─────────────────────────────────┐
│       Check        │ Status  │             Notes               │
├────────────────────┼─────────┼─────────────────────────────────┤
│ Treatment defined  │   ⚠️   │ Continuous: size of increase    │
│ Treatment group    │   ✅    │ States that increased           │
│ Control group      │   ✅    │ States that didn't (in that year)│
│ Timing sharp       │   ❌   │ STAGGERED: Different dates      │
│ Outcome measurable │   ✅    │ QCEW/BLS employment data        │
└────────────────────┴─────────┴─────────────────────────────────┘

⚠️ CRITICAL ISSUE: Staggered Adoption

PROBLEM:
Standard TWFE is biased with staggered adoption when:
1. Treatment effects are heterogeneous (likely here)
2. Already-treated units serve as controls

SOLUTION: Use modern DiD estimator

RECOMMENDED SPECIFICATION

DO NOT USE:
Y_it = β(Treat_it) + γ_i + δ_t + ε_it
(Standard TWFE is biased)

USE INSTEAD:

Option 1: Callaway-Sant'Anna (2021)
- Estimates ATT for each group-time combination
- Aggregates cleanly
- Code: did package in R/Stata

Option 2: Sun-Abraham (2021)
- Cohort-specific ATT
- Good for event study plots
- Code: eventstudyinteract in Stata

Option 3: Borusyak et al. (2024)
- Imputation approach
- Efficient with many periods
- Code: did_imputation

VERDICT: ⚠️ CONDITIONAL

Valid DiD design, but MUST use staggered DiD methods.
Do NOT use standard TWFE.

NEXT STEPS
1. Choose estimator (recommend Callaway-Sant'Anna)
2. Define treatment groups by adoption year
3. Estimate group-time ATTs
4. Aggregate to overall ATT
5. Run event study for dynamics
```

### Example 3: Invalid DiD

**Input:**
"I want to study the effect of COVID on economic growth. COVID affected all countries in 2020."

**Output:**
```
DiD VALIDATION REPORT

RESEARCH QUESTION
- Question: What is the effect of COVID on economic growth?
- Treatment: COVID pandemic
- Outcome: GDP growth
- Timing: 2020 (global)

SETUP VERIFICATION
┌────────────────────┬─────────┬─────────────────────────────────┐
│       Check        │ Status  │             Notes               │
├────────────────────┼─────────┼─────────────────────────────────┤
│ Treatment defined  │   ✅    │ COVID pandemic                  │
│ Treatment group    │   ❌   │ ALL countries affected          │
│ Control group      │   ❌   │ NO control group exists         │
│ Timing sharp       │   ✅    │ Early 2020                      │
│ Outcome measurable │   ✅    │ GDP data available              │
└────────────────────┴─────────┴─────────────────────────────────┘

VERDICT: ❌ INVALID

FATAL PROBLEM: No control group

DiD requires comparison between treated and untreated units.
COVID affected everyone simultaneously → no counterfactual.

ALTERNATIVE APPROACHES:

1. Cross-country variation
   - Compare countries with different COVID intensity
   - Issue: Intensity is endogenous (worse institutions → worse COVID)
   - Need: Instrument for COVID intensity (distance to Wuhan?)

2. Within-country variation
   - Compare regions with different lockdown severity
   - Compare sectors (essential vs non-essential)
   - Issue: Selection into strictness

3. Synthetic control
   - Compare affected country to synthetic counterfactual
   - Use pre-COVID trends to construct synthetic control
   - Works for single treated unit

4. Event study without control
   - Compare pre-COVID to post-COVID
   - Issue: Can't separate COVID from other 2020 shocks
   - Very weak identification

RECOMMENDATION:
Either find valid control (variation in treatment) OR
change research question to something with identification.
```

## SELF-CHECK

Before outputting:
- [ ] Did I verify treatment definition?
- [ ] Did I verify treatment/control groups?
- [ ] Did I verify timing?
- [ ] Did I check all assumptions?
- [ ] Did I warn about red flags?
- [ ] Did I recommend appropriate specification?
- [ ] Did I provide next steps?

If any unchecked → INCOMPLETE

## REFERENCES

### Foundational Papers
- Card, D., & Krueger, A. B. (1994). "Minimum Wages and Employment: A Case Study of the Fast-Food Industry in New Jersey and Pennsylvania." *American Economic Review*, 84(4), 772-793. [Classic DiD application]
- Ashenfelter, O., & Card, D. (1985). "Using the Longitudinal Structure of Earnings to Estimate the Effect of Training Programs." *Review of Economics and Statistics*, 67(4), 648-660. [DiD methodology]

### Modern DiD (TWFE Problem)
- Goodman-Bacon, A. (2021). "Difference-in-Differences with Variation in Treatment Timing." *Journal of Econometrics*, 225(2), 254-277. [Decomposition of TWFE bias]
- Callaway, B., & Sant'Anna, P. H. (2021). "Difference-in-Differences with Multiple Time Periods." *Journal of Econometrics*, 225(2), 200-230. [Staggered DiD solution]
- Sun, L., & Abraham, S. (2021). "Estimating Dynamic Treatment Effects in Event Studies with Heterogeneous Treatment Effects." *Journal of Econometrics*, 225(2), 175-199. [Event study with heterogeneity]
- de Chaisemartin, C., & D'Haultfoeuille, X. (2020). "Two-Way Fixed Effects Estimators with Heterogeneous Treatment Effects." *American Economic Review*, 110(9), 2964-2996. [Alternative TWFE diagnostic]
- Borusyak, K., Jaravel, X., & Spiess, J. (2024). "Revisiting Event Study Designs: Robust and Efficient Estimation." *Review of Economic Studies*, 91(6), 3253-3285. [Imputation approach]

### Practical Guides
- Angrist, J. D., & Pischke, J. S. (2009). *Mostly Harmless Econometrics*. Princeton University Press. Chapters 5 & 6.
- Cunningham, S. (2021). *Causal Inference: The Mixtape*. Yale University Press. Chapter 9.
- Roth, J., et al. (2023). "What's Trending in Difference-in-Differences? A Synthesis of the Recent Econometrics Literature." *Journal of Econometrics*. [Review of modern methods]

### Software
- `did` package (R/Stata): Callaway-Sant'Anna estimator
- `csdid` (Stata): Callaway-Sant'Anna
- `eventstudyinteract` (Stata): Sun-Abraham
- `did_imputation` (Stata/R): Borusyak et al.
- `fixest` (R): Fast TWFE with robust SE

---
name: rdd-validator
description: Validate regression discontinuity design research. Use when user mentions RDD, regression discontinuity, cutoff, threshold, running variable, assignment variable, or proposes comparing units above/below a threshold.
user-invocable: true
---


# Regression Discontinuity Design Validator

## ROLE

You are an RDD specialist who validates regression discontinuity research designs. RDD is considered the "closest to randomization" among quasi-experimental methods because treatment is determined by a sharp rule at a known cutoff.

## KNOWLEDGE

### The RDD Setup

**Core Idea:** Treatment is assigned based on whether a running variable $R_i$ crosses a cutoff $c$.

$$D_i = \mathbf{1}[R_i \geq c]$$

**Identification:** Compare units just above and just below the cutoff. These units are essentially identical except for treatment status.

```
         │
    Y    │     ○ ○
         │    ○
         │   ○  ● ●
         │  ○   ● ●
         │ ○    ●
         │○     ●
         └───────────────── R
              c ↑
         cutoff
```

### Sharp vs Fuzzy RDD

| Type | Definition | Estimation |
|------|------------|------------|
| **Sharp** | $P(D=1 \mid R \geq c) = 1$ | Compare Y above/below cutoff |
| **Fuzzy** | $P(D=1 \mid R \geq c) < 1$ | Use cutoff as IV for treatment |

**Sharp RDD:**

$$\tau_{SRD} = \lim_{r \downarrow c} E[Y_i \mid R_i = r] - \lim_{r \uparrow c} E[Y_i \mid R_i = r]$$

**Fuzzy RDD (IV setup):**

$$\tau_{FRD} = \frac{\lim_{r \downarrow c} E[Y_i \mid R_i = r] - \lim_{r \uparrow c} E[Y_i \mid R_i = r]}{\lim_{r \downarrow c} E[D_i \mid R_i = r] - \lim_{r \uparrow c} E[D_i \mid R_i = r]}$$

### Estimation Methods

**1. Local Linear Regression (Recommended)**

$$\min_{\alpha, \beta, \tau} \sum_{i=1}^{n} \left( Y_i - \alpha - \tau D_i - \beta (R_i - c) - \gamma D_i (R_i - c) \right)^2 K\left(\frac{R_i - c}{h}\right)$$

Where:
- $K(\cdot)$ = Kernel function (triangular recommended)
- $h$ = Bandwidth

**2. Polynomial Regression (NOT Recommended)**

$$Y_i = \alpha + \tau D_i + \sum_{p=1}^{P} \beta_p (R_i - c)^p + \sum_{p=1}^{P} \gamma_p D_i (R_i - c)^p + \varepsilon_i$$

⚠️ Higher-order polynomials can be misleading (Gelman & Imbens, 2019)

### Bandwidth Selection

| Method | Description | When to Use |
|--------|-------------|-------------|
| **IK (2012)** | Imbens-Kalyanaraman optimal | Default, robust |
| **CCT (2014)** | Calonico-Cattaneo-Titiunik | Bias-corrected, recommended |
| **rddensity** | Test for manipulation | Always check |

**Trade-off:**
- Larger bandwidth → More observations, more bias
- Smaller bandwidth → Less bias, more variance

### Key Assumptions

| Assumption | Definition | Test |
|------------|------------|------|
| **Continuity of E[Y(0)]** | Potential outcome continuous at cutoff | Plot, covariate balance |
| **No manipulation** | Units can't precisely control R | McCrary test, rddensity |
| **SUTVA** | No interference between units | Theoretical |
| **No other discontinuities** | No other policies at same cutoff | Check for coincident policies |
| **Smoothness** | Relationship between Y and R is smooth | Visual inspection, polynomial fit |

### Falsification Tests

```
RDD FALSIFICATION CHECKLIST
===========================

1. COVARIATE BALANCE AT CUTOFF
   - Run RDD on pre-determined covariates (age, gender, etc.)
   - Should find NO discontinuity
   - If discontinuity exists → sorting/manipulation

2. PLACEBO CUTOFFS
   - Run RDD at fake cutoffs (e.g., c ± 1sd)
   - Should find NO effect
   - If effect exists → functional form misspecification

3. MANIPULATION TEST
   - McCrary (2008) density test
   - rddensity (Cattaneo et al., 2020)
   - Check for bunching just above/below cutoff

4. BANDWIDTH SENSITIVITY
   - Re-estimate at different bandwidths
   - Effect should be robust to reasonable bandwidth choices
   - Plot: Effect vs Bandwidth

5. DONUT RDD
   - Drop observations very close to cutoff
   - Effect should persist
   - If disappears → manipulation
```

## WORKFLOW

### Step 1: Verify RDD Setup

```
RDD SETUP VERIFICATION
======================

1. RUNNING VARIABLE (R)
   Q: What determines treatment assignment?
   - What is the running variable? (test score, age, income, etc.)
   - How is it measured?
   - At what level? (individual, firm, region)

   ⚠️ RED FLAG: Running variable not clearly defined
   ⚠️ RED FLAG: Running variable measured with error

2. CUTOFF (c)
   Q: What is the treatment threshold?
   - What is the exact cutoff value?
   - Is it sharp (one value) or fuzzy (range)?
   - Is it known to agents in advance?

   ⚠️ RED FLAG: Cutoff varies over time or space
   ⚠️ RED FLAG: Cutoff is endogenously chosen

3. TREATMENT (D)
   Q: What happens at the cutoff?
   - Does crossing cutoff guarantee treatment? (sharp)
   - Or just increase probability? (fuzzy)
   - Is treatment observable?

   ⚠️ RED FLAG: Treatment is multi-valued
   ⚠️ RED FLAG: Treatment probability changes gradually

4. OUTCOME (Y)
   Q: What is the outcome variable?
   - How is it measured?
   - Available on both sides of cutoff?
   - At what level?

   ⚠️ RED FLAG: Outcome definition changes at cutoff
```

### Step 2: Check for Manipulation

```
MANIPULATION CHECK
==================

Q1: Can agents manipulate the running variable?
├── If R is test score → Can students retake? Study harder?
├── If R is income → Can firms shift income across years?
├── If R is age → Cannot manipulate (good!)
└── If R is pollution level → Firms might manipulate

Q2: Is manipulation detectable?
├── Run McCrary density test
│   └── H0: Density of R is continuous at cutoff
├── Run rddensity (Cattaneo et al.)
│   └── More robust than McCrary
└── Visual: Histogram of R near cutoff

Q3: If manipulation exists, what to do?
├── Donut RDD: Drop observations within δ of cutoff
├── Fuzzy RDD: Use cutoff as IV
├── Find alternative running variable
└── Abandon RDD

CODE (Stata):
rddensity R, c(cutoff)
rdrobust Y R, c(cutoff)

CODE (R):
rddensity::rddensity(R, c = cutoff)
rdrobust::rdrobust(Y, R, c = cutoff)
```

### Step 3: Assess Identification

```
IDENTIFICATION CHECKLIST
========================

┌────────────────────────┬─────────┬─────────────────────────────┐
│       Requirement      │ Status  │            Notes            │
├────────────────────────┼─────────┼─────────────────────────────┤
│ Sharp cutoff exists    │ ✅/❌   │ [value, source]             │
│ Running var observable │ ✅/❌   │ [measurement]               │
│ No manipulation        │ ✅/❌   │ [test result]               │
│ Observations near c    │ ✅/❌   │ [N within bandwidth]        │
│ Outcome on both sides  │ ✅/❌   │ [data coverage]             │
│ No other discontinuities│ ✅/❌  │ [check policies]            │
└────────────────────────┴─────────┴─────────────────────────────┘

CRITICAL: Need sufficient observations near cutoff
Rule of thumb: ≥ 100 observations within optimal bandwidth
```

### Step 4: Visual Analysis

```
RDD VISUALIZATION
=================

REQUIRED PLOTS:

1. SCATTER PLOT + FIT
   - Plot Y vs R
   - Add separate fits left and right of cutoff
   - Show discontinuity visually

2. BINS CATTER
   - Bin R into small intervals
   - Plot mean Y within each bin
   - More informative than scatter with many points

3. DENSITY PLOT
   - Histogram/density of R
   - Check for discontinuity at cutoff (manipulation)

4. COVARIATE PLOTS
   - Plot X vs R for each covariate
   - Should show NO discontinuity

STATA CODE:
rdplot Y R, c(cutoff) binselect(es)
rddensity R, c(cutoff)

R CODE:
rdrobust::rdplot(Y, R, c = cutoff)
rddensity::rddensity(R, c = cutoff)
```

### Step 5: Estimation

```
RDD ESTIMATION
==============

RECOMMENDED: Local linear regression with robust bias correction

STATA:
* Main estimate
rdrobust Y R, c(cutoff) kernel(triangular)

* With covariates
rdrobust Y R, c(cutoff) covars(X1 X2 X3)

* Fuzzy RDD
rdrobust Y R, c(cutoff) fuzzy(D)

R:
# Main estimate
rdrobust::rdrobust(Y, R, c = cutoff)

# With covariates
rdrobust::rdrobust(Y, R, c = cutoff, covs = X)

# Fuzzy RDD
rdrobust::rdrobust(Y, R, c = cutoff, fuzzy = D)

OUTPUT INTERPRETATION:
- Conventional: Standard local linear estimate
- Bias-corrected: Robust to bias from bandwidth selection
- Robust: Robust SE (RECOMMENDED)
```

### Step 6: Robustness Checks

```
ROBUSTNESS CHECKLIST
====================

1. BANDWIDTH SENSITIVITY
   - Re-estimate at h/2, h, 2h
   - Effect should be similar

2. PLACEBO CUTOFFS
   - Test at cutoff ± 1sd, ± 2sd
   - Should find no effect

3. COVARIATE BALANCE
   - Test discontinuity in pre-determined covariates
   - Should find no effect

4. DONUT RDD
   - Drop observations within 0.01, 0.05 of cutoff
   - Effect should persist

5. KERNEL CHOICE
   - Triangular (recommended), Epanechnikov, Uniform
   - Effect should be robust

6. POLYNOMIAL ORDER
   - Local linear (recommended), local quadratic
   - Compare results

7. BINS CATTER SENSITIVITY
   - Different bin sizes
   - Effect should be visible visually
```

## OUTPUT FORMAT

```
RDD VALIDATION REPORT
=====================

RESEARCH QUESTION
- Question: [What is the effect of X on Y?]
- Treatment: [What happens at cutoff?]
- Outcome: [Y variable]
- Running Variable: [R variable]
- Cutoff: [value]

SETUP VERIFICATION
┌────────────────────────┬─────────┬─────────────────────────────┐
│       Check            │ Status  │            Notes            │
├────────────────────────┼─────────┼─────────────────────────────┤
│ Running variable clear │ ✅/❌   │ [what is R]                 │
│ Cutoff sharp           │ ✅/❌   │ [value]                     │
│ Treatment observable   │ ✅/❌   │ [sharp/fuzzy]               │
│ Outcome measured       │ ✅/❌   │ [level, source]             │
│ Sufficient obs near c  │ ✅/❌   │ [N within bandwidth]        │
└────────────────────────┴─────────┴─────────────────────────────┘

MANIPULATION TEST
- Test: [McCrary / rddensity]
- Result: [p-value]
- Conclusion: [Evidence of manipulation? Y/N]

VISUAL EVIDENCE
- Discontinuity visible? [Y/N]
- [Attach or describe plot]

IDENTIFICATION
- Type: [Sharp / Fuzzy]
- Assumptions:
  ├── Continuity of E[Y(0)]: [argue]
  ├── No manipulation: [test result]
  └── No other discontinuities: [check]

ESTIMATION
Method: Local linear regression with robust SE
Bandwidth: [IK / CCT, value]
Kernel: Triangular

Result:
┌─────────────┬─────────┬─────────┬─────────┐
│   Estimate  │  Coef   │   SE    │  95% CI │
├─────────────┼─────────┼─────────┼─────────┤
│ Conventional│ [β]     │ [SE]    │ [CI]    │
│ Robust      │ [β]     │ [SE]    │ [CI]    │
└─────────────┴─────────┴─────────┴─────────┘

ROBUSTNESS
┌─────────────────────┬────────┬────────────────┐
│       Check         │ Result │    Conclusion  │
├─────────────────────┼────────┼────────────────┤
│ Bandwidth h/2       │ [β]    │ [similar/diff] │
│ Bandwidth 2h        │ [β]    │ [similar/diff] │
│ Placebo at c+sd     │ [β]    │ [null/effect]  │
│ Covariate balance   │ [p]    │ [balanced/no]  │
│ Donut RDD           │ [β]    │ [robust/fragile]│
└─────────────────────┴────────┴────────────────┘

VERDICT
├── ✅ VALID: Proceed with RDD
├── ⚠️ CONDITIONAL: Address [issues]
└── ❌ INVALID: RDD not appropriate

IF INVALID:
- Problem: [what]
- Alternative methods: [suggestions]

NEXT STEPS
1. [Action 1]
2. [Action 2]
```

## EXAMPLES

### Example 1: Valid Sharp RDD

**Input:**
"I want to study the effect of winning a scholarship on college attendance. Students with test scores ≥ 80 get the scholarship."

**Output:**
```
RDD VALIDATION REPORT

RESEARCH QUESTION
- Question: What is the effect of scholarship on college attendance?
- Treatment: Scholarship (binary)
- Outcome: College attendance (binary)
- Running Variable: Test score
- Cutoff: 80

SETUP VERIFICATION
┌────────────────────────┬─────────┬─────────────────────────────┐
│       Check            │ Status  │            Notes            │
├────────────────────────┼─────────┼─────────────────────────────┤
│ Running variable clear │   ✅    │ Test score (0-100)          │
│ Cutoff sharp           │   ✅    │ 80, known in advance        │
│ Treatment observable   │   ✅    │ Scholarship receipt         │
│ Outcome measured       │   ✅    │ Enrollment records          │
│ Sufficient obs near c  │   ❓    │ Check: How many scored 75-85?│
└────────────────────────┴─────────┴─────────────────────────────┘

MANIPULATION TEST
- Concern: Students might study harder to get ≥ 80
- Test: rddensity on test scores
- Look for: Bunching just above 80

IF NO MANIPULATION:
✅ Sharp RDD is valid

RECOMMENDED ESTIMATION:
rdrobust college scholarship_score, c(80)

KEY CHECKS:
1. Density test for manipulation
2. Covariate balance at 80 (family income, etc.)
3. Placebo cutoffs at 70, 90
4. Bandwidth sensitivity

VERDICT: ✅ VALID (pending manipulation test)

NEXT STEPS:
1. Get test score data
2. Run rddensity to check manipulation
3. Estimate with rdrobust
4. Run robustness checks
```

### Example 2: Fuzzy RDD

**Input:**
"I want to study the effect of class size on student achievement. Schools with enrollment ≥ 100 must reduce class size to 25, but compliance is imperfect."

**Output:**
```
RDD VALIDATION REPORT

RESEARCH QUESTION
- Question: What is the effect of class size on achievement?
- Treatment: Small class (binary)
- Outcome: Test scores
- Running Variable: School enrollment
- Cutoff: 100 students

SETUP VERIFICATION
┌────────────────────────┬─────────┬─────────────────────────────┐
│       Check            │ Status  │            Notes            │
├────────────────────────┼─────────┼─────────────────────────────┤
│ Running variable clear │   ✅    │ Enrollment (observable)     │
│ Cutoff sharp           │   ✅    │ 100 students                │
│ Treatment observable   │   ⚠️    │ Compliance imperfect        │
│ Outcome measured       │   ✅    │ Test scores                 │
│ Sufficient obs near c  │   ❓    │ Check data                  │
└────────────────────────┴─────────┴─────────────────────────────┘

IDENTIFICATION
- Type: FUZZY RDD
- Reason: Not all schools above 100 actually reduce class size

ESTIMATION:
Use cutoff as instrument for class size
rdrobust achievement enrollment, c(100) fuzzy(small_class)

FIRST STAGE:
P(small_class | enrollment ≥ 100) should increase
Check: First stage F-stat > 10

LATE INTERPRETATION:
Effect is Local Average Treatment Effect (LATE)
- For compliers: Schools that reduce class size because of rule
- NOT for always-takers or never-takers

VERDICT: ✅ VALID (fuzzy RDD)

NEXT STEPS:
1. Check first stage strength
2. Estimate with fuzzy rdrobust
3. Run manipulation test
```

### Example 3: Invalid RDD (Manipulation)

**Input:**
"I want to study the effect of poverty alleviation programs. Households with income < $1000/month get benefits. Households can shift income between years."

**Output:**
```
RDD VALIDATION REPORT

RESEARCH QUESTION
- Question: What is the effect of poverty program on consumption?
- Treatment: Program eligibility
- Outcome: Household consumption
- Running Variable: Monthly income
- Cutoff: $1000

MANIPULATION CHECK
- Concern: HIGH - Households can shift income to qualify
- Test: Look for bunching just below $1000
- Expected: Many households with income just under cutoff

IF MANIPULATION DETECTED:
❌ RDD is INVALID

REASON:
- Units sort around cutoff based on treatment
- No longer comparing similar units
- Continuity assumption violated

ALTERNATIVES:

1. USE DIFFERENT CUTOFF
   - Find a cutoff agents can't manipulate
   - E.g., eligibility based on age (cannot manipulate)

2. USE DIFFERENT METHOD
   - Instrumental variables with exogenous instrument
   - Regression kink design (if kink in benefits)

3. DONUT RDD
   - Drop observations very close to cutoff
   - Compare $900-950 vs $1050-1100
   - May still be biased if manipulation is widespread

VERDICT: ❌ INVALID due to manipulation

RECOMMENDATION:
Find alternative identification strategy or use non-manipulable running variable.
```

## SELF-CHECK

Before outputting:
- [ ] Did I identify running variable and cutoff?
- [ ] Did I check for manipulation?
- [ ] Did I verify sufficient observations near cutoff?
- [ ] Did I recommend appropriate estimation method?
- [ ] Did I list falsification tests?
- [ ] Did I provide next steps?

## REFERENCES

### Foundational Papers
- Thistlethwaite, D. L., & Campbell, D. T. (1960). "Regression-Discontinuity Analysis: An Alternative to the Ex Post Facto Experiment." *Journal of Educational Psychology*, 51(6), 309-317. [Original RDD]
- Hahn, J., Todd, P., & Van der Klaauw, W. (2001). "Identification and Estimation of Treatment Effects with a Regression-Discontinuity Design." *Econometrica*, 69(1), 201-209. [Formal identification]

### Modern Methods
- Imbens, G., & Kalyanaraman, K. (2012). "Optimal Bandwidth Choice for the Regression Discontinuity Estimator." *Review of Economic Studies*, 79(3), 933-959. [Optimal bandwidth]
- Calonico, S., Cattaneo, M. D., & Titiunik, R. (2014). "Robust Nonparametric Confidence Intervals for Regression-Discontinuity Designs." *Econometrica*, 82(6), 2295-2326. [Robust inference]
- Cattaneo, M. D., Jansson, M., & Ma, X. (2020). "Simple Local Polynomial Density Estimators." *Journal of the American Statistical Association*, 115(531), 1449-1455. [rddensity]

### Manipulation Tests
- McCrary, J. (2008). "Manipulation of the Running Variable in the Regression Discontinuity Design: A Density Test." *Journal of Econometrics*, 142(2), 698-714. [Density test]
- Cattaneo, M. D., et al. (2020). "Testing for Manipulation in Regression Discontinuity Designs." [rddensity]

### Practical Guides
- Lee, D. S., & Lemieux, T. (2010). "Regression Discontinuity Designs in Economics." *Journal of Economic Literature*, 48(2), 281-355. [Comprehensive review]
- Cattaneo, M. D., Idrobo, N., & Titiunik, R. (2020). *A Practical Introduction to Regression Discontinuity Designs*. Cambridge University Press. [Best practical guide]

### Warnings
- Gelman, A., & Imbens, G. (2019). "Why High-Order Polynomials Should Not Be Used in Regression Discontinuity Designs." *Journal of Business & Economic Statistics*, 37(3), 447-456. [Avoid high-order polynomials]

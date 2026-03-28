# Economics Research Skills for AI Assistants

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-blue)](https://claude.ai/code)

**Professional-grade causal inference skills for AI assistants. Designed for economists, by economists.**

---

## What Is This?

A collection of **8 specialized skills** that transform AI assistants into expert research methodology consultants. Each skill contains:

- ✅ Complete theoretical knowledge
- ✅ Step-by-step workflows
- ✅ Validation checklists
- ✅ Code templates
- ✅ Real examples with solutions
- ✅ Academic references

**Perfect for:** PhD students, faculty, researchers, and anyone doing causal inference in economics.

---

## Quick Start (2 minutes)

### Option 1: Claude Code (Recommended)

```bash
# Clone the repository
git clone https://github.com/ninhnguyen/econ-research-skills.git
cd econ-research-skills

# Install skills (copies to Claude Code skills folder)
cp -r skills/* ~/.claude/skills/

# Restart Claude Code - skills load automatically!
```

### Option 2: Any AI (ChatGPT, Claude Web, etc.)

1. Open `skills/research-assistant.md`
2. Copy entire contents
3. Paste into AI conversation
4. Ask your research question

### Option 3: Try Online

Visit: **[Economics Research Assistant](https://anninh-blog.vercel.app/projects/research-assistant)** for the live demo.

---

## Skills Overview

### Master Orchestrator

| Skill | Purpose | When to Use |
|-------|---------|-------------|
| `research-assistant` | Routes to appropriate specialist | Any research question |

### Causal Inference Methods

| Skill | Method | Key Assumption | Best For |
|-------|--------|----------------|----------|
| `did-validator` | Difference-in-Differences | Parallel trends | Policy evaluations |
| `rdd-validator` | Regression Discontinuity | No manipulation | Threshold-based policies |
| `iv-validator` | Instrumental Variables | Exclusion restriction | Endogenous treatments |
| `event-study-validator` | Event Study / Natural Experiment | Exogenous shock | Sharp timing events |

### Research Components

| Skill | Purpose | Always Use |
|-------|---------|------------|
| `mechanism-designer` | Design testable mechanisms | After finding effects |
| `data-auditor` | Verify data availability | Before any design |
| `red-flag-detector` | Catch common mistakes | Always (background) |

---

## Usage Examples

### Example 1: "Is my DiD design valid?"

```
User: I want to study the effect of Vietnam's provincial merger on
      night lights. 63 provinces merged into 34 on June 12, 2025.
      31 lost capital (treatment), 21 kept capital (control).

Claude: [Activates research-assistant → did-validator]

       ✅ CLASSIFICATION: Difference-in-Differences

       DATA CHECK:
       - Outcome: Night lights ✅ (VIIRS available)
       - Treatment: Lost capital ✅ (binary, observable)
       - Timing: June 12, 2025 ✅ (sharp)

       ASSUMPTIONS:
       - Parallel trends: Testable (run event study)
       - No anticipation: Check pre-June 2025 effects
       - SUTVA: Warning - workers may move

       RED FLAGS:
       ⚠️ Selection: Why was capital kept/lost?
          → Use within-merger fixed effects

       SPECIFICATION:
       Y_ist = β(Lost_i × Post_t) + γ_s + δ_t + ε_it
       where γ_s = merger fixed effects

       NEXT STEPS:
       1. Run event study (test parallel trends)
       2. Use within-merger FE
       3. Check for anticipation effects
```

### Example 2: "Can I use RDD here?"

```
User: Students with test scores ≥ 80 get scholarships.
      Can I use RDD to study the effect on college attendance?

Claude: [Activates rdd-validator]

       ✅ VALID RDD SETUP

       RUNNING VARIABLE: Test score (0-100)
       CUTOFF: 80 (sharp)
       TREATMENT: Scholarship receipt

       ⚠️ MANIPULATION CHECK REQUIRED:
       Students might study harder to get ≥ 80

       TEST: Run rddensity test
       H0: Density of scores continuous at 80

       IF MANIPULATION DETECTED:
       - Donut RDD: Drop scores 78-82
       - Or: Find alternative identification

       ESTIMATION:
       ✅ USE: Local linear regression (rdrobust)
       ❌ DON'T: High-order polynomial

       CODE (Stata):
       rddensity score, c(80)
       rdrobust attendance score, c(80)
```

### Example 3: "Is my instrument valid?"

```
User: I'm using distance to college as instrument for education.
      First-stage F-stat is 4.5.

Claude: [Activates iv-validator + red-flag-detector]

       🚨 RED FLAG: WEAK INSTRUMENT

       F = 4.5 < 10 → Instrument is weak

       CONSEQUENCES:
       - 2SLS biased toward OLS
       - Confidence intervals unreliable

       FIXES:
       1. Add controls to strengthen first stage
       2. Use weak-instrument robust methods:
          - Anderson-Rubin test
          - LIML instead of 2SLS
       3. Find stronger instrument

       ⚠️ EXCLUSION CHECK:
       Distance may affect wages through channels OTHER than education:
       - Access to jobs
       - Social networks
       - Local labor markets

       Need stronger argument for exclusion!
```

---

## Skill Architecture

```
research-assistant.md
         │
         ├─→ data-auditor.md
         │   "Is data available?"
         │
         ├─→ [Method Validator]
         │   ├─→ did-validator.md
         │   ├─→ rdd-validator.md
         │   ├─→ iv-validator.md
         │   └─→ event-study-validator.md
         │
         ├─→ mechanism-designer.md
         │   "How does X affect Y?"
         │
         └─→ red-flag-detector.md
             "What could go wrong?"
```

---

## Method Selection Guide

```
                Can you randomize?
                       │
          ┌────────────┴────────────┐
         YES                        NO
          │                          │
      ┌───▼───┐           ┌──────────▼──────────┐
      │  RCT  │           │  Is there a cutoff? │
      └───────┘           └──────────┬──────────┘
                                    │
                      ┌─────────────┴─────────────┐
                     YES                          NO
                      │                           │
               ┌──────▼──────┐         ┌──────────▼──────────┐
               │     RDD     │         │ Before/After + T/C? │
               └─────────────┘         └──────────┬──────────┘
                                                  │
                                    ┌─────────────┴─────────────┐
                                   YES                          NO
                                    │                           │
                             ┌──────▼──────┐          ┌─────────▼─────────┐
                             │     DiD     │          │ Have instrument?  │
                             └─────────────┘          └─────────┬─────────┘
                                                                │
                                                  ┌─────────────┴─────────────┐
                                                 YES                          NO
                                                  │                           │
                                           ┌──────▼──────┐            ┌───────▼───────┐
                                           │     IV      │            │  Observational │
                                           └─────────────┘            │    (weaker)    │
                                                                      └───────────────┘
```

---

## Installation Details

### Prerequisites

- Claude Code installed, OR
- Access to ChatGPT/Claude web, OR
- Any AI assistant

### Full Installation (Claude Code)

```bash
# 1. Clone repository
git clone https://github.com/ninhnguyen/econ-research-skills.git
cd econ-research-skills

# 2. Backup existing skills (if any)
mv ~/.claude/skills ~/.claude/skills.backup 2>/dev/null || true

# 3. Install skills
mkdir -p ~/.claude/skills
cp -r skills/* ~/.claude/skills/

# 4. Verify installation
ls -R ~/.claude/skills/
# Should show:
# ~/.claude/skills/research-assistant.md
# ~/.claude/skills/causal-inference/did-validator.md
# ~/.claude/skills/causal-inference/rdd-validator.md
# ...etc

# 5. Restart Claude Code
# Skills will load automatically on next conversation
```

### Using with ChatGPT or Claude Web

```bash
# Copy a skill to clipboard
cat skills/research-assistant.md | pbcopy  # Mac
cat skills/research-assistant.md | xclip   # Linux

# Then paste into your AI conversation
```

---

## For Different Users

### PhD Students

**Start here:** `research-assistant.md` + `data-auditor.md`

```
You: "I want to study [X] but I'm not sure what method to use"

Skill: Asks clarifying questions → Recommends method →
       Validates assumptions → Provides specification
```

**Learning path:**
1. Read `did-validator.md` (most common method)
2. Try example problems
3. Read references cited in skill

### Faculty / Advisors

**Use case:** Quickly validate student research designs

```
You: [Paste student's research design]

Skill: Identifies problems → Suggests fixes →
       Rates severity → Provides teaching points
```

### Active Researchers

**Use case:** Pre-submission validation

```
You: "Check my IV design: [describe instrument]"

Skill: Tests all assumptions → Identifies weaknesses →
       Suggests robustness checks → Cites relevant papers
```

---

## Common Problems Solved

| Problem | Skill Solution |
|---------|---------------|
| "I don't know what method to use" | research-assistant routes to correct method |
| "Is my data sufficient?" | data-auditor checks structure, quality |
| "Parallel trends look OK" | did-validator makes you TEST statistically |
| "My instrument seems reasonable" | iv-validator forces explicit exclusion argument |
| "Students might manipulate scores" | rdd-validator provides manipulation tests |
| "Effect is huge (500%)" | red-flag-detector flags implausible results |
| "How does X affect Y?" | mechanism-designer creates testable channels |

---

## Real Research Workflow

### Before Data Collection

```
1. /research-assistant "I want to study [X] effect on [Y]"
   → Get method recommendation

2. /data-auditor "What data do I need for [method]?"
   → Verify data availability BEFORE investing time

3. /[method]-validator "Check my design: [details]"
   → Validate assumptions, identify problems
```

### During Analysis

```
4. /[method]-validator "My results show [X]"
   → Check if results are plausible
   → Get robustness check suggestions

5. /mechanism-designer "How might X affect Y?"
   → Design mechanism tests

6. /red-flag-detector "Any problems with [design]?"
   → Final check before writing
```

### Before Submission

```
7. Run through ALL validator checklists
8. Address every red flag
9. Document robustness checks
```

---

## Advanced Features

### Combining Skills

```
User: "I have an IV with potential manipulation at cutoff"

Claude: [Combines iv-validator + rdd-validator]
       - Treat as fuzzy RDD with IV interpretation
       - Test for manipulation first
       - If manipulation exists, use cutoff as IV
```

### Custom Skill Creation

```bash
# Create your own skill
nano ~/.claude/skills/my-field-specialty.md
```

```markdown
---
name: my-field-specialty
description: Specialized knowledge for [my field]
trigger: "[field-specific keywords]"
---

# My Field Specialty

[Your content here - follow existing skill format]
```

---

## Troubleshooting

### Skills Not Loading

```bash
# Check skills are in right place
ls ~/.claude/skills/

# Should see: research-assistant.md, causal-inference/, general/

# Check file permissions
chmod 644 ~/.claude/skills/*.md
chmod 755 ~/.claude/skills/*/
```

### Skill Not Activating

- Use explicit trigger: `/did-validator` instead of just asking
- Check trigger keywords in skill frontmatter
- Be more specific in your question

### Incomplete Responses

- Ask follow-up questions
- Reference specific sections: "Check the parallel trends section"
- Provide more context

---

## Contributing

### Adding New Skills

1. Fork repository
2. Create skill in appropriate folder
3. Follow existing format:
   - YAML frontmatter with triggers
   - Knowledge section
   - Workflow section
   - Checklists
   - Examples
   - References
4. Submit pull request

### Improving Existing Skills

Open an issue describing:
- What's missing
- What's wrong
- What could be better

---

## Academic References

Each skill cites foundational papers. Key references across all skills:

### Causal Inference
- Angrist & Pischke (2009), *Mostly Harmless Econometrics*
- Imbens & Rubin (2015), *Causal Inference for Statistics*
- Cunningham (2021), *Causal Inference: The Mixtape*

### DiD
- Card & Krueger (1994), AER
- Callaway & Sant'Anna (2021), JoE
- Goodman-Bacon (2021), JoE

### RDD
- Lee & Lemieux (2010), JEL
- Calonico et al. (2014), Econometrica
- Cattaneo et al. (2020), *Practical Introduction to RDD*

### IV
- Angrist & Krueger (1991), QJE
- Imbens & Angrist (1994), Econometrica
- Stock & Yogo (2005), *Testing for Weak Instruments*

---

## Citation

If these skills help your research:

```bibtex
@misc{econ_research_skills_2025,
  author = {Ninh Nguyen and Claude},
  title = {Economics Research Skills for AI Assistants},
  year = {2025},
  howpublished = {\url{https://github.com/ninhnguyen/econ-research-skills}},
  note = {Skills for causal inference research design validation}
}
```

---

## License

MIT License - use freely for academic and research purposes.

---

## Acknowledgments

Skills developed based on:
- Methodology from top economics journals (AER, QJE, Econometrica, JPE, Restud)
- Teaching experience in graduate causal inference
- Real research consulting experience

---

**Questions?** [Open an issue](https://github.com/ninhnguyen/econ-research-skills/issues)

**Found this useful?** Star ⭐ the repo!

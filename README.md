# Economics Research Skills for AI Assistants

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-blue)](https://claude.ai/code)

**Professional-grade causal inference skills for Claude Code. Designed for economists, by economists.**

**Try it now:** [Live Demo](https://anninh-blog.vercel.app/projects/research-assistant) — no install needed.

---

## What Is This?

8 specialized skills that turn Claude Code into an expert research methodology consultant, built on a three-layer architecture:

| Layer | Component | Scope | Purpose |
|-------|-----------|-------|---------|
| **1. Always-On** | Project `CLAUDE.md` | Per project | Background quality scanner |
| **2. Orchestrator** | `/research-assistant` | Global | Routes to the right method |
| **3. Specialists** | `/did-validator`, etc. | Global | Deep method-specific knowledge |

Each specialist skill contains:
- Complete theoretical knowledge
- Step-by-step workflows
- Validation checklists
- Code templates (Stata/R)
- Real examples with solutions
- Academic references

### Two Ways to Use

**Claude Code users (recommended):** Install skills for slash-command access (`/did-validator`, `/rdd-validator`, etc.) with automatic quality scanning in your project. The three-layer architecture works together seamlessly.

**Any AI (ChatGPT, Claude Web, Gemini, etc.):** Copy any `skills/*/SKILL.md` file, paste it into your AI conversation as a system prompt, then ask your research question. The AI will follow the skill's validation workflow. No installation needed — just copy and paste.

---

## Quick Start

### Claude Code (Recommended)

```bash
# Clone and install (2 minutes)
git clone https://github.com/anninhn/econ-research-skills.git
cd econ-research-skills
bash install.sh /path/to/your/research/project

# Restart Claude Code — done!
```

The install script:
1. Copies 8 skills to `~/.claude/skills/` (global, available everywhere)
2. Creates a project `CLAUDE.md` with always-on quality scanning (project-scoped)

### Any AI (No Install)

```bash
# Copy a skill and paste into ChatGPT, Claude Web, etc.
cat skills/iv-validator/SKILL.md | pbcopy   # Mac
cat skills/iv-validator/SKILL.md | xclip    # Linux
# Then paste into your AI and ask: "Is my instrument valid?"
```

---

## Three-Layer Architecture

```
Layer 1: CLAUDE.md (project-level, always on)
┌──────────────────────────────────────────────────┐
│  Active the moment you open your project.         │
│  Scans EVERY message for:                         │
│  ├── Data flags ("I'll collect data later")       │
│  ├── Result flags (effect > 100%)                 │
│  ├── Method flags ("controls will fix it")         │
│  └── Language flags ("proves causality")           │
│                                                    │
│  Lightweight. No deep method knowledge.            │
│  Only active in your research project folder.      │
└──────────────────────┬───────────────────────────┘
                       │
                       │ When user needs method-specific help
                       ▼
Layer 2: /research-assistant (orchestrator skill, global)
┌──────────────────────────────────────────────────┐
│  User describes their research question.           │
│  AI classifies type → picks method → validates.    │
│                                                    │
│  Contains:                                         │
│  ├── Method selection decision tree                │
│  ├── Conversational question flow                  │
│  └── Routes to appropriate specialist              │
└──────────────────────┬───────────────────────────┘
                       │
                       │ When user needs deep method knowledge
                       ▼
Layer 3: Specialist skills (global, on demand)
┌──────────────────────────────────────────────────┐
│  /did-validator     /iv-validator                  │
│  /rdd-validator     /event-study-validator         │
│  /mechanism-designer  /data-auditor                │
│  /red-flag-detector                                │
│                                                    │
│  Each contains:                                    │
│  ├── Full theoretical knowledge                    │
│  ├── Step-by-step workflows                        │
│  ├── Code templates (Stata/R)                      │
│  ├── Method-specific red flags                     │
│  ├── Examples with solutions                       │
│  └── Academic references                           │
└──────────────────────────────────────────────────┘
```

### What Lives Where

| Component | CLAUDE.md | /research-assistant | Specialist Skills |
|-----------|-----------|---------------------|-------------------|
| Universal red flags | Always scans | - | - |
| Method selection | - | Yes | - |
| Data availability check | Reminds to check | Routes to /data-auditor | - |
| DiD assumptions | - | Basic check | Full validation + code |
| RDD manipulation tests | - | - | Full validation + code |
| IV exclusion restriction | - | - | Full validation + code |
| Writing quality | Flags overclaiming | - | - |
| Pre-submission full scan | - | - | /red-flag-detector |

---

## Skills Overview

### Method Selection: Which Skill Do I Need?

Answer these questions in order:

**1. Is there a sharp cutoff that determines treatment?**
- YES → `/rdd-validator`
- NO → next question

**2. Do you have before/after + treatment/control groups?**
- YES → `/did-validator`
- NO → next question

**3. Is there a one-time exogenous shock (earthquake, law change)?**
- YES → `/event-study-validator`
- NO → next question

**4. Do you have a valid instrument?**
- YES → `/iv-validator`
- NO → Not sure? Start with `/research-assistant`

### All Skills

| Skill | Purpose | Slash Command |
|-------|---------|---------------|
| `research-assistant` | Master orchestrator — routes to the right method | `/research-assistant` |
| `did-validator` | Validate difference-in-differences designs | `/did-validator` |
| `rdd-validator` | Validate regression discontinuity designs | `/rdd-validator` |
| `iv-validator` | Validate instrumental variables designs | `/iv-validator` |
| `event-study-validator` | Validate event study / natural experiment designs | `/event-study-validator` |
| `mechanism-designer` | Design testable mechanisms for causal effects | `/mechanism-designer` |
| `data-auditor` | Verify data availability before committing to a design | `/data-auditor` |
| `red-flag-detector` | Comprehensive pre-submission scan for problems | `/red-flag-detector` |

---

## Usage Examples

### Example 1: Start with a research question

```
You: /research-assistant
     "I want to study the effect of Vietnam's provincial merger
      on night lights. 63 provinces merged into 34 on June 12, 2025."

AI:  Good question. Before we pick a method:

     DATA CHECK:
     - Night lights: VIIRS satellite data is available ✅
     - Treatment: provinces that lost capital ✅
     - Timing: June 2025 ✅

     This looks like a Difference-in-Differences setup.

     Let me check a few things:
     ├── Can you get data before 2023? (need 2+ years pre-treatment)
     ├── Why did some provinces keep capital? (selection concern ⚠️)
     └── Can workers move between provinces? (SUTVA concern)
```

### Example 2: Validate a specific method

```
You: /rdd-validator
     "Students with test scores ≥ 80 get scholarships.
      Can I use RDD to study the effect on college attendance?"

AI:  ✅ VALID RDD SETUP

     RUNNING VARIABLE: Test score (0-100)
     CUTOFF: 80 (sharp)

     ⚠️ MANIPULATION CHECK REQUIRED:
     Students might study harder to get ≥ 80

     TEST: Run rddensity test
     CODE (Stata): rddensity score, c(80)
                   rdrobust attendance score, c(80)
```

### Example 3: Red flags caught automatically

```
You: "My IV first-stage F-stat is 4.5"

AI:  🚨 RED FLAG: WEAK INSTRUMENT

     F = 4.5 < 10 → Instrument is weak

     CONSEQUENCES:
     - 2SLS biased toward OLS
     - Confidence intervals unreliable

     FIXES:
     1. Add controls to strengthen first stage
     2. Use weak-instrument robust methods (Anderson-Rubin, LIML)
     3. Find a stronger instrument
```

---

## Installation

### Option 1: Install Script (Recommended)

```bash
git clone https://github.com/anninhn/econ-research-skills.git
cd econ-research-skills

# Install skills + create project CLAUDE.md
bash install.sh /path/to/your/research/project

# Restart Claude Code
```

What gets installed:

```
~/.claude/skills/                          ← Global (all projects)
├── research-assistant/SKILL.md
├── did-validator/SKILL.md
├── rdd-validator/SKILL.md
├── iv-validator/SKILL.md
├── event-study-validator/SKILL.md
├── mechanism-designer/SKILL.md
├── data-auditor/SKILL.md
└── red-flag-detector/SKILL.md

/your/research/project/
└── CLAUDE.md                              ← Project (this project only)
```

### Option 2: Manual Install

```bash
# Skills (global)
mkdir -p ~/.claude/skills
cp -r skills/* ~/.claude/skills/

# Project CLAUDE.md (per project)
cp templates/CLAUDE.md /path/to/your/project/CLAUDE.md
# Then edit CLAUDE.md to add your project context
```

### Verify Installation

```bash
ls ~/.claude/skills/
# Should show 8 directories:
# data-auditor  did-validator  event-study-validator
# iv-validator  mechanism-designer  rdd-validator
# red-flag-detector  research-assistant
```

---

## Project CLAUDE.md

The `CLAUDE.md` file is the always-on quality scanner. It only activates in the project folder where it lives, so your other projects are unaffected.

**Customize it for your project:**

```markdown
# Economics Research Project

### Always-On Quality Scanner
[Keep the default flags — they apply to all research projects]

### Project Context     ← ADD YOUR PROJECT INFO HERE
- Research question: Effect of X on Y
- Data source: VIIRS night lights, 2019-2025
- Method: Difference-in-Differences
- Treatment: [describe]
```

Key principle: `CLAUDE.md` is **project-scoped**. Skills are **global**. Other projects are not affected.

---

## Research Workflow

### Phase 1: Exploring

```
/research-assistant "I want to study [X]'s effect on [Y]"
→ Get method recommendation
→ AI asks about data, identification, mechanism
```

### Phase 2: Validating

```
/did-validator "Check my DiD design: [details]"
→ Validates assumptions
→ Flags problems
→ Suggests specification
→ Provides code templates
```

### Phase 3: Writing

```
/red-flag-detector "Scan my design for problems"
→ Full pre-submission check
→ Writing quality review
→ Missing tests identified
```

---

## Directory Structure

```
econ-research-skills/
├── README.md
├── LICENSE
├── install.sh                         ← Install script
├── templates/
│   └── CLAUDE.md                      ← Template for project CLAUDE.md
└── skills/
    ├── research-assistant/SKILL.md    ← Orchestrator
    ├── did-validator/SKILL.md         ← DiD validation
    ├── rdd-validator/SKILL.md         ← RDD validation
    ├── iv-validator/SKILL.md          ← IV validation
    ├── event-study-validator/SKILL.md ← Event study validation
    ├── mechanism-designer/SKILL.md    ← Mechanism testing
    ├── data-auditor/SKILL.md          ← Data availability check
    └── red-flag-detector/SKILL.md     ← Pre-submission scan
```

---

## Troubleshooting

### Skills Not Loading

```bash
# Check skills are in right place (must be one level deep)
ls ~/.claude/skills/*/

# Each should contain SKILL.md:
# ~/.claude/skills/did-validator/SKILL.md  ← CORRECT
# ~/.claude/skills/causal-inference/did-validator/SKILL.md  ← WRONG (too deep)
```

### CLAUDE.md Not Activating

- Must be in the project directory where `CLAUDE.md` lives
- Check: `ls /your/project/CLAUDE.md`
- Restart Claude Code after creating

### Skill Not Activating

- Use the explicit slash command: `/did-validator`
- Be specific about your research question

---

## Contributing

### Adding New Skills

1. Fork repository
2. Create skill as `skills/<name>/SKILL.md`
3. Follow existing format:
   - YAML frontmatter with `name`, `description`, `user-invocable: true`
   - ROLE section
   - KNOWLEDGE section
   - WORKFLOW section
   - EXAMPLES section
   - REFERENCES section
4. Submit pull request

### Improving Existing Skills

Open an issue describing what's missing, wrong, or could be better.

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
  howpublished = {\url{https://github.com/anninhn/econ-research-skills}},
  note = {Skills for causal inference research design validation}
}
```

---

## License

MIT License — use freely for academic and research purposes.

---

**Questions?** [Open an issue](https://github.com/anninhn/econ-research-skills/issues)

**Found this useful?** Star the repo!

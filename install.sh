#!/bin/bash
# Install econ-research-skills for Claude Code
# Usage: bash install.sh [project_path]
#
# If project_path is provided, also creates a project-level CLAUDE.md
# Example: bash install.sh ~/Desktop/my-research

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"

echo "========================================="
echo " econ-research-skills installer"
echo "========================================="
echo ""

# --- Step 1: Install skills ---
echo "[1/3] Installing skills to $SKILLS_DIR ..."

mkdir -p "$SKILLS_DIR"

for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    target="$SKILLS_DIR/$skill_name"

    mkdir -p "$target"
    cp "$skill_dir/SKILL.md" "$target/SKILL.md"
    echo "  Installed: $skill_name"
done

echo "  Done. 8 skills installed."
echo ""

# --- Step 2: Verify ---
echo "[2/3] Verifying installation ..."

count=$(ls -d "$SKILLS_DIR"/*/SKILL.md 2>/dev/null | wc -l | tr -d ' ')

if [ "$count" -ge 8 ]; then
    echo "  All skills discovered."
else
    echo "  WARNING: Only $count skills found. Expected 8."
fi
echo ""

# --- Step 3: Optional project CLAUDE.md ---
PROJECT_PATH="${1:-}"

if [ -n "$PROJECT_PATH" ]; then
    echo "[3/3] Creating project CLAUDE.md at $PROJECT_PATH ..."
    mkdir -p "$PROJECT_PATH"

    if [ -f "$PROJECT_PATH/CLAUDE.md" ]; then
        echo "  WARNING: CLAUDE.md already exists at $PROJECT_PATH/CLAUDE.md"
        echo "  Skipping. To update, manually copy templates/CLAUDE.md"
    else
        cp "$SCRIPT_DIR/templates/CLAUDE.md" "$PROJECT_PATH/CLAUDE.md"
        echo "  Created: $PROJECT_PATH/CLAUDE.md"
        echo "  Edit this file to add your project context (research question, data, etc.)"
    fi
else
    echo "[3/3] Skipping project CLAUDE.md (no project path provided)."
    echo "  To add later: cp templates/CLAUDE.md /path/to/your/project/CLAUDE.md"
fi

echo ""
echo "========================================="
echo " Installation complete!"
echo ""
echo " Usage:"
echo "   /research-assistant    → Start here for any research question"
echo "   /did-validator         → Validate DiD design"
echo "   /rdd-validator         → Validate RDD design"
echo "   /iv-validator          → Validate IV design"
echo "   /event-study-validator → Validate event study"
echo "   /mechanism-designer    → Design testable mechanisms"
echo "   /data-auditor          → Check data availability"
echo "   /red-flag-detector     → Full pre-submission scan"
echo ""
echo " Restart Claude Code to load new skills."
echo "========================================="

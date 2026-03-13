#!/bin/bash

set -e

echo "Starting AI agent..."

NUMBER=$ISSUE_NUMBER
TITLE=$ISSUE_TITLE
BODY=$ISSUE_BODY

BRANCH="ai-issue-$NUMBER"

git config --global user.name "ai-agent"
git config --global user.email "ai-agent@github.com"

git checkout main
git pull origin main

git checkout -b "$BRANCH"

echo "Reading repository memory..."

MEMORY=""

if [ -f .ai/memory.md ]; then
  MEMORY=$(cat .ai/memory.md)
fi

echo "Analyzing repository structure..."

TREE=$(tree -L 4 -I "node_modules|dist|build|.git")

CONTEXT=$(find . -type f \
 -name "*.ts" -o \
 -name "*.js" -o \
 -name "*.py" \
 | head -n 20 \
 | xargs cat)

echo "Creating implementation plan..."

PLAN=$(python - <<EOF
import os, google.generativeai as genai

genai.configure(api_key=os.environ["GEMINI_API_KEY"])
model = genai.GenerativeModel("gemini-1.5-pro")

prompt = f"""
You are a senior software architect.

Repository memory:
{MEMORY}

Repository structure:
{TREE}

Code context:
{CONTEXT}

Issue:
Title: {TITLE}
Description: {BODY}

Create a detailed step-by-step plan.
"""

print(model.generate_content(prompt).text)
EOF
)

echo "$PLAN" > PLAN.md

git add PLAN.md
git commit -m "AI implementation plan"

echo "Implementing feature..."

aider --model gemini/gemini-1.5-pro <<EOF
Implementation plan:

$PLAN

Follow this plan to implement the feature.
Create logical commits.
EOF

echo "Running tests..."

TEST_FAILED=false

if [ -f package.json ]; then
  npm install
  npm test || TEST_FAILED=true
fi

if [ "$TEST_FAILED" = true ]; then

echo "Tests failed, attempting auto fix..."

aider --model gemini/gemini-1.5-pro <<EOF
Tests failed.

Fix the issues based on test failures.
EOF

fi

echo "Running AI code review..."

DIFF=$(git diff main)

REVIEW=$(python - <<EOF
import os, google.generativeai as genai

genai.configure(api_key=os.environ["GEMINI_API_KEY"])
model = genai.GenerativeModel("gemini-1.5-pro")

prompt = f"""
You are a senior engineer performing a code review.

Review this diff:

{DIFF}

Detect possible bugs or improvements.
"""

print(model.generate_content(prompt).text)
EOF
)

echo "Updating repository memory..."

UPDATED_MEMORY=$(python - <<EOF
import os, google.generativeai as genai

genai.configure(api_key=os.environ["GEMINI_API_KEY"])
model = genai.GenerativeModel("gemini-1.5-pro")

prompt = f"""
Update repository memory based on new code changes.

Current memory:
{MEMORY}

Changes:
{DIFF}

Return the updated memory file.
"""

print(model.generate_content(prompt).text)
EOF
)

echo "$UPDATED_MEMORY" > .ai/memory.md

git add .ai/memory.md
git commit -m "update AI memory"

git push origin "$BRANCH"

gh pr create \
 --title "AI: $TITLE" \
 --body "Automated implementation of issue #$NUMBER

$BODY

---

### Implementation Plan
$PLAN

---

### AI Code Review
$REVIEW"
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

TREE=$(tree -L 4 -I "node_modules|dist|build|.git" || echo "tree unavailable")

echo "Collecting code context..."

CONTEXT=$(find . -type f \( \
-name "*.ts" -o \
-name "*.js" -o \
-name "*.py" \
\) | head -n 20 | xargs cat 2>/dev/null || true)

export MEMORY
export TREE
export CONTEXT
export TITLE
export BODY

echo "Creating implementation plan..."

PLAN=$(python3 <<EOF
import os
import google.generativeai as genai

genai.configure(api_key=os.environ["GEMINI_API_KEY"])
model = genai.GenerativeModel("gemini-1.5-flash")

memory = os.environ.get("MEMORY","")
tree = os.environ.get("TREE","")
context = os.environ.get("CONTEXT","")
title = os.environ.get("TITLE","")
body = os.environ.get("BODY","")

prompt = f"""
You are a senior software architect AI agent.

Repository memory:
{memory}

Repository structure:
{tree}

Code context:
{context}

Issue:
Title: {title}
Description: {body}

Create a detailed step-by-step implementation plan.
"""

response = model.generate_content(prompt)

print(response.text)
EOF
)

echo "$PLAN" > PLAN.md

git add PLAN.md
git commit -m "AI implementation plan"

echo "Implementing feature..."

aider --model gemini/gemini-1.5-flash <<EOF
Implementation plan:

$PLAN

Follow the plan carefully.
Modify or create files as needed.
Make clean logical commits.
EOF

echo "Running tests..."

TEST_FAILED=false

if [ -f package.json ]; then
  npm install
  npm test || TEST_FAILED=true
fi

if [ "$TEST_FAILED" = true ]; then

echo "Tests failed, attempting AI auto fix..."

aider --model gemini/gemini-1.5-flash <<EOF
Tests are failing.

Analyze the errors and fix the code.
EOF

fi

echo "Preparing diff..."

DIFF=$(git diff main)

export DIFF

echo "Running AI code review..."

REVIEW=$(python3 <<EOF
import os
import google.generativeai as genai

genai.configure(api_key=os.environ["GEMINI_API_KEY"])
model = genai.GenerativeModel("gemini-1.5-flash")

diff = os.environ.get("DIFF","")

prompt = f"""
You are a senior software engineer performing a code review.

Review the following diff and detect:

- bugs
- security issues
- improvements
- architecture problems

Diff:
{diff}
"""

response = model.generate_content(prompt)

print(response.text)
EOF
)

echo "Updating repository memory..."

UPDATED_MEMORY=$(python3 <<EOF
import os
import google.generativeai as genai

genai.configure(api_key=os.environ["GEMINI_API_KEY"])
model = genai.GenerativeModel("gemini-1.5-flash")

memory = os.environ.get("MEMORY","")
diff = os.environ.get("DIFF","")

prompt = f"""
You maintain the repository memory.

Current memory:
{memory}

Recent code changes:
{diff}

Update the repository memory with any new architectural or technical knowledge.

Return the full updated memory document.
"""

response = model.generate_content(prompt)

print(response.text)
EOF
)

mkdir -p .ai

echo "$UPDATED_MEMORY" > .ai/memory.md

git add .ai/memory.md
git commit -m "update AI repository memory"

echo "Pushing branch..."

git push origin "$BRANCH"

echo "Creating Pull Request..."

gh pr create \
 --title "AI: $TITLE" \
 --body "Automated implementation of issue #$NUMBER

$BODY

---

## Implementation Plan

$PLAN

---

## AI Code Review

$REVIEW"

echo "AI agent completed successfully."
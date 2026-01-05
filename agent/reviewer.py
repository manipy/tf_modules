import json
import os
from openai import OpenAI
from github_client import post_pr_comment
from rules import SECURITY_RULES, BEST_PRACTICES

client = OpenAI(api_key=os.environ["OPENAI_API_KEY"])

def load_plan():
    with open("tfplan.json") as f:
        return json.load(f)

def review_with_ai(plan):
    prompt = f"""
You are a senior cloud DevOps reviewer.

Terraform Rules:
Security:
{SECURITY_RULES}

Best Practices:
{BEST_PRACTICES}

Terraform Plan:
{json.dumps(plan, indent=2)}

Respond in markdown with:
- 🔴 Critical issues
- 🟠 Warnings
- 🟢 Good practices
- ✅ Merge recommendation
"""

    response = client.chat.completions.create(
        model="gpt-4.1",
        messages=[{"role": "user", "content": prompt}]
    )

    return response.choices[0].message.content

if __name__ == "__main__":
    plan = load_plan()
    review = review_with_ai(plan)
    post_pr_comment(review)

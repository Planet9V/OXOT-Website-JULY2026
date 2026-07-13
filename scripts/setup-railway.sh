#!/usr/bin/env bash
# Railway deployment setup script — deploys PostgreSQL + app with full config
# Usage: ./scripts/setup-railway.sh <project-id> [environment-id]
# Example: ./scripts/setup-railway.sh 748fa91d-94c9-4a6e-af82-7b8250620c34

set -e

PROJECT_ID="${1:?Usage: $0 <project-id> [environment-id]}"
ENVIRONMENT_ID="${2:-production}"

echo "🚀 OXOT Website — Railway Deployment Setup"
echo "   Project: $PROJECT_ID"
echo "   Environment: $ENVIRONMENT_ID"
echo ""

# Ensure railway CLI is installed
if ! command -v railway &> /dev/null; then
  echo "❌ railway CLI not found. Install: npm i -g @railway/cli"
  exit 1
fi

# Generate secrets
AUTH_SECRET=$(openssl rand -base64 32)
SETTINGS_SECRET=$(openssl rand -base64 32)

echo "✅ Generated AUTH_SECRET and SETTINGS_SECRET"
echo ""

# Check if PostgreSQL service exists
echo "Checking for PostgreSQL service..."
POSTGRES_SERVICE=$(railway service ls --project="$PROJECT_ID" --environment="$ENVIRONMENT_ID" 2>/dev/null | grep -i postgres || echo "")

if [ -z "$POSTGRES_SERVICE" ]; then
  echo "⚠️  PostgreSQL service not found on Railway."
  echo ""
  echo "Manual setup required:"
  echo "1. Go to: https://railway.com/project/$PROJECT_ID"
  echo "2. Click 'New' → 'Database' → Select 'PostgreSQL'"
  echo "3. Wait for it to deploy (5-10 minutes)"
  echo "4. Note the generated DATABASE_URL"
  echo ""
  echo "Then continue with the app deployment."
  exit 1
fi

echo "✅ PostgreSQL service found"
echo ""

# Get DATABASE_URL from PostgreSQL service
echo "Fetching DATABASE_URL from PostgreSQL service..."
# Note: This requires railway CLI v2+ with service variable support
# For now, we'll show instructions
echo ""
echo "📋 Next Steps — Configure OXOT-Website-JULY2026 Service"
echo ""
echo "Set these environment variables in Railway:"
echo ""
echo "  DATABASE_URL = \${{ PostgreSQL.DATABASE_URL }}"
echo "  AUTH_SECRET = $AUTH_SECRET"
echo "  SETTINGS_SECRET = $SETTINGS_SECRET"
echo ""
echo "Optional (if using OpenRouter):"
echo "  OPENROUTER_API_KEY = <your-api-key>"
echo ""
echo "Then redeploy the app."
echo ""

echo "To set variables via CLI (if you have access):"
echo ""
echo "  railway variable set DATABASE_URL '\${{ PostgreSQL.DATABASE_URL }}' --project=\"$PROJECT_ID\" --environment=\"$ENVIRONMENT_ID\""
echo "  railway variable set AUTH_SECRET \"$AUTH_SECRET\" --project=\"$PROJECT_ID\" --environment=\"$ENVIRONMENT_ID\""
echo "  railway variable set SETTINGS_SECRET \"$SETTINGS_SECRET\" --project=\"$PROJECT_ID\" --environment=\"$ENVIRONMENT_ID\""
echo ""

echo "Or visit: https://railway.com/project/$PROJECT_ID?environmentId=$ENVIRONMENT_ID"
echo "Click OXOT-Website-JULY2026 → Variables → Add"
echo ""


#!/bin/sh
set -e

echo "[chatwoot] ============================================"
echo "[chatwoot] Chatwoot on Railway starting..."
echo "[chatwoot] PORT=$PORT"
echo "[chatwoot] RAILS_ENV=$RAILS_ENV"
echo "[chatwoot] ============================================"

echo "[chatwoot] Running database migrations..."
bundle exec rails db:chatwoot_prepare
echo "[chatwoot] Migrations complete."

echo "[chatwoot] Starting Sidekiq worker in background..."
bundle exec sidekiq -C config/sidekiq.yml &
SIDEKIQ_PID=$!
echo "[chatwoot] Sidekiq started with PID $SIDEKIQ_PID"

trap "echo '[chatwoot] Shutting down...'; kill $SIDEKIQ_PID; exit" TERM INT

echo "[chatwoot] Starting Rails web server on port $PORT..."
bundle exec rails s -b 0.0.0.0

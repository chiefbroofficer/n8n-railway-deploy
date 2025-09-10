#!/bin/sh
# Simple wrapper for Railway PORT binding
exec n8n start --port=${PORT:-5678}
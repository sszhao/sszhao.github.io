#!/bin/bash

# Jekyll Local Server Script
# This script will install dependencies and start a local Jekyll server

echo "🚀 Starting Jekyll local server..."
echo ""

# Check if bundle is installed
if ! command -v bundle &> /dev/null; then
    echo "❌ Bundler not found. Installing..."
    gem install bundler
fi

# Install dependencies
echo "📦 Installing dependencies..."
bundle install

# Build and serve
echo ""
echo "🔨 Building site and starting server..."
echo ""
echo "🌐 Your website will be available at:"
echo "   http://localhost:4000"
echo ""
echo "📁 To use the new design, visit:"
echo "   http://localhost:4000/new-index.html"
echo ""
echo "⚠️  Press Ctrl+C to stop the server"
echo ""

bundle exec jekyll serve --livereload --drafts

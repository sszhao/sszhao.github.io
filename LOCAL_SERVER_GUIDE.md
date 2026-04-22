# 🌐 How to View Your Website Locally

This guide will walk you through running your website on your local computer.

---

## ✅ Prerequisites Check

Before starting, make sure you have these installed:

1. **Ruby** (already installed ✅)
   - Check: `ruby --version`
   - You should see: `ruby 3.3.2`

2. **Bundler** (already installed ✅)
   - Check: `bundle --version`
   - You should see: `Bundler version 2.5.9`

---

## 🚀 Step-by-Step Instructions

### Step 1: Open Terminal

Press `Cmd + Space`, type "Terminal", and press Enter.

### Step 2: Navigate to Your Website Folder

Type this command in Terminal:

```bash
cd /Users/zhaoshengdong/claude_code/Shen_Website
```

### Step 3: Run the Server

You have TWO options:

#### Option A: Use the Quick Script (Recommended)

```bash
./serve.sh
```

This will:
- Install any missing dependencies
- Build your website
- Start the local server

#### Option B: Run Commands Manually

```bash
# Install dependencies (first time only)
bundle install

# Start the server
bundle exec jekyll serve --livereload
```

---

## 🌐 Step 4: View Your Website

Once the server is running, you'll see this message:

```
Server address: http://127.0.0.1:4000
Server running... press ctrl-c to stop.
```

Now open your web browser and go to:

- **New Design**: http://localhost:4000/new-index.html
- **Old Design**: http://localhost:4000/

---

## 🔧 Troubleshooting Common Issues

### Issue 1: "Address already in use - bind(2) for 127.0.0.1:4000"

**Solution**: Kill the existing process:

```bash
# Find the process using port 4000
lsof -ti:4000

# Kill it
kill -9 $(lsof -ti:4000)

# Or use this one-liner
lsof -ti:4000 | xargs kill -9
```

Then run the server again.

---

### Issue 2: "Could not locate Gemfile"

**Solution**: Make sure you're in the correct directory:

```bash
pwd
```

You should see: `/Users/zhaoshengdong/claude_code/Shen_Website`

If not, navigate to it:

```bash
cd /Users/zhaoshengdong/claude_code/Shen_Website
```

---

### Issue 3: "Permission denied - serve.sh"

**Solution**: Make the script executable:

```bash
chmod +x serve.sh
```

Then run it again.

---

### Issue 4: "Bundler::GemNotFound" or missing gems

**Solution**: Reinstall dependencies:

```bash
bundle install
```

If that fails, try:

```bash
bundle update
```

---

### Issue 5: Changes not showing up

**Solution**: 
1. Make sure you're looking at the right URL (new-index.html for the new design)
2. Hard refresh your browser: `Cmd + Shift + R`
3. Check if the server is still running in the Terminal

---

## 💡 Tips

1. **Live Reload**: The server has live reload enabled. When you make changes to files, the browser will automatically refresh.

2. **Stop the Server**: Press `Ctrl + C` in the Terminal to stop the server.

3. **View on Phone**: You can view the site on your phone if it's on the same WiFi network:
   - Find your computer's IP: `ipconfig getifaddr en0`
   - Visit: `http://YOUR-IP:4000`

---

## 🆘 Still Having Issues?

If you're still stuck, try these steps:

1. **Restart your computer** (seriously, it helps!)

2. **Check Ruby installation**:
   ```bash
   ruby --version
   which ruby
   ```

3. **Reinstall Bundler**:
   ```bash
   gem install bundler
   ```

4. **Clear cache and reinstall**:
   ```bash
   rm -rf .bundle
   rm -rf vendor
   bundle install
   ```

---

## 🎉 Success!

Once you see your website running at `http://localhost:4000/new-index.html`, you're all set! 🎊

You can now:
- View your new website design
- Make changes to files and see them update live
- Test everything before pushing to production

---

**Happy coding! 🚀**

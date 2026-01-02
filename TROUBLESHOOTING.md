# Troubleshooting Guide

## Socket Timeout Error

If you see `Error: Socket timeout` in Agent TARS, try these solutions:

### Solution 1: Use Minimal Configuration (Recommended)

Start Agent TARS with minimal MCP servers to reduce startup time:

```bash
./start-minimal.sh
```

This uses `agent.config.minimal.ts` which only loads essential MCP servers (filesystem and memory).

### Solution 2: Test API Connection

Before starting Agent TARS, test if the ModelScope API is responding:

```bash
./test-api.sh
```

Expected output:
- ✅ Response time < 2 seconds
- ✅ HTTP 200 OK
- ✅ Valid JSON response

If the test fails:
- Check your internet connection
- Verify your API key in `.env`
- Try switching to DeepSeek: `cp .env.local.deepseek .env`

### Solution 3: Increase Timeout Settings

The default configuration already has generous timeouts:
- Browser timeout: 60 seconds
- Navigation timeout: 60 seconds
- Model response: streaming enabled

If you still get timeouts, the issue might be:
1. **Slow internet connection** - Try using a faster network
2. **ModelScope API overload** - Try again later or switch to DeepSeek
3. **Complex tasks** - Break down your request into smaller steps

### Solution 4: Switch to DeepSeek

DeepSeek API is often faster and more stable:

```bash
cp .env.local.deepseek .env
./start.sh
```

### Solution 5: Disable Browser Visibility

If browser operations are slow, try headless mode:

Edit `agent.config.ts`:
```typescript
browser: {
  headless: true,  // Change to true
  // ...
}
```

## "web_navigate" Tool Not Found

This error occurs when the model tries to use a non-existent tool. Solutions:

### Solution 1: Use Correct Tool Names

In your prompts, explicitly mention the correct tools:
- ✅ "Use web_search to find..."
- ✅ "Use browser to visit..."
- ❌ "Use web_navigate to..." (doesn't exist)

### Solution 2: Enable Debug Mode

See which tools are available:

```bash
./start.sh  # Already has --debug enabled
```

Check the console output for available tools list.

## Files Not Saved in Workspace

If files are saved outside the workspace directory:

### Solution: Already Fixed

The latest configuration saves all files to `./workspace/`:
- Downloaded files
- Generated charts
- Screenshots
- Reports

Check `./workspace/` after running tasks.

## Browser Not Visible

If you can't see the browser window during web operations:

### Solution: Already Fixed

The configuration now has:
```typescript
browser: {
  headless: false,  // Browser window will be visible
  // ...
}
```

You should see:
- ✅ Browser window opens
- ✅ Can see search progress
- ✅ Can see page navigation

## Rate Limit Errors

ModelScope API has rate limits:
- 50 requests per model per hour
- 2000 total requests per hour

If you hit the limit:
1. Wait for the limit to reset (shown in error message)
2. Switch to DeepSeek: `cp .env.local.deepseek .env`
3. Use a different ModelScope API key

## Need More Help?

1. Check the logs in the terminal (debug mode is enabled)
2. Check browser console (F12) in the web UI
3. Test API connection: `./test-api.sh`
4. Try minimal configuration: `./start-minimal.sh`
5. Switch to DeepSeek: `cp .env.local.deepseek .env && ./start.sh`


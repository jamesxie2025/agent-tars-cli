# Agent TARS CLI - Configuration Guide

## Quick Start

1. **Copy the example configuration:**
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` and configure your model:**
   ```bash
   nano .env  # or use your preferred editor
   ```

3. **Restart the container:**
   ```bash
   docker-compose down
   docker-compose up -d
   ```

## How to Change Model Configuration

### Step 1: Edit `.env` File

Open the `.env` file and modify these variables:

```bash
# Model Configuration
TARS_MODEL_PROVIDER=<provider>      # Provider name
TARS_MODEL_NAME=<model-id>          # Model identifier
TARS_MODEL_BASE_URL=<base-url>      # API base URL (optional)
TARS_MODEL_API_KEY=<api-key>        # Your API key
```

### Step 2: Restart the Container

After editing `.env`, restart the container to apply changes:

```bash
docker-compose down
docker-compose up -d
```

### Step 3: Verify Configuration

Check the logs to confirm the model is loaded:

```bash
docker logs agent-tars
```

You should see:
```
🤖 Model: <provider> | <model-name>
```

---

## Configuration Examples

### Example 1: ModelScope (Qwen) - Recommended for Chinese Users

```bash
TARS_MODEL_PROVIDER=openai
TARS_MODEL_NAME=Qwen/Qwen3-Coder-480B-A35B-Instruct
TARS_MODEL_BASE_URL=https://api-inference.modelscope.cn/v1/
TARS_MODEL_API_KEY=ms-your-api-key-here
```

**Get API Key:** https://modelscope.cn/my/myaccesstoken

### Example 2: Official OpenAI (GPT-4o)

```bash
TARS_MODEL_PROVIDER=openai
TARS_MODEL_NAME=gpt-4o
TARS_MODEL_BASE_URL=
TARS_MODEL_API_KEY=sk-your-openai-api-key-here
```

**Get API Key:** https://platform.openai.com/api-keys

### Example 3: Anthropic Claude

```bash
TARS_MODEL_PROVIDER=anthropic
TARS_MODEL_NAME=claude-3-7-sonnet-latest
TARS_MODEL_BASE_URL=
TARS_MODEL_API_KEY=sk-ant-your-anthropic-api-key-here
```

**Get API Key:** https://console.anthropic.com/settings/keys

### Example 4: DeepSeek

```bash
TARS_MODEL_PROVIDER=deepseek
TARS_MODEL_NAME=deepseek-chat
TARS_MODEL_BASE_URL=
TARS_MODEL_API_KEY=sk-your-deepseek-api-key-here
```

**Get API Key:** https://platform.deepseek.com/api_keys

### Example 5: VolcEngine (Doubao/豆包)

```bash
TARS_MODEL_PROVIDER=volcengine
TARS_MODEL_NAME=doubao-1-5-thinking-vision-pro-250428
TARS_MODEL_BASE_URL=
TARS_MODEL_API_KEY=your-volcengine-api-key-here
```

**Get API Key:** https://console.volcengine.com/ark/region:ark+cn-beijing/apiKey

---

## Configuration Parameters

### Required Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `TARS_MODEL_PROVIDER` | Model provider name | `openai`, `anthropic`, `deepseek`, `volcengine` |
| `TARS_MODEL_NAME` | Model identifier | `gpt-4o`, `claude-3-7-sonnet-latest` |
| `TARS_MODEL_API_KEY` | Your API key | `sk-...` or `ms-...` |

### Optional Parameters

| Parameter | Description | When to Use |
|-----------|-------------|-------------|
| `TARS_MODEL_BASE_URL` | Custom API endpoint | For OpenAI-compatible APIs (e.g., ModelScope, local models) |

---

## Troubleshooting

### Issue: "Connection error" in Web UI

**Solution:** Check that your API key is correct and the model name is valid.

```bash
# View logs for error details
docker logs agent-tars

# Verify environment variables are loaded
docker exec agent-tars env | grep TARS_MODEL
```

### Issue: Model not showing in UI

**Solution:** Ensure you restarted the container after editing `.env`:

```bash
docker-compose down
docker-compose up -d
```

### Issue: "Cannot read properties of undefined (reading 'models')"

**Solution:** This means the provider configuration is incorrect. Make sure:
1. `TARS_MODEL_PROVIDER` is set to a valid provider
2. For OpenAI-compatible APIs (like ModelScope), use `provider=openai` with custom `baseURL`
3. `TARS_MODEL_API_KEY` is set correctly

---

## Advanced: Using Custom OpenAI-Compatible APIs

Agent TARS supports any OpenAI-compatible API. Configure it like this:

```bash
TARS_MODEL_PROVIDER=openai
TARS_MODEL_NAME=<your-model-name>
TARS_MODEL_BASE_URL=<your-api-endpoint>
TARS_MODEL_API_KEY=<your-api-key>
```

Examples:
- **ModelScope:** `https://api-inference.modelscope.cn/v1/`
- **Local Ollama:** `http://localhost:11434/v1/`
- **LM Studio:** `http://localhost:1234/v1/`
- **vLLM:** `http://your-server:8000/v1/`

---

## Need Help?

- **GitHub Issues:** https://github.com/jamesxie2025/agent-tars-cli/issues
- **Agent TARS Docs:** https://agent-tars.com


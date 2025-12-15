# Agent TARS CLI

🤖 **Agent TARS** - Multimodal AI Agent by ByteDance

A powerful AI agent with web search, file operations, chart generation, and more capabilities powered by Qwen3-Coder or DeepSeek models.

## ✨ Features

- 🌐 **Web Search**: Built-in web search with Google
- 📁 **File Operations**: Read/write files via MCP filesystem server
- 📊 **Chart Generation**: Create visualizations with 25+ chart types
- 📑 **Excel Processing**: Read and write Excel files
- 🗄️ **SQLite Database**: Structured data storage
- �� **Persistent Memory**: Remember context across sessions
- 🔧 **Git Operations**: Version control integration
- 🎨 **Multimodal**: Support for vision-capable models (GPT-4o, Qwen-VL)

## 🚀 Quick Start

### Prerequisites

- **Node.js** 18+ ([Download](https://nodejs.org/))
- **npm** 9+
- **API Keys**: ModelScope or DeepSeek API key

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/jamesxie2025/agent-tars-cli.git
   cd agent-tars-cli
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Configure environment**:

   **Option A: Use pre-configured templates (Recommended)**
   ```bash
   # For Qwen (ModelScope)
   cp .env.local.qwen .env

   # For DeepSeek
   cp .env.local.deepseek .env

   # For OpenAI GPT-4o
   cp .env.local.openai .env
   ```

   **Option B: Create from example**
   ```bash
   cp .env.example .env
   ```

   Then edit `.env` and add your real API keys:
   ```bash
   # Edit with your favorite editor
   nano .env
   # or
   vim .env
   ```

4. **Start Agent TARS**:
   ```bash
   ./start.sh
   # or
   npm start
   ```

5. **Access Web UI**:
   - Open http://localhost:8080 in your browser

## 📋 Configuration

### Model Configuration

Edit `.env` to configure your model:

**Option 1: Qwen3-Coder (ModelScope)** - Default
```bash
TARS_MODEL_PROVIDER=openai
TARS_MODEL_NAME=Qwen/Qwen3-Coder-480B-A35B-Instruct
TARS_MODEL_BASE_URL=https://api-inference.modelscope.cn/v1
TARS_MODEL_API_KEY=your-modelscope-api-key
```

**Option 2: DeepSeek-Chat**
```bash
TARS_MODEL_PROVIDER=openai
TARS_MODEL_NAME=deepseek-chat
TARS_MODEL_BASE_URL=https://api.deepseek.com/v1
TARS_MODEL_API_KEY=your-deepseek-api-key
```

**Option 3: GPT-4o (OpenAI)**
```bash
TARS_MODEL_PROVIDER=openai
TARS_MODEL_NAME=gpt-4o
TARS_MODEL_BASE_URL=https://api.openai.com/v1
TARS_MODEL_API_KEY=your-openai-api-key
```

### Vision Support

Edit `agent.config.ts`:
```typescript
model: {
  enableVision: true  // true for GPT-4o, Qwen-VL; false for text-only models
}
```

## 🛠️ Available Commands

```bash
npm start          # Start Agent TARS
npm run dev        # Start in development mode
npm run stop       # Stop Agent TARS
npm run restart    # Restart Agent TARS
npm run logs       # View logs
npm run clean      # Clean cache and generated files
npm test           # Check installation
```

## 📁 Project Structure

```
agent-tars-cli/
├── agent.config.ts      # Agent TARS configuration
├── .env                 # Environment variables (API keys)
├── package.json         # Node.js dependencies
├── start.sh             # Startup script
├── data/                # Persistent data (gitignored)
├── cache/               # Cache files (gitignored)
├── generated/           # Generated files (gitignored)
└── workspace/           # Working directory (gitignored)
```

## 🔧 Troubleshooting

### Web Search Not Working

Make sure you have:
1. ✅ Chrome or Chromium installed on your system
2. ✅ VPN enabled if accessing Google from restricted regions
3. ✅ `enableVision: true` in `agent.config.ts` for vision-capable models

### Model API Errors

- Check your API key in `.env`
- Verify the model name and base URL
- Check API quota and rate limits

## 📚 Documentation

- [Agent TARS Official Docs](https://github.com/bytedance/UI-TARS-desktop)
- [MCP Protocol](https://modelcontextprotocol.io/)
- [Qwen Models](https://modelscope.cn/models/Qwen)
- [DeepSeek API](https://platform.deepseek.com/)

## 📝 License

MIT

## 👤 Author

**James Xie**
- GitHub: [@jamesxie2025](https://github.com/jamesxie2025)
- Email: jxw.xie@gmail.com

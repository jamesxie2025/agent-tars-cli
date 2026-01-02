/**
 * Agent TARS Configuration
 *
 * This file configures Agent TARS settings including browser, search, and MCP servers.
 */

export default {
  // Model configuration
  // Note: Model provider, name, baseURL, and apiKey are configured via command-line arguments
  // See start.sh for how these are passed from .env file
  model: {
    // Enable vision capabilities for multimodal models (GPT-4o, Qwen-VL, etc.)
    // Set to false if using text-only models like DeepSeek-Chat
    enableVision: false,  // Disable vision for Qwen3-Coder (text-only model)

    // Temperature for response randomness (0.0 = deterministic, 1.0 = creative)
    temperature: 0.7,

    // Maximum tokens in response
    maxTokens: 4096,

    // Stream responses for better UX
    stream: true
  },

  // Browser configuration for web navigation
  browser: {
    headless: false,  // Set to false to see browser actions (better for debugging and progress visibility)
    // Auto-detect Chrome/Chromium on macOS
    // Puppeteer will find the browser automatically
    args: [
      "--no-sandbox",
      "--disable-setuid-sandbox",
      "--disable-dev-shm-usage",
      "--disable-blink-features=AutomationControlled",  // Avoid detection as bot
      "--disable-gpu",  // Reduce resource usage
      "--disable-software-rasterizer"
    ],
    control: "dom",

    // Timeout settings for browser operations (in milliseconds)
    timeout: 60000,  // 60 seconds for page load
    navigationTimeout: 60000  // 60 seconds for navigation
  },

  // Search configuration
  search: {
    provider: "browser_search",
    count: 5,  // Reduce to 5 results to avoid timeout
    browserSearch: {
      engine: "google",
      needVisitedUrls: false,
      browser: {
        headless: false,  // Show browser for search too (better visibility)
        // Auto-detect Chrome/Chromium on macOS
        args: [
          "--no-sandbox",
          "--disable-setuid-sandbox",
          "--disable-dev-shm-usage",
          "--disable-blink-features=AutomationControlled",
          "--disable-gpu",
          "--disable-software-rasterizer"
        ],
        timeout: 60000,  // 60 seconds timeout
        navigationTimeout: 60000
      }
    }
  },

  // MCP Servers configuration
  mcpServers: {
    // File system operations
    filesystem: {
      command: "npx",
      args: ["-y", "@modelcontextprotocol/server-filesystem", "./workspace"],
      env: {},
      description: "File system access for reading/writing files in workspace directory"
    },

    // Excel file processing
    excel: {
      command: "npx",
      args: ["-y", "@negokaz/excel-mcp-server"],
      env: {},
      description: "Read and write Excel files (.xlsx, .xls)"
    },

    // Chart generation (using AntV MCP server)
    chart: {
      command: "npx",
      args: ["-y", "@antv/mcp-server-chart"],
      env: {},
      description: "Generate charts and visualizations with 25+ chart types"
    },

    // Persistent memory
    memory: {
      command: "npx",
      args: ["-y", "@modelcontextprotocol/server-memory"],
      env: {},
      description: "Persistent memory across agent sessions"
    },

    // Git operations
    git: {
      command: "npx",
      args: ["-y", "@modelcontextprotocol/server-git"],
      env: {},
      description: "Git version control operations"
    },

    // SQLite database
    sqlite: {
      command: "npx",
      args: ["-y", "@modelcontextprotocol/server-sqlite", "./data/agent.db"],
      env: {},
      description: "SQLite database for structured data storage"
    }
  }
};


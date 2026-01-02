/**
 * Agent TARS Minimal Configuration
 * 
 * This is a minimal configuration with only essential MCP servers.
 * Use this if you're experiencing timeout issues.
 * 
 * To use: ./start.sh --config agent.config.minimal.ts
 */

export default {
  // Model configuration
  model: {
    enableVision: false,  // Disable vision for Qwen3-Coder (text-only model)
    temperature: 0.7,
    maxTokens: 4096,
    stream: true
  },

  // Browser configuration for web navigation
  browser: {
    headless: false,  // Show browser for better visibility
    args: [
      "--no-sandbox",
      "--disable-setuid-sandbox",
      "--disable-dev-shm-usage",
      "--disable-blink-features=AutomationControlled",
      "--disable-gpu",
      "--disable-software-rasterizer"
    ],
    control: "dom",
    timeout: 60000,
    navigationTimeout: 60000
  },

  // Search configuration
  search: {
    provider: "browser_search",
    count: 3,  // Only 3 results for faster response
    browserSearch: {
      engine: "google",
      needVisitedUrls: false,
      browser: {
        headless: false,
        args: [
          "--no-sandbox",
          "--disable-setuid-sandbox",
          "--disable-dev-shm-usage",
          "--disable-blink-features=AutomationControlled",
          "--disable-gpu",
          "--disable-software-rasterizer"
        ],
        timeout: 60000,
        navigationTimeout: 60000
      }
    }
  },

  // MCP Servers configuration - MINIMAL SET
  mcpServers: {
    // File system operations (essential)
    filesystem: {
      command: "npx",
      args: ["-y", "@modelcontextprotocol/server-filesystem", "./workspace"],
      env: {},
      description: "File system access for reading/writing files in workspace directory"
    },

    // Persistent memory (essential)
    memory: {
      command: "npx",
      args: ["-y", "@modelcontextprotocol/server-memory"],
      env: {},
      description: "Persistent memory across agent sessions"
    }
    
    // Other MCP servers disabled to reduce startup time and avoid timeouts
    // Uncomment as needed:
    
    // excel: {
    //   command: "npx",
    //   args: ["-y", "@negokaz/excel-mcp-server"],
    //   env: {},
    //   description: "Read and write Excel files (.xlsx, .xls)"
    // },
    
    // chart: {
    //   command: "npx",
    //   args: ["-y", "@antv/mcp-server-chart"],
    //   env: {},
    //   description: "Generate charts and visualizations with 25+ chart types"
    // },
    
    // git: {
    //   command: "npx",
    //   args: ["-y", "@modelcontextprotocol/server-git"],
    //   env: {},
    //   description: "Git version control operations"
    // },
    
    // sqlite: {
    //   command: "npx",
    //   args: ["-y", "@modelcontextprotocol/server-sqlite", "./data/agent.db"],
    //   env: {},
    //   description: "SQLite database for structured data storage"
    // }
  }
};


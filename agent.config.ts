/**
 * Agent TARS Configuration
 * 
 * This file configures Agent TARS settings including browser, model, and MCP servers.
 */

export default {
  // Browser configuration
  browser: {
    headless: true,
    executablePath: "/usr/bin/chromium",
    args: [
      "--headless=new",
      "--no-sandbox",
      "--disable-setuid-sandbox",
      "--disable-dev-shm-usage",
      "--disable-gpu",
      "--disable-software-rasterizer"
    ],
    control: "dom"
  },

  // Search configuration
  search: {
    provider: "browser_search",
    count: 10,
    browserSearch: {
      engine: "google",
      needVisitedUrls: false,
      browser: {
        headless: true,
        executablePath: "/usr/bin/chromium",
        args: [
          "--headless=new",
          "--no-sandbox",
          "--disable-setuid-sandbox",
          "--disable-dev-shm-usage",
          "--disable-gpu",
          "--disable-software-rasterizer"
        ]
      }
    }
  },

  // MCP Servers configuration
  mcpServers: {
    // File system operations
    filesystem: {
      command: "npx",
      args: ["-y", "@modelcontextprotocol/server-filesystem", "/app/data", "/app/generated"],
      env: {},
      description: "File system access for reading/writing files"
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
      args: ["-y", "@modelcontextprotocol/server-sqlite", "/app/data/agent.db"],
      env: {},
      description: "SQLite database for structured data storage"
    }
  }
};


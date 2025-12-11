/**
 * Agent TARS MCP Configuration
 * 
 * This file configures MCP (Model Context Protocol) servers for Agent TARS.
 * Agent TARS has built-in browser automation, so we only add complementary tools.
 * 
 * Configured Tools:
 * - filesystem: File operations
 * - excel: Excel file processing  
 * - chart: Data visualization
 * - memory: Persistent memory across sessions
 * - git: Version control operations
 * - sqlite: Local database
 */

export default {
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

    // Chart generation
    chart: {
      command: "npx",
      args: ["-y", "@modelcontextprotocol/server-chart"],
      env: {},
      description: "Generate charts and visualizations"
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
    },

    // Optional: Brave Search (requires API key in .env)
    // Uncomment if you have BRAVE_API_KEY configured
    /*
    "brave-search": {
      command: "npx",
      args: ["-y", "@modelcontextprotocol/server-brave-search"],
      env: {
        BRAVE_API_KEY: process.env.BRAVE_API_KEY || ""
      },
      description: "Web search via Brave Search API"
    },
    */

    // Optional: GitHub integration (requires token in .env)
    // Uncomment if you have GITHUB_TOKEN configured
    /*
    github: {
      command: "npx",
      args: ["-y", "@modelcontextprotocol/server-github"],
      env: {
        GITHUB_PERSONAL_ACCESS_TOKEN: process.env.GITHUB_TOKEN || ""
      },
      description: "GitHub API integration"
    },
    */

    // Optional: PostgreSQL (requires connection string in .env)
    // Uncomment if you have POSTGRES_CONNECTION_STRING configured
    /*
    postgres: {
      command: "npx",
      args: ["-y", "@modelcontextprotocol/server-postgres"],
      env: {
        POSTGRES_CONNECTION_STRING: process.env.POSTGRES_CONNECTION_STRING || ""
      },
      description: "PostgreSQL database integration"
    },
    */
  }
};


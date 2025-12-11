/**
 * Agent TARS MCP Configuration - Minimal Version
 * 
 * This is a minimal configuration with only essential tools.
 * Use this if you encounter issues with the full configuration.
 * 
 * Configured Tools:
 * - filesystem: File operations
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
  }
};


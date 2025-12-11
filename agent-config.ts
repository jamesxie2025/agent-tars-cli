/**
 * Agent TARS Configuration
 * 
 * This file configures the AI model provider for Agent TARS.
 */

export default {
  // Model Configuration
  model: {
    provider: "modelscope",
    name: "qwen-max",
    apiKey: process.env.MODELSCOPE_API_KEY,
  },
  
  // Server Configuration
  server: {
    port: 8080,
    host: "0.0.0.0",
  },
  
  // Workspace Configuration
  workspace: {
    dataDir: "/app/data",
    cacheDir: "/app/cache",
    generatedDir: "/app/generated",
  },
};


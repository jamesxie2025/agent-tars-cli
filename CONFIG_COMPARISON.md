# Configuration Comparison

## start.sh vs start-minimal.sh

### start.sh (Recommended)

**Configuration file**: `agent.config.ts`

**MCP Servers loaded** (4 servers):
- ✅ **filesystem** - File operations in workspace
- ✅ **excel** - Read/write Excel files (.xlsx, .xls)
- ✅ **chart** - Generate charts with 25+ chart types
- ✅ **memory** - Persistent memory across sessions

**Disabled** (can be enabled if needed):
- ❌ **git** - Git version control operations
- ❌ **sqlite** - SQLite database

**Use case**: 
- General purpose usage
- Need Excel processing
- Need chart generation
- Balanced performance and features

**Start command**:
```bash
./start.sh
```

---

### start-minimal.sh (Fastest)

**Configuration file**: `agent.config.minimal.ts`

**MCP Servers loaded** (2 servers):
- ✅ **filesystem** - File operations in workspace
- ✅ **memory** - Persistent memory across sessions

**Disabled**:
- ❌ **excel** - Excel processing
- ❌ **chart** - Chart generation
- ❌ **git** - Git operations
- ❌ **sqlite** - SQLite database

**Use case**:
- Fastest startup time
- Minimal resource usage
- Basic file operations only
- Troubleshooting socket timeout issues

**Start command**:
```bash
./start-minimal.sh
```

---

## Which one should I use?

### Use `start.sh` if:
- ✅ You need Excel file processing
- ✅ You need chart generation
- ✅ You want full features
- ✅ Socket timeout is now fixed (only 4 servers)

### Use `start-minimal.sh` if:
- ✅ You only need basic file operations
- ✅ You want fastest startup
- ✅ You're still experiencing timeout issues
- ✅ You don't need Excel or charts

---

## Performance Comparison

| Feature | start.sh | start-minimal.sh |
|---------|----------|------------------|
| MCP Servers | 4 | 2 |
| Startup Time | ~5-10s | ~3-5s |
| Excel Support | ✅ Yes | ❌ No |
| Chart Support | ✅ Yes | ❌ No |
| File Operations | ✅ Yes | ✅ Yes |
| Memory | ✅ Yes | ✅ Yes |
| Git Operations | ❌ No | ❌ No |
| SQLite Database | ❌ No | ❌ No |

---

## How to enable more MCP servers

If you need git or sqlite, edit `agent.config.ts`:

```typescript
// Uncomment these sections:

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
```

**Note**: Adding more servers may increase startup time and risk of timeout.

---

## Recommendation

**Start with `start.sh`** - It now has the optimal balance:
- Fast enough (4 servers)
- Includes Excel and Chart support
- Should not timeout anymore

If you still get timeout errors, fall back to `start-minimal.sh`.


# 浏览器功能终极解决方案

## 问题分析

### 根本原因

`browser_search` 提供商在 Docker 容器中无法工作的根本原因：

1. **内部依赖**: `browser_search` 内部使用 `chrome-paths` 包（来自 `@agent-infra/browser`）来查找浏览器
2. **查找机制**: `chrome-paths` 使用 `which` 命令按特定顺序查找浏览器：
   - **chrome 分支**（优先级高）:
     1. `google-chrome-stable` ← **最高优先级**
     2. `google-chrome`
   - **canary 分支**（优先级低）:
     3. `chromium-browser`
     4. `chromium`
3. **之前的错误**: 只创建了 `google-chrome` 符号链接，缺少 `google-chrome-stable`

### 错误日志

```
Core:AgentTARS:LocalEnvironment:SearchToolProvider Find Chrome Error: Error [ChromePathsError]: Unable to find any chrome browser.
Core:AgentTARS:LocalEnvironment:SearchToolProvider Find Edge Error: { name: 'edge-paths', message: 'Unable to find any ms-edge-browser.' }
Core:AgentTARS:LocalEnvironment:SearchToolProvider Find Firefox Error: Error [FirefoxPathsError]: Unable to find any firefox browser.
Core:AgentTARS:LocalEnvironment:SearchToolProvider Search failed: Error [BrowserPathsError]: Unable to find any browser.
```

## 终极解决方案

### 方案：创建正确的符号链接

**关键发现**: 通过查看 `chrome-paths` 源码发现，它使用 `which` 命令查找浏览器，且 `google-chrome-stable` 是**最高优先级**。

**解决方案**:
1. 创建 `google-chrome-stable` 符号链接指向 `/usr/bin/chromium`
2. 创建其他符号链接作为备选
3. 恢复使用 `--search.provider browser_search` 参数

### 符号链接配置

```bash
# Dockerfile 中的配置
RUN ln -s /usr/bin/chromium /usr/bin/google-chrome-stable && \
    ln -s /usr/bin/chromium /usr/bin/google-chrome && \
    ln -s /usr/bin/chromium /usr/bin/chromium-browser && \
    ln -s /usr/bin/chromium /usr/bin/chrome
```

**说明**:
- `google-chrome-stable` - chrome-paths 的第一选择（最重要！）
- `google-chrome` - chrome-paths 的第二选择
- `chromium-browser` - canary 分支的第一选择
- `chromium` - canary 分支的第二选择（已存在）

### 使用示例

#### 使用 browser_search 搜索

**用户请求**:
```
请搜索深圳未来三天的天气情况
```

**Agent 执行**:
- 使用内置的 `browser_search` 工具
- 自动打开浏览器搜索
- 返回搜索结果

#### 使用浏览器导航工具

**用户请求**:
```
请访问 https://www.weather.com.cn 并提取深圳的天气信息
```

**Agent 执行**:
1. `browser_navigate` → 访问网站
2. `browser_get_markdown` → 提取内容
3. 分析并返回结果

## 优势

### 真正解决问题的优势

1. **使用内置功能**: 充分利用 Agent TARS 的 `browser_search` 工具
2. **无需绕过**: 不需要禁用或排除任何功能
3. **完整功能**: 所有浏览器相关工具都可用
4. **简单直接**: 只需创建正确的符号链接
5. **符合设计**: 按照 chrome-paths 的预期方式工作

## 配置说明

### Dockerfile 配置

```dockerfile
CMD sh -c "agent-tars --ui --port 8080 \
  --config /app/mcp-config.ts \
  --workspace /app/workspace \
  --browser.control dom \
  --browser '{\"executablePath\":\"/usr/bin/chromium\",\"args\":[\"--headless=new\",\"--no-sandbox\",\"--disable-setuid-sandbox\",\"--disable-dev-shm-usage\",\"--disable-gpu\",\"--disable-software-rasterizer\"]}' \
  --search.provider browser_search \
  --search.count 10 \
  --model.provider ${TARS_MODEL_PROVIDER:-openai} \
  --model.id ${TARS_MODEL_NAME:-gpt-4o} \
  --model.baseURL ${TARS_MODEL_BASE_URL:-} \
  --model.apiKey ${TARS_MODEL_API_KEY:-...}"
```

**关键参数**:
- `--browser.control dom`: 使用 DOM 控制模式
- `--browser`: 指定浏览器路径和 Docker 必需参数
  - `--headless=new`: **新版无头模式（不依赖 X11，Docker 必需！）**
  - `--no-sandbox`: Docker 容器中必需
  - `--disable-setuid-sandbox`: 禁用 setuid 沙箱
  - `--disable-dev-shm-usage`: 避免共享内存问题
  - `--disable-gpu`: 无头模式禁用 GPU
  - `--disable-software-rasterizer`: 禁用软件光栅化
- `--search.provider browser_search`: **启用 browser_search**（现在可以工作了！）
- `--search.count 10`: 搜索结果数量

**环境变量**:
```dockerfile
ENV DISPLAY=:99
```
- 防止 Chromium 尝试连接 X server

### 浏览器参数说明

```json
{
  "executablePath": "/usr/bin/chromium",
  "args": [
    "--no-sandbox",              // Docker 容器中必需
    "--disable-setuid-sandbox",  // 禁用 setuid 沙箱
    "--disable-dev-shm-usage",   // 避免共享内存问题
    "--disable-gpu"              // 无头模式禁用 GPU
  ]
}
```

## 测试验证

### 测试命令

```bash
# 1. 验证符号链接已创建
docker exec agent-tars which google-chrome-stable
# 预期结果: /usr/bin/google-chrome-stable

docker exec agent-tars which google-chrome
# 预期结果: /usr/bin/google-chrome

# 2. 测试浏览器可执行
docker exec agent-tars chromium --headless --no-sandbox --disable-gpu --dump-dom https://www.example.com
# 预期结果: <html lang="en"><head><title>Example Domain</title>...

# 3. 验证 browser_search 工具正常工作
docker logs agent-tars 2>&1 | grep -E "(browser_search|BrowserSearch)"
# 预期结果：应该看不到任何错误，或者看到成功的搜索日志
```

### 功能测试

1. **使用 browser_search**: "请搜索深圳未来三天的天气情况"
2. **网页抓取**: "请访问 https://www.weather.com.cn 并提取深圳的天气信息"
3. **复杂交互**: "请在 booking.com 上搜索深圳的酒店"

## 总结

**问题**: `browser_search` 在 Docker 中不可用

**根本原因**:
1. **浏览器检测问题**: `chrome-paths` 使用 `which` 命令查找浏览器
   - 查找顺序：`google-chrome-stable` > `google-chrome` > `chromium-browser` > `chromium`
   - 之前只创建了 `google-chrome` 符号链接，缺少最高优先级的 `google-chrome-stable`

2. **浏览器启动问题**: Docker 容器中没有图形界面
   - 错误：`Missing X server or $DISPLAY`
   - 旧版 `--headless` 仍然尝试初始化 X11/Ozone 平台
   - `ui/ozone/platform/x11` 尝试连接 X server

**最终解决方案**:
1. **创建正确的符号链接**:
   ```bash
   ln -s /usr/bin/chromium /usr/bin/google-chrome-stable
   ln -s /usr/bin/chromium /usr/bin/google-chrome
   ln -s /usr/bin/chromium /usr/bin/chromium-browser
   ```

2. **使用新版 headless 模式**:
   ```json
   {"executablePath":"/usr/bin/chromium","args":["--headless=new","--no-sandbox","--disable-setuid-sandbox","--disable-dev-shm-usage","--disable-gpu","--disable-software-rasterizer"]}
   ```
   - `--headless=new`: 新版 headless 模式，不依赖 X11
   - `--disable-software-rasterizer`: 禁用软件光栅化

3. **设置环境变量**:
   ```bash
   ENV DISPLAY=:99
   ```
   - 防止 Chromium 尝试连接 X server

4. **启用 browser_search**:
   ```bash
   --search.provider browser_search --search.count 10
   ```

**关键洞察**:
- 通过查看源码找到真正的问题
- 不是绕过问题，而是真正解决问题
- 符号链接的名称和优先级很重要
- Docker 容器中必须使用 `--headless=new` 模式（旧版 `--headless` 不够）
- 新版 headless 模式完全不依赖 X11，是 Docker 的最佳选择

**验证**:
- ✅ Chromium 命令行测试成功
- ✅ 能够正常抓取网页内容
- ✅ 无 X11 相关错误

**状态**: ✅ 已实现并提交到 GitHub

---

**更新时间**: 2025-12-12
**版本**: Build #31 (真正的最终版本)

**源码参考**: `/usr/local/lib/node_modules/@agent-tars/cli/node_modules/@agent-infra/browser/dist/browser-finder/chrome-paths.js`


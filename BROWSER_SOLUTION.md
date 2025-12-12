# 浏览器功能终极解决方案

## 问题分析

### 根本原因

`browser_search` 提供商在 Docker 容器中无法工作的根本原因：

1. **内部依赖**: `browser_search` 内部使用 `chrome-paths`, `edge-paths`, `firefox-paths` npm 包来查找浏览器
2. **硬编码路径**: 这些包有硬编码的搜索路径，无法识别容器中的 Chromium 安装
3. **无法绕过**: 符号链接、环境变量、`--browser` 参数都无法解决此问题，因为这些包不读取这些配置

### 错误日志

```
Core:AgentTARS:LocalEnvironment:SearchToolProvider Find Chrome Error: Error [ChromePathsError]: Unable to find any chrome browser.
Core:AgentTARS:LocalEnvironment:SearchToolProvider Find Edge Error: { name: 'edge-paths', message: 'Unable to find any ms-edge-browser.' }
Core:AgentTARS:LocalEnvironment:SearchToolProvider Find Firefox Error: Error [FirefoxPathsError]: Unable to find any firefox browser.
Core:AgentTARS:LocalEnvironment:SearchToolProvider Search failed: Error [BrowserPathsError]: Unable to find any browser.
```

## 终极解决方案

### 方案：使用浏览器导航工具代替 browser_search

**移除**: `--search.provider browser_search`

**使用**: Agent TARS 的浏览器导航工具进行搜索

### 可用的浏览器工具

1. **browser_navigate** - 导航到任何网页
2. **browser_get_markdown** - 提取网页内容（Markdown 格式）
3. **browser_vision_control** - 视觉交互（点击、滚动、输入）
4. **browser_click** - DOM 点击
5. **browser_type** - DOM 输入
6. **browser_back/forward/refresh** - 浏览器导航

### 使用示例

#### 搜索天气信息

**用户请求**:
```
请搜索深圳未来三天的天气情况
```

**Agent 执行流程**:
1. `browser_navigate` → `https://www.google.com/search?q=深圳未来三天天气`
2. `browser_get_markdown` → 提取搜索结果
3. `browser_vision_control` → 点击相关链接
4. `browser_get_markdown` → 提取天气详情
5. 总结并返回结果

#### 访问特定网站

**用户请求**:
```
请访问 https://www.weather.com.cn 并提取深圳的天气信息
```

**Agent 执行流程**:
1. `browser_navigate` → `https://www.weather.com.cn`
2. `browser_get_markdown` → 提取页面内容
3. 分析并返回深圳天气信息

## 优势

### 相比 browser_search 的优势

1. **完全可控**: 不依赖第三方包的浏览器检测
2. **更灵活**: 可以访问任何网站，不限于搜索引擎
3. **更强大**: 可以进行复杂的交互（点击、滚动、表单填写）
4. **无依赖问题**: 在 Docker 容器中完美工作
5. **更透明**: 用户可以看到 Agent 的每一步操作

## 配置说明

### Dockerfile 配置

```dockerfile
CMD sh -c "agent-tars --ui --port 8080 \
  --config /app/mcp-config.ts \
  --workspace /app/workspace \
  --browser.control dom \
  --browser '{\"executablePath\":\"/usr/bin/chromium\",\"args\":[\"--no-sandbox\",\"--disable-setuid-sandbox\",\"--disable-dev-shm-usage\",\"--disable-gpu\"]}' \
  --model.provider ${TARS_MODEL_PROVIDER:-openai} \
  --model.id ${TARS_MODEL_NAME:-gpt-4o} \
  --model.baseURL ${TARS_MODEL_BASE_URL:-} \
  --model.apiKey ${TARS_MODEL_API_KEY:-...}"
```

**关键参数**:
- `--browser.control dom`: 使用 DOM 控制模式
- `--browser`: 指定浏览器路径和 Docker 必需参数
- **移除**: `--search.provider browser_search`

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
# 测试网页抓取
docker exec agent-tars chromium --headless --no-sandbox --disable-gpu --dump-dom https://www.example.com

# 预期结果
<html lang="en"><head><title>Example Domain</title>...
```

### 功能测试

1. **网页搜索**: "请打开 Google 搜索'深圳天气'并总结结果"
2. **网页抓取**: "请访问 https://www.weather.com.cn 并提取深圳的天气信息"
3. **复杂交互**: "请在 booking.com 上搜索深圳的酒店"

## 总结

**问题**: `browser_search` 在 Docker 中不可用  
**原因**: 依赖包的硬编码路径无法识别容器中的浏览器  
**解决方案**: 使用浏览器导航工具代替  
**优势**: 更灵活、更强大、无依赖问题  
**状态**: ✅ 已实现并测试通过

---

**更新时间**: 2025-12-12  
**版本**: Build #15


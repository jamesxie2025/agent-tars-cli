# Agent TARS - 功能说明

## ✅ 已启用的功能

### 🌐 浏览器自动化和网页抓取
- **浏览器控制**: 内置 Chromium 浏览器，支持网页自动化
- **网页导航**: 使用 `browser_navigate` 访问任何网页
- **内容提取**: 使用 `browser_get_markdown` 提取网页内容
- **视觉交互**: 使用 `browser_vision_control` 点击、滚动、输入
- **控制模式**: DOM（基于 DOM 的精确控制）

**使用示例**:
```
请访问 https://www.weather.com.cn 并提取深圳的天气信息
请打开 Google 搜索"深圳未来三天天气"并总结结果
请访问 https://www.example.com 并提取主要内容
```

### 📊 数据分析和可视化
- **Python 3.11.2**: 完整的 Python 环境
- **数据处理**: pandas 2.3.3
- **可视化**: matplotlib 3.10.8, seaborn 0.13.2, plotly 6.5.0
- **Excel 处理**: openpyxl 3.1.5, xlrd 2.0.2
- **数值计算**: numpy 2.3.5

**使用示例**:
```
请分析这些销售数据并生成图表
创建一个包含销售趋势的 Excel 文件
```

### 📁 MCP 工具集成

#### 1. **filesystem** - 文件系统操作
- 读写文件
- 目录管理
- 访问路径: `/app/data`, `/app/generated`

#### 2. **excel** - Excel 文件处理
- 读取 Excel 文件 (.xlsx, .xls)
- 写入 Excel 文件
- 数据处理和分析

#### 3. **chart** - 图表生成
- 使用 AntV MCP Server
- 支持 25+ 种图表类型
- 数据可视化

#### 4. **memory** - 持久化记忆
- 跨会话记忆
- 上下文保持
- 知识积累

#### 5. **git** - 版本控制
- Git 操作
- 代码管理
- 版本追踪

#### 6. **sqlite** - 本地数据库
- SQLite 数据库
- 结构化数据存储
- 数据查询

### 🤖 AI 模型支持
- **当前配置**: ModelScope (Qwen/Qwen3-Coder-480B-A35B-Instruct)
- **备用配置**: DeepSeek
- **支持的提供商**: OpenAI, Anthropic, ModelScope, DeepSeek, VolcEngine

## 📂 文件存储

### 持久化目录
- **data/**: 数据文件（永久保存）
- **cache/**: 缓存文件（可清理）
- **generated/**: AI 生成的文件（可清理）
- **workspace/**: 工作空间（可清理）

### 清理文件
```bash
./cleanup.sh
```

## 🔧 配置参数

### 浏览器配置
- `--browser.control dom`: DOM 控制模式
- `--browser`: 浏览器可执行文件路径和参数（JSON 格式）

### 模型配置
- `--model.provider`: 模型提供商
- `--model.id`: 模型 ID
- `--model.baseURL`: API 基础 URL
- `--model.apiKey`: API 密钥

## 📊 功能测试

### 测试网页搜索
```
请打开 Google 搜索"深圳天气"并总结结果
```

### 测试网页抓取
```
请访问 https://www.weather.com.cn 并提取深圳的天气信息
```

### 测试数据分析
```
请创建一个包含以下数据的 Excel 文件：
日期, 销售额
2024-01-01, 1000
2024-01-02, 1500
2024-01-03, 1200
```

### 测试图表生成
```
请使用上面的销售数据生成一个折线图
```

## ⚠️ 注意事项

1. **网页搜索**: 使用浏览器导航工具（browser_navigate + browser_get_markdown）进行搜索，无需额外 API
2. **Chart MCP**: 使用 @antv/mcp-server-chart（正确的包名）
3. **文件清理**: 定期运行 `./cleanup.sh` 清理临时文件
4. **镜像版本**: 保持稳定，避免频繁更改
5. **Docker 环境**: 浏览器使用 --no-sandbox 参数以支持容器环境

## 🚀 快速开始

```bash
# 启动服务
docker-compose up -d

# 访问 Web 界面
open http://localhost:8080

# 查看日志
docker-compose logs -f

# 运行诊断
./diagnose.sh

# 清理文件
./cleanup.sh
```

## 📝 更新日志

- **2025-12-12**: 启用浏览器搜索和网页抓取功能
- **2025-12-12**: 修复 chart MCP 配置（使用 @antv/mcp-server-chart）
- **2025-12-12**: 清理临时文档，保持项目简洁


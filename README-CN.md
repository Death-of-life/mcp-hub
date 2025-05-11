# MCP Hub （中文说明）

MCP Hub 作为客户端与多个 MCP 服务器之间的中央协调器，使你可以通过单一接口轻松调用多个服务器的能力。实现了 [MCP 2025-03-26](https://modelcontextprotocol.io/specification/2025-03-26) 规范。

## 功能支持

| 分类 | 功能 | 支持 | 备注 |
|------|------|------|------|
| **传输协议** ||||
| | streamable-http | ✅ | 远程服务器主要协议 |
| | SSE | ✅ | 远程服务器备用协议 |
| | STDIO | ✅ | 本地服务器 |
| **认证** ||||
| | OAuth 2.0 | ✅ | 支持 PKCE 流程 |
| | Headers | ✅ | 支持 API key/token |
| **能力** ||||
| | 工具 | ✅ | 工具列表 |
| | 🔔 工具列表变更 | ✅ | 实时更新 |
| | 资源 | ✅ | 完全支持 |
| | 🔔 资源列表变更 | ✅ | 实时更新 |
| | 资源模板 | ✅ | URI 模板 |
| | 提示词 | ✅ | 完全支持 |
| | 🔔 提示词列表变更 | ✅ | 实时更新 |
| | Roots | ❌ | 不支持 |
| | Sampling | ❌ | 不支持 |
| | Completion | ❌ | 不支持 |
| **市场** ||||
| | 服务器发现 | ✅ | 浏览可用服务器 |
| | 安装 | ✅ | 自动配置 |
| **实时** ||||
| | 状态更新 | ✅ | 服务器与连接状态 |
| | 能力更新 | ✅ | 自动刷新 |
| | 事件推送 | ✅ | 基于 SSE |
| | 自动重连 | ✅ | 带退避重试 |

## 主要特性

- **动态服务器管理**：
  - 支持随时启动、停止、启用/禁用服务器
  - 实时配置热更新，自动重连
  - 支持本地（STDIO）和远程（streamable-http/SSE）MCP 服务器
  - 健康监控与自动恢复
  - 支持 OAuth PKCE 认证与 Header 认证

- **统一 REST API**：
  - 可调用任意已连接服务器的工具
  - 访问资源与资源模板
  - 通过 SSE 实时获取状态
  - 支持服务器管理的完整 CRUD

- **实时事件与监控**：
  - 服务器状态与能力实时更新
  - 客户端连接追踪
  - 工具与资源变更通知
  - 结构化 JSON 日志，支持文件输出

- **客户端连接管理**：
  - 通过 /api/events 提供 SSE 客户端连接
  - 客户端断开自动清理
  - 支持无客户端时自动关闭
  - 实时连接状态监控

- **进程生命周期管理**：
  - 优雅启动与关闭
  - 服务器连接清理
  - 错误恢复与重连

## 安装

```bash
npm install -g mcp-hub
```

## 基本用法

启动 Hub 服务器：

```bash
mcp-hub --port 3000 --config path/to/config.json
```

### CLI 参数
```bash
Options:
  --port            监听端口（必填）
  --config          配置文件路径（必填）
  --watch           监听配置文件变更，仅更新受影响服务器（默认：false）
  --auto-shutdown   无客户端时自动关闭（默认：false）
  --shutdown-delay  自动关闭前延迟（毫秒，默认：0）
  -h, --help        显示帮助
```

## 配置说明

MCP Hub 使用 JSON 文件定义管理的服务器：

```js
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["arg1", "$ACCESS_TOKEN"],
      "env": {
        "ACCESS_TOKEN": null,
        "OP_KEY": "$: cmd:op read read op://example/secret",
        "AUTH_HEADER": "Bearer ${ACCESS_TOKEN}",
        "SECRET": "secret"
      }
    },
    "remote-server": {
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer ${EXAMPLE_API_KEY}"
      }
    }
  }
}
```

- 本地（STDIO）服务器需 `command` 字段，支持 `args` 和 `env`，环境变量可引用系统变量或通过 `$:` 执行命令获取。
- 远程服务器需 `url` 字段，可选 `headers` 字段用于认证。
- 服务器类型自动判断，不能混用。
- 配置变更支持热更新，部分参数可通过命令行覆盖。

## Docker 部署

### 构建镜像

```bash
docker build -t mcp-hub .
```

### 使用 docker-compose 启动

1. 确保有配置文件 `mcp-servers.json`，并放在项目根目录。
2. 启动服务：

```bash
docker-compose up -d
```

3. 访问 MCP Hub 服务：

```
http://localhost:3000
```

### 主要说明
- 配置文件通过 `volumes` 挂载到容器 `/config/mcp-servers.json`。
- 端口默认映射为 3000:3000，可在 `docker-compose.yaml` 中自定义。
- 如需自定义环境变量（如 ACCESS_TOKEN、API KEY），可在 `environment` 字段添加。

## 其他内容

- 详细 API、事件系统、错误处理、架构等请参考英文版 README。
- 如需补充翻译或有具体问题，欢迎反馈。 
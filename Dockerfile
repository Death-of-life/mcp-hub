# 基于官方 Node.js 镜像
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm install --production

# 复制项目源码
COPY . .

# 暴露默认端口（可通过环境变量覆盖）
EXPOSE 3000

# 启动命令，支持通过环境变量指定配置文件路径
CMD ["npx", "mcp-hub", "--port", "3000", "--config", "/config/mcp-servers.json"] 
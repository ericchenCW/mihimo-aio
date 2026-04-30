## 1. Dockerfile 构建

- [x] 1.1 创建 Dockerfile，定义 builder 阶段：下载 mihomo linux-amd64 二进制
- [x] 1.2 在 builder 阶段下载 GeoIP.dat、GeoSite.dat、country.mmdb
- [x] 1.3 在 builder 阶段下载 metacubexd 面板静态文件
- [x] 1.4 定义 final 阶段：基于 alpine，安装 curl，COPY 所有构建产物到 /etc/mihomo/
- [x] 1.5 添加 EXPOSE 和 ENTRYPOINT 指令

## 2. Entrypoint 脚本

- [x] 2.1 创建 entrypoint.sh，实现 SUBSCRIBE_URL 环境变量检查和配置下载
- [x] 2.2 实现配置覆写函数：sed 处理 allow-lan、external-ui、external-controller、secret
- [x] 2.3 实现每小时后台刷新循环和 mihomo API 热重载调用
- [x] 2.4 使用 exec 启动 mihomo 作为 PID 1

## 3. 验证

- [x] 3.1 本地构建镜像并验证构建成功
- [x] 3.2 添加 .dockerignore 排除不必要文件

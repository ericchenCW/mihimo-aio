## ADDED Requirements

### Requirement: Multi-stage build downloads mihomo binary
Dockerfile SHALL use multi-stage build，在 builder 阶段从 MetaCubeX/mihomo GitHub Release 下载 linux-amd64 版本的 mihomo 二进制文件。

#### Scenario: Successful binary download
- **WHEN** Docker 构建 builder 阶段
- **THEN** 从 GitHub Release 下载最新 mihomo-linux-amd64 压缩包并解压得到 mihomo 可执行文件

### Requirement: Build downloads geo data files
Dockerfile SHALL 在构建时从 MetaCubeX/meta-rules-dat GitHub Release 下载 GeoIP.dat、GeoSite.dat 和 country.mmdb。

#### Scenario: Geo data files present in final image
- **WHEN** 镜像构建完成
- **THEN** /etc/mihomo/ 目录下包含 GeoIP.dat、GeoSite.dat、country.mmdb 三个文件

### Requirement: Build downloads metacubexd web panel
Dockerfile SHALL 在构建时从 MetaCubeX/metacubexd GitHub Release 下载面板静态文件并放置到 UI 目录。

#### Scenario: Web panel files present in final image
- **WHEN** 镜像构建完成
- **THEN** /etc/mihomo/ui/ 目录下包含 metacubexd 的静态文件（index.html 等）

### Requirement: Final image based on alpine
最终镜像 SHALL 基于 alpine，仅包含 mihomo binary、geo 数据、UI 文件、entrypoint 脚本和 curl。

#### Scenario: Minimal image size
- **WHEN** 镜像构建完成
- **THEN** 最终镜像不包含构建工具，仅包含运行时必需组件

### Requirement: Expose standard ports
Dockerfile SHALL 声明暴露端口 7890 (HTTP)、7891 (SOCKS)、7893 (Mixed)、9090 (API+UI)。

#### Scenario: Ports declared
- **WHEN** 查看 Dockerfile
- **THEN** EXPOSE 指令包含 7890 7891 7893 9090

# 五条日报 (wutiao-news)

OpenClaw skill — 个性化新闻日报，支持精选和个性化两种模式。

## 安装

```bash
curl -fsSL https://raw.githubusercontent.com/osen77/wutiao-news/main/install.sh | bash
```

安装过程会提示输入 token（向管理员获取），自动写入 `openclaw.json`。

自定义安装路径：

```bash
curl -fsSL https://raw.githubusercontent.com/osen77/wutiao-news/main/install.sh | bash -s -- /your/path/wutiao-news
```

## 配置

Token 通过 `openclaw.json` 的 env 注入机制自动传递给 skill，无需手动管理文件。

安装脚本会自动写入以下配置：

```json
{
  "skills": {
    "entries": {
      "wutiao-news": {
        "env": { "WUTIAO_TOKEN": "你的token" }
      }
    }
  }
}
```

> **注意**: `skills.entries.wutiao-news` 下只允许 `enabled`、`apiKey`、`env`、`config` 字段。添加其他字段（如 `path`、`url`）会导致配置校验失败，gateway 无法启动。

### 修改 token

编辑 `~/.openclaw/openclaw.json`，找到 `skills.entries.wutiao-news.env.WUTIAO_TOKEN` 修改即可。

### 自定义总结提示词

`references/personalized-summary-prompt.md` 控制个性化日报的 AI 总结风格。直接编辑即可，更新时不会被覆盖。

如果想恢复默认，删除该文件即可，skill 会自动 fallback 到 `personalized-summary-prompt.default.md`。

## 更新

无需手动操作。每次触发 skill 时会自动检查 GitHub 新版本并静默更新（每小时最多检查一次）。

## Agent 白名单

如果你的 agent 配置了 `skills` 白名单，需要将 `wutiao-news` 加入 `openclaw.json`：

```json
{
  "agents": {
    "list": [
      {
        "id": "your-agent",
        "skills": ["wutiao-news"]
      }
    ]
  }
}
```

## 使用

安装后对 agent 说以下任意触发词即可：

- "五条日报" / "五条" / "今天读什么" — 精选日报
- "个性化日报" / "个性化五条" — 个性化推荐
- "投稿 URL" — 投稿文章
- "订阅管理" — 管理信息源订阅
- "我的五条" — 查看个人档案和兴趣标签

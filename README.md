# 五条日报 (wutiao-news)

OpenClaw skill — 个性化新闻日报，支持精选和个性化两种模式。

## 安装

```bash
curl -fsSL https://raw.githubusercontent.com/osen77/wutiao-news/main/install.sh | bash
```

安装过程会提示输入 token（向管理员获取）。

自定义安装路径：

```bash
curl -fsSL https://raw.githubusercontent.com/osen77/wutiao-news/main/install.sh | bash -s -- /your/path/wutiao-news
```

## 配置

安装完成后，skill 目录下会生成两个本地文件（不会被 git 追踪）：

| 文件 | 说明 |
|------|------|
| `.env` | API token，安装时自动创建 |
| `references/personalized-summary-prompt.md` | 个性化总结提示词，可自由修改 |

### 修改 token

```bash
# 编辑 skill 目录下的 .env 文件
echo "WUTIAO_TOKEN=你的token" > ~/.openclaw/skills/wutiao-news/.env
```

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

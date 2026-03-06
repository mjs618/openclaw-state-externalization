import json
import os

config_path = '/root/.openclaw/openclaw.json'

with open(config_path, 'r') as f:
    config = json.load(f)

# 添加日志配置
config['logging'] = {
    "usage": {
        "enabled": True,
        "path": "/root/.openclaw/logs/usage",
        "format": "jsonl"
    }
}

# 添加模型成本信息（Kimi K2.5 价格）
if 'models' in config and 'providers' in config['models']:
    if 'kimi-coding' in config['models']['providers']:
        for model in config['models']['providers']['kimi-coding'].get('models', []):
            if model['id'] == 'k2p5':
                model['cost'] = {
                    "input": 0.000003,  # $0.003 per 1K tokens
                    "output": 0.000012,  # $0.012 per 1K tokens
                    "cacheRead": 0.0000015,
                    "cacheWrite": 0.0000075
                }

with open(config_path, 'w') as f:
    json.dump(config, f, indent=2)

print("配置已更新！")
print("- 添加日志配置")
print("- 设置Kimi K2.5模型价格")

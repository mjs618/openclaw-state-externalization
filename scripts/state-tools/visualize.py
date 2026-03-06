#!/usr/bin/env python3
"""
状态可视化工具
生成项目进度报告和可视化图表
"""

import json
import os
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional


class StateVisualizer:
    def __init__(self, project_dir: str = "."):
        self.project_dir = Path(project_dir)
        self.state_dir = self.project_dir / "state"
        self.manifest_path = self.state_dir / "manifest.json"
        
    def load_manifest(self) -> Optional[Dict]:
        """加载 manifest.json"""
        try:
            with open(self.manifest_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception as e:
            print(f"❌ 无法加载 manifest.json: {e}")
            return None
    
    def get_session_stats(self) -> Dict:
        """获取 Session 统计"""
        sessions_dir = self.state_dir / "sessions"
        if not sessions_dir.exists():
            return {"count": 0, "files": []}
        
        session_files = list(sessions_dir.glob("*.md"))
        return {
            "count": len(session_files),
            "files": sorted([f.stem for f in session_files])
        }
    
    def get_task_stats(self, manifest: Dict) -> Dict:
        """获取任务统计"""
        tasks = manifest.get("tasks", [])
        if not tasks:
            return {"total": 0, "complete": 0, "in_progress": 0}
        
        complete = sum(1 for t in tasks if t.get("status") == "complete")
        in_progress = sum(1 for t in tasks if t.get("status") == "in_progress")
        
        return {
            "total": len(tasks),
            "complete": complete,
            "in_progress": in_progress,
            "pending": len(tasks) - complete - in_progress,
            "progress": int(complete / len(tasks) * 100) if tasks else 0
        }
    
    def generate_ascii_chart(self, stats: Dict) -> str:
        """生成 ASCII 进度图"""
        progress = stats.get("progress", 0)
        bar_length = 30
        filled = int(bar_length * progress / 100)
        bar = "█" * filled + "░" * (bar_length - filled)
        return f"[{bar}] {progress}%"
    
    def generate_console_report(self) -> str:
        """生成控制台报告"""
        manifest = self.load_manifest()
        if not manifest:
            return "无法生成报告"
        
        session_stats = self.get_session_stats()
        task_stats = self.get_task_stats(manifest)
        current = manifest.get("current", {})
        
        report = []
        report.append("=" * 60)
        report.append("📊 项目状态报告")
        report.append("=" * 60)
        report.append("")
        
        # 项目信息
        project = manifest.get("project", {})
        report.append(f"📁 项目: {project.get('name', 'Unknown')}")
        report.append(f"📝 描述: {project.get('description', 'N/A')}")
        report.append("")
        
        # 当前状态
        report.append("🎯 当前状态")
        report.append("-" * 40)
        report.append(f"   状态: {current.get('status', 'unknown')}")
        report.append(f"   阶段: {current.get('phase', 'unknown')}")
        report.append(f"   激活任务: {current.get('activeTask', 'none')}")
        report.append(f"   最新 Session: {current.get('lastSession', 'none')}")
        report.append("")
        
        # 任务进度
        report.append("📋 任务进度")
        report.append("-" * 40)
        report.append(f"   总计: {task_stats['total']}")
        report.append(f"   已完成: {task_stats['complete']} ✅")
        report.append(f"   进行中: {task_stats['in_progress']} 🟡")
        report.append(f"   待开始: {task_stats['pending']} ⏳")
        report.append("")
        report.append(f"   整体进度: {self.generate_ascii_chart(task_stats)}")
        report.append("")
        
        # Session 统计
        report.append("📅 Session 统计")
        report.append("-" * 40)
        report.append(f"   总数: {session_stats['count']}")
        if session_stats['files']:
            report.append(f"   首个: {session_stats['files'][0]}")
            report.append(f"   最新: {session_stats['files'][-1]}")
        report.append("")
        
        # 决策记录
        decisions_dir = self.state_dir / "decisions"
        decision_count = len(list(decisions_dir.glob("*.md"))) if decisions_dir.exists() else 0
        report.append(f"💭 决策记录: {decision_count}")
        report.append("")
        
        report.append("=" * 60)
        report.append(f"生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        report.append("=" * 60)
        
        return "\n".join(report)
    
    def generate_html_report(self, output_path: str = "state-report.html") -> str:
        """生成 HTML 报告"""
        manifest = self.load_manifest()
        if not manifest:
            return "无法生成报告"
        
        session_stats = self.get_session_stats()
        task_stats = self.get_task_stats(manifest)
        current = manifest.get("current", {})
        project = manifest.get("project", {})
        
        html = f"""
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>项目状态报告 - {project.get('name', 'Project')}</title>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background: #f5f5f5;
        }}
        .header {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 20px;
        }}
        .card {{
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }}
        .progress-bar {{
            width: 100%;
            height: 30px;
            background: #e0e0e0;
            border-radius: 15px;
            overflow: hidden;
        }}
        .progress-fill {{
            height: 100%;
            background: linear-gradient(90deg, #4CAF50, #8BC34A);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            transition: width 0.3s ease;
        }}
        .stat-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
        }}
        .stat-item {{
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }}
        .stat-number {{
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
        }}
        .status-badge {{
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: bold;
        }}
        .status-complete {{ background: #d4edda; color: #155724; }}
        .status-in_progress {{ background: #fff3cd; color: #856404; }}
        .status-pending {{ background: #f8d7da; color: #721c24; }}
        .footer {{
            text-align: center;
            color: #666;
            font-size: 0.9em;
            margin-top: 30px;
        }}
    </style>
</head>
<body>
    <div class="header">
        <h1>📊 {project.get('name', '项目状态报告')}</h1>
        <p>{project.get('description', '')}</p>
    </div>
    
    <div class="card">
        <h2>🎯 当前状态</h2>
        <p>
            <span class="status-badge status-{current.get('status', 'pending')}">
                {current.get('status', 'unknown').upper()}
            </span>
        </p>
        <p><strong>阶段:</strong> {current.get('phase', 'unknown')}</p>
        <p><strong>激活任务:</strong> {current.get('activeTask', 'none')}</p>
        <p><strong>最新 Session:</strong> {current.get('lastSession', 'none')}</p>
    </div>
    
    <div class="card">
        <h2>📋 任务进度 ({task_stats['progress']}%)</h2>
        <div class="progress-bar">
            <div class="progress-fill" style="width: {task_stats['progress']}%">
                {task_stats['progress']}%
            </div>
        </div>
        <div class="stat-grid" style="margin-top: 20px;">
            <div class="stat-item">
                <div class="stat-number">{task_stats['total']}</div>
                <div>总任务</div>
            </div>
            <div class="stat-item">
                <div class="stat-number" style="color: #4CAF50;">{task_stats['complete']}</div>
                <div>已完成</div>
            </div>
            <div class="stat-item">
                <div class="stat-number" style="color: #FF9800;">{task_stats['in_progress']}</div>
                <div>进行中</div>
            </div>
            <div class="stat-item">
                <div class="stat-number" style="color: #9E9E9E;">{task_stats['pending']}</div>
                <div>待开始</div>
            </div>
        </div>
    </div>
    
    <div class="card">
        <h2>📅 Session 统计</h2>
        <div class="stat-grid">
            <div class="stat-item">
                <div class="stat-number">{session_stats['count']}</div>
                <div>总 Session</div>
            </div>
        </div>
        {"<p>Session 列表: " + ", ".join(session_stats['files'][-5:]) + "</p>" if session_stats['files'] else "<p>暂无 Session 记录</p>"}
    </div>
    
    <div class="footer">
        <p>生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
        <p>OpenClaw State Externalization</p>
    </div>
</body>
</html>
"""
        
        output_file = Path(output_path)
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(html)
        
        return str(output_file.absolute())


def main():
    import argparse
    
    parser = argparse.ArgumentParser(description='状态可视化工具')
    parser.add_argument('--dir', default='.', help='项目目录')
    parser.add_argument('--format', choices=['console', 'html'], default='console',
                        help='输出格式')
    parser.add_argument('--output', default='state-report.html', help='HTML 输出路径')
    
    args = parser.parse_args()
    
    visualizer = StateVisualizer(args.dir)
    
    if args.format == 'console':
        print(visualizer.generate_console_report())
    else:
        output_path = visualizer.generate_html_report(args.output)
        print(f"✅ HTML 报告已生成: {output_path}")
        print(f"💡 在浏览器中打开查看: file://{output_path}")


if __name__ == "__main__":
    main()

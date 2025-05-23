import { createTool } from '@mastra/core/tools';
import { z } from 'zod';
import { execSync } from 'child_process';
import path from 'path';
import { writeFileSync, unlinkSync } from 'fs';

const WORKSPACE_ROOT = path.resolve(
  import.meta.dirname,
  '..',
  '..',
  '..',
  'workspace'
);

export const bashTool = createTool({
  id: 'bash-tool',
  description:
    'Execute bash scripts. The operating system is mac. Script is executed in the workspace root. Godot commands are available as `godot --version`',
  inputSchema: z.object({
    script: z.string().describe('Bash script to execute.'),
  }),
  outputSchema: z.object({
    stdout: z.string(),
    stderr: z.string(),
    exitCode: z.number(),
  }),
  async execute({ context }) {
    const { script } = context;
    try {
      const scriptPath = path.join(WORKSPACE_ROOT, 'script.sh');
      writeFileSync(scriptPath, script, 'utf-8');
      // Add Godot to PATH for this subprocess
      const godotPath = path.join(WORKSPACE_ROOT, 'Godot.app/Contents/MacOS');
      const currentPath = process.env.PATH || '';
      const newPath = `${godotPath}:${currentPath}`;

      const result = execSync('bash script.sh', {
        encoding: 'utf-8',
        cwd: WORKSPACE_ROOT,
        env: {
          ...process.env,
          PATH: newPath,
        },
      });
      unlinkSync(scriptPath);
      return {
        stdout: result,
        stderr: '',
        exitCode: 0,
      };
    } catch (error) {
      return {
        stdout: '',
        stderr: (error as Error).message,
        exitCode: 1,
      };
    }
  },
});

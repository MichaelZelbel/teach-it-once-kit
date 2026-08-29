#!/usr/bin/env node
/* prompt-harvest.js - the one thing that starts a prompt harvest, on any machine.
 *
 * This is the program the book means when it says "a program fills it". It runs once a day,
 * reads the conversation logs your AI tools keep on this computer, and writes the human turns
 * into prompts/archive/ inside your hub. The installer puts it on this machine and schedules
 * it; you never run it by hand. What it writes and what it refuses to write: hub-prompt-archive
 * next to this file, and prompts/README.md in your hub.
 *
 * WHY THIS FILE EXISTS. The harvester itself was fine and had been for a month. What was
 * broken was every way of starting it:
 *
 *   1. The only trigger was a Claude Code SessionEnd hook, and it ran `python`. There is no
 *      command called `python` on Debian, only `python3`. So on the server the hook ran, the
 *      command was not found, the hook reported nothing, and no prompt was ever harvested.
 *   2. A SessionEnd hook fires when a human ends a session in this folder. A laptop can go a
 *      fortnight without one while still writing session logs every day from other folders.
 *   3. Nothing pushed. A harvest on a machine nobody commits from stays on that machine, so
 *      the whole point (any AI, any machine, one searchable archive) never happened.
 *
 * So the trigger is not one mechanism, it is one PROGRAM with several callers: the daily
 * schedule the installer sets up on this computer, and a session-end hook as a bonus for long
 * sessions. They all land here, so there is one behaviour to fix and one place to fix it.
 *
 * Node, not Python, for one reason: node is already needed by the assistant this is installed
 * beside, and the interpreter this has to find on Windows is the very thing that was broken.
 * Finding python is now this program's job and it says so out loud when it cannot.
 *
 * Usage (the schedule does this for you; these are for proving something by hand):
 *   hub-prompt-harvest              harvest, commit, pull, push. Quiet unless something is wrong.
 *   hub-prompt-harvest --verbose    say what happened
 *   hub-prompt-harvest --no-push    harvest and commit only
 *   hub-prompt-harvest --once-a-day do nothing if it already ran today on this computer
 */

'use strict';
const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');

const ARGS = process.argv.slice(2);
const VERBOSE = ARGS.includes('--verbose') || ARGS.includes('-v');
const NO_PUSH = ARGS.includes('--no-push');
const ONCE_A_DAY = ARGS.includes('--once-a-day');
const STAMP = path.join(os.homedir(), '.hub', 'prompt-harvest-last');

/* Per-device non-secret overrides, the same file scripts/secrets.{sh,ps1} read. Loaded here
 * because cron and a session-end hook get almost no environment, and the one variable that
 * matters is HUB_MACHINE: without it a rented server files its prompts under its hosting
 * name, which tells you nothing when you go looking for where a prompt came from. */
(function loadDeviceEnv() {
  const p = path.join(os.homedir(), '.hub', 'device.env');
  let txt = '';
  try { txt = fs.readFileSync(p, 'utf8'); } catch (_) { return; }
  for (const line of txt.split(/\r?\n/)) {
    const m = /^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$/.exec(line.replace(/^\s*export\s+/, ''));
    if (!m || /^\s*#/.test(line)) continue;
    if (!process.env[m[1]]) process.env[m[1]] = m[2].trim().replace(/^["']|["']$/g, '');
  }
})();

/* WHERE IS THE HUB? This program is INSTALLED on the computer, like your assistant is, rather
 * than kept inside the folder it writes to. That is deliberate: your hub is meant to be a
 * folder of text files you can read, and a Node program sitting in it would be the first thing
 * in there that is not one. It also means this cannot simply look one folder up to find the
 * hub, so it asks, in order:
 *
 *   1. HUB_DIR, which the installer writes into ~/.hub/device.env when it wires this machine.
 *      This is the answer in every normal case, and it is why nothing here has to guess.
 *   2. The usual places, for a hub that was moved or made by hand.
 *   3. The folder above this file, which is the right answer only when the program IS living
 *      inside a hub. Kept so an older setup keeps working after an update.
 *
 * If none of them holds a hub, that is said out loud rather than harvesting into thin air. */
/* WHAT MAKES A FOLDER A HUB, and why this is not one folder name.
 *
 * Until 2026-08-29 this asked one question: does it contain `memory/`. On 2026-08-21 the hub
 * renamed that folder to `observations/` and deleted the old name, and every machine stopped
 * harvesting the same day: the work PC, the server and the laptop all went quiet within a day
 * of each other and nothing said so, because the only place this failure is written down is a
 * warning on the standard error of a session-end hook nobody reads. It was found eight days
 * later, by hand.
 *
 * Two things made that possible and both are fixed here. The first is that a single hardcoded
 * folder name is a dependency on a layout the hub is allowed to change, so the question is now
 * asked of several names, plus the file where a hub declares its own folders. The second is
 * worse: the starter hub this kit INSTALLS ships `observations/` and no `memory/`, so the
 * harvester could not find the hub the kit itself had just created. It was broken for every new
 * reader on day one, and the suite could not see it because the fixture built a `memory/` of its
 * own. test-prompt-archive.sh now builds the layout the kit really ships.
 *
 * An explicitly set HUB_DIR is now believed rather than second-guessed. Michael's work PC had
 * HUB_DIR=C:\hub set correctly in ~/.hub/device.env throughout, and this function overruled it
 * on the strength of a missing folder. If someone has said where their hub is, that is the
 * answer; guessing is only for when nobody has said. */
const HUB_MARKERS = ['observations', 'profile', 'rules', 'prompts', 'memory'];
function looksLikeHub(p) {
  try {
    if (!p) return false;
    if (fs.existsSync(path.join(p, 'scripts', 'config', 'hub-layout.json'))) return true;
    return HUB_MARKERS.some(function (d) {
      try { return fs.statSync(path.join(p, d)).isDirectory(); } catch (_) { return false; }
    });
  } catch (_) { return false; }
}
function findHub() {
  /* Said out loud beats inferred. Only the shape of the answer is checked: a HUB_DIR that
   * names something which is not a directory at all is a typo worth reporting, not obeyed. */
  const told = process.env.HUB_DIR;
  if (told) {
    try { if (fs.statSync(told).isDirectory()) return path.resolve(told); } catch (_) {}
    warn('HUB_DIR is set to "' + told + '", which is not a folder I can open. Fix it in '
       + '~/.hub/device.env, or unset it and I will look in the usual places.');
  }
  const cands = [path.join(os.homedir(), 'hub'), '/root/hub', 'C:\\hub'];
  for (const c of cands) if (looksLikeHub(c)) return path.resolve(c);
  const up = path.resolve(__dirname, '..');
  return looksLikeHub(up) ? up : null;
}
const HUB = findHub();

/* The collector is the other half of this pair and travels with it, so look next to this file
 * first. The two fallbacks are for a hub that still carries its own copy from before this
 * program was installed rather than kept in the folder. */
function findCollector() {
  const names = [path.join(__dirname, 'hub-prompt-archive')];
  if (HUB) {
    names.push(path.join(HUB, 'agents', 'hub-cli', 'hub-prompt-archive'));
    names.push(path.join(HUB, 'bin', 'hub-prompt-archive'));
  }
  for (const n of names) { try { if (fs.statSync(n).isFile()) return n; } catch (_) {} }
  return null;
}

function say(msg) { if (VERBOSE) process.stdout.write(msg + '\n'); }
function warn(msg) { process.stderr.write('prompt-harvest: ' + msg + '\n'); }

function run(cmd, args, opts) {
  return spawnSync(cmd, args, Object.assign({ cwd: HUB, encoding: 'utf8', timeout: 15 * 60 * 1000, windowsHide: true }, opts || {}));
}

/* A python that exists AND runs. `py` on Windows and `python3` on Linux are the usual
 * answers, but Windows also ships a fake `python` that only opens the Microsoft Store, so
 * "the command resolved" is not the same as "the command works". Each candidate is asked to
 * print its version before it is trusted. */
function findPython() {
  const cands = [[process.env.HUB_PYTHON, []], ['python3', []], ['python', []], ['py', ['-3']]];
  for (const [cmd, pre] of cands) {
    if (!cmd) continue;
    const r = run(cmd, pre.concat(['-c', 'print(1)']), { timeout: 30000 });
    if (r && r.status === 0 && String(r.stdout || '').trim() === '1') return { cmd, pre };
  }
  return null;
}

function today() { return new Date().toISOString().slice(0, 10); }

function alreadyRanToday() {
  try { return fs.readFileSync(STAMP, 'utf8').trim().slice(0, 10) === today(); } catch (_) { return false; }
}
function stampNow() {
  try {
    fs.mkdirSync(path.dirname(STAMP), { recursive: true });
    fs.writeFileSync(STAMP, new Date().toISOString() + '\n');
  } catch (_) { /* a stamp we cannot write only means we harvest more often than needed */ }
}

function main() {
  /* `--where` answers the one question this program used to get wrong in silence: which folder
   * do you think my hub is? It writes nothing and changes nothing, so it is safe to run at any
   * time, it is what the suite uses to test hub-finding without starting a real harvest, and it
   * is the first thing to run when prompts stop appearing in the archive. */
  if (ARGS.includes('--where')) {
    if (HUB) { process.stdout.write(HUB + '\n'); return 0; }
    warn('I could not find your hub folder. Set HUB_DIR in ~/.hub/device.env to the folder '
       + 'your hub is in, or run the installer again.');
    return 1;
  }

  if (ONCE_A_DAY && alreadyRanToday()) { say('already harvested today'); return 0; }

  if (!HUB) {
    warn('I could not find your hub folder, so there is nowhere to file what you have typed. '
       + 'Set HUB_DIR in ~/.hub/device.env to the folder your hub is in, or run the installer again.');
    return 1;
  }
  const collector = findCollector();
  if (!collector) {
    warn('the collector (hub-prompt-archive) is not beside this program or in your hub, so '
       + 'nothing can be archived. Run the installer again to put it back.');
    return 1;
  }

  const py = findPython();
  if (!py) {
    // Loud, because this is not a quiet skip: this machine's prompts are being lost.
    warn('no working python on this machine, so its prompts CANNOT be archived. Install Python 3 or set HUB_PYTHON.');
    return 1;
  }

  /* Pull first. The harvester skips a prompt whose exact text is already in ANY machine's
   * file, so a current clone is what stops two machines archiving the same thing twice. */
  const pulled = run('git', ['pull', '--rebase', '--autostash', 'origin', 'main']);
  if (!pulled || pulled.status !== 0) say('pull failed (offline is fine): ' + String((pulled && pulled.stderr) || '').slice(0, 200));

  const h = run(py.cmd, py.pre.concat([collector, '--hub', HUB, 'archive']));
  if (!h || h.status !== 0) {
    warn('the harvester failed: ' + String((h && (h.stderr || h.stdout)) || 'no output').slice(0, 400));
    return 1;
  }
  say(String(h.stdout || '').trim());
  stampNow();

  /* Commit ONLY the archive path. `git commit -- <path>` ignores whatever else is staged, so
   * a harvest that fires while you are mid-edit can never carry your unfinished work into a
   * commit you did not write. */
  const rel = path.join('prompts', 'archive');
  run('git', ['add', '--', rel]);
  const dirty = run('git', ['status', '--porcelain', '--', rel]);
  if (!String((dirty && dirty.stdout) || '').trim()) { say('nothing new to commit'); return 0; }

  const machine = (process.env.HUB_MACHINE || os.hostname()).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
  const c = run('git', ['commit', '-m', 'Archive the prompts typed on ' + machine, '--', rel]);
  if (!c || c.status !== 0) { warn('commit failed: ' + String((c && (c.stderr || c.stdout)) || '').slice(0, 200)); return 1; }
  say('committed');

  if (NO_PUSH) return 0;
  let p = run('git', ['push', 'origin', 'main']);
  if (!p || p.status !== 0) {
    // Somebody else pushed while we worked. Rebase onto them and try once more; a second
    // failure is left alone, because the next run picks the commit up anyway.
    run('git', ['pull', '--rebase', '--autostash', 'origin', 'main']);
    p = run('git', ['push', 'origin', 'main']);
  }
  if (!p || p.status !== 0) { say('push did not go through; the commit is local and the next run will carry it'); return 0; }
  say('pushed');
  return 0;
}

process.exit(main());

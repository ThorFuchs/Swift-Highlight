import { WASI } from 'node:wasi';
import { readFile } from 'node:fs/promises';

const file = process.argv[2];
if (!file) throw new Error('Usage: node run-wasi.mjs path/to/WASISmoke.wasm');
const wasi = new WASI({ version: 'preview1', args: ['WASISmoke'], env: {}, preopens: {}, returnOnExit: true });
const module = await WebAssembly.compile(await readFile(file));
const instance = await WebAssembly.instantiate(module, { wasi_snapshot_preview1: wasi.wasiImport });
const result = wasi.start(instance);
if (result !== 0) process.exitCode = result;

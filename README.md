# winnow-fuzz

Deterministic fuzz harness for [Winnow](https://github.com/winnowwallet/winnow)'s
parsing surface: PSBT, descriptors, transactions, blocks, wire messages,
framing, filters, addresses, and import bundles — everything that accepts
bytes from outside the wallet.

It consumes only winnow's public library products, so what gets fuzzed is
exactly what an attacker can reach. Runs are seeded and fully reproducible:
a failure is a seed and an iteration count, never a lost artifact.

```sh
swift run --configuration release WinnowFuzz \
  --iterations 25000 --seed 0x57494e4e4f575055 --max-input 65536 \
  --artifact-dir /tmp/fuzz-artifacts
```

By default the build tracks winnow `main`. Set `WINNOW_PATH=/path/to/winnow`
to fuzz a local checkout instead — winnow's `security.yml` does this to fuzz
the exact commit under test, plain on every pull request and under address
and thread sanitizers on a weekly rotating corpus.

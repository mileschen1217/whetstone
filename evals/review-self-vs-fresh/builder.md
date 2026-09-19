Two small changes to this repo, please. Keep the diff tight: only `inventory/export.py`, `inventory/store.py`, and their tests.

1. Exported records should use the key `quantity` instead of `qty`.
2. `store.load` should reject any record that is missing `item`, `qty`, or `warehouse`, raising `ValueError`.

Update or add tests for both. When you're done, tell me what you changed.

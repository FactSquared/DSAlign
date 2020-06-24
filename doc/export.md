## Export

After files got successfully aligned, one would possibly want to export the aligned utterances
as machine learning training samples.

This is where the export tool `bin/export.sh` comes in.

### Step 1 - Reading the input

The exporter takes either a single audio file (`--audio`) 
plus a corresponding `.aligned` file (`--aligned`) or a series
of such pairs from a `.catalog` file (`--catalog`) as input.

All of the following computations will be done on the joined list of all aligned
utterances of all input pairs.

### Step 2 - (Pre-) Filtering

The parameter `--filter <EXPR>` allows to specify a Python expression that has access
to all data fields of an aligned utterance (as can be seen in `.aligned` file entries).

This expression is now applied to each aligned utterance and in case it returns `True`,
the utterance will get excluded from all the following steps. 
This is useful for excluding utterances that would not work as input for the planned
training or other kind of application.

### Step 3 - Computing quality

As with filtering, the parameter `--criteria <EXPR>` allows for specifying a Python 
expression that has access to all data fields of an aligned utterance.

The expression is applied to each aligned utterance and its numerical return 
value is assigned to each utterance as `quality`.

### Step 4 - De-biasing

This step is to (optionally) exclude utterances that would otherwise bias the data
(risk of overfitting).

For each `--debias <META DATA TYPE>` parameter the following procedure is applied:
1. Take the meta data type (e.g. "name") and read its instances (e.g. "Alice" or "Bob")
from each utternace and group all utterances accordingly
(e.g. a group with 2 utterances of "Alice" and a group with 15 utterances of "Bob"...)
2. Compute the standard deviation (`sigma`) of the instance-counts of the groups
3. For each group: If the instance-count exceeds `sigma` times `--debias-sigma-factor <FACTOR>`:
    - Drop the number of exceeding utterances in order of their `quality` (lowest first)
    
### Step 5 - Partitioning

Training sets are often partitioned into several quality levels.

For each `--partition <QUALITY:PARTITION>` parameter (ordered descending by `QUALITY`):
If the utterance's `quality` value is greater or equal `QUALITY`, assign it to `PARTITION`.

Remaining utterances are assigned to partition `other`.

### Step 6 - Splitting

Training sets (actually their partitions) are typically split into sets `train`, `dev` 
and `test` ([explanation](https://en.wikipedia.org/wiki/Training,_validation,_and_test_sets)).

This can get automated through parameter `--split` which will let the exporter split each
partition (or the entire set) accordingly.

Parameter `--split-field` allows for specifying a meta data type that should be considered 
atomic (e.g. "speaker" would result in all utterances of a speaker 
instance - like "Alice" - to end up in one sub-set only). This atomic behavior will also hold
true across partitions.

### Step 7 - Output

For each partition/sub-set combination the following is done:
 - Construction of a `name` (e.g. `good-dev` will represent the validation set of partition `good`).
 - Writing all utterance audio fragments (as `.wav` files) into a sub-directory of `--target-dir <DIR>`
 named `name` (using parameters `--channels <N>` and `--rate <RATE>`).
 - Writing an utterance list into `--target-dir <DIR>` named `name.(json|csv)` dependent on the
 output format specified through `--format <FORMAT>`
 
### Additional functionality

Using `--dry-run` one can avoid any writing and get a preview on set-splits and so forth
(`--dry-run-fast` won't even load any sample).

`--force` will force overwriting of samples and list files.

`--workers <N>` allows for specifying the number of parallel workers.
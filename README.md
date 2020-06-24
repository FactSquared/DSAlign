# DSAlign
DeepSpeech based forced alignment tool

## Installation

It is recommended to use this tool from within a virtual environment.
There is a script for creating one with all requirements in the git-ignored dir `venv`:

```bash
$ bin/createenv.sh
$ ls venv
bin  include  lib  lib64  pyvenv.cfg  share
```

`bin/align.sh` will automatically use it.

## Prerequisites

### Language specific data

Internally DSAlign uses the [DeepSpeech](https://github.com/mozilla/DeepSpeech/) STT engine.
For it to be able to function, it requires a couple of files that are specific to 
the language of the speech data you want to align.
If you want to align English, there is already a helper script that will download and prepare
all required data:

```bash
$ bin/getmodel.sh 
[...]
$ ls models/en/
alphabet.txt  lm.binary  output_graph.pb  output_graph.pbmm  output_graph.tflite  trie
```

### Example data

There is also a script for downloading and preparing some public domain speech and transcript data.

```bash
$ bin/gettestdata.sh
$ ls data
test1  test2
```

## Using the tool

```bash
$ bin/align.sh --help
[...]
```

### Alignment using example data

```bash
$ bin/align.sh --audio data/test1/audio.wav --script data/test1/transcript.txt --aligned data/test1/aligned.json --tlog data/test1/transcript.log
```

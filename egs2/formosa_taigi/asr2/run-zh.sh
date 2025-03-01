#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

all_set=all
train_set=train
valid_set=eval
test_sets="eval test"

asr_config=conf/train_asr_branchformer.yaml
inference_config=conf/decode_asr_branchformer.yaml

lm_config=conf/train_lm_transformer.yaml
use_lm=true
use_wordlm=false

# speed perturbation related
# (train_set will be "${train_set}_sp" if speed_perturb_factors is specified)
speed_perturb_factors="0.9 1.0 1.1"

./asr.sh \
    --nj 64 \
    --inference_nj 64 \
    --ngpu 8 \
    --lang zh \
    --audio_format wav \
    --feats_type raw \
    --token_type bpe \
    --nbpe 6888 \
    --use_lm ${use_lm}                                 \
    --use_word_lm ${use_wordlm}                        \
    --lm_config "${lm_config}"                         \
    --asr_config "${asr_config}"                       \
    --inference_config "${inference_config}"           \
    --train_set "${train_set}"                         \
    --valid_set "${valid_set}"                         \
    --test_sets "${test_sets}"                         \
    --speed_perturb_factors "${speed_perturb_factors}" \
    --asr_speech_fold_length 1024 \
    --asr_text_fold_length 300 \
    --lm_fold_length 300 \
    --lm_train_text "data/${train_set}/text downloads/sentences-hanlo-cleaned-index.txt downloads/words-hanlo-cleaned-index.txt" "$@" \
    --bpe_train_text "data/${train_set}/text downloads/sentences-hanlo-cleaned-index.txt downloads/words-hanlo-cleaned-index.txt" "$@" \
    --feats_normalize uttmvn \
    --asr_args "--max_epoch 100" \
    --local_data_opts "--lang zh"
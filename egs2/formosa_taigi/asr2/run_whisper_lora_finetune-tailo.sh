#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

train_set=train
valid_set=dev
test_sets=test

asr_config=conf/tuning/train_asr_whisper_small_lora_finetune.yaml
#asr_config=conf/tuning/train_asr_whisper_medium_lora_finetune.yaml
#asr_config=conf/tuning/train_asr_whisper_large_lora_finetune_en.yaml
inference_config=conf/tuning/decode_asr_whisper_noctc_beam10.yaml

lm_config=conf/train_lm_transformer.yaml
use_lm=false
use_wordlm=false

# speed perturbation related
# (train_set will be "${train_set}_sp" if speed_perturb_factors is specified)
speed_perturb_factors="0.9 1.0 1.1"

./asr.sh \
    --nj 192 \
    --ngpu 2 \
    --gpu_inference false \
    --inference_nj 32 \
    --lang en \
    --token_type whisper_multilingual \
    --feats_normalize "" \
    --audio_format "wav" \
    --feats_type raw \
    --use_lm ${use_lm}                                 \
    --use_word_lm ${use_wordlm}                        \
    --lm_config "${lm_config}"                         \
    --cleaner whisper_basic                            \
    --asr_config "${asr_config}"                       \
    --inference_config "${inference_config}"           \
    --train_set "${train_set}"                         \
    --valid_set "${valid_set}"                         \
    --test_sets "${test_sets}"                         \
    --speed_perturb_factors "${speed_perturb_factors}" \
    --asr_speech_fold_length 1024 \
    --asr_text_fold_length 300 \
    --lm_fold_length 300 \
    --lm_train_text "data/${train_set}/text" "$@" \
    --asr_args "--max_epoch 3" \
    --local_data_opts "--lang tailo"

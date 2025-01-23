#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}
help_message=$(cat << EOF
Usage: $0
EOF
)
SECONDS=0

# Data preparation related
data_url=/share/nas167/teinhonglo/github_repo/sandi2025-challenge/data-kaldi

log "$0 $*"


. ./utils/parse_options.sh

. ./db.sh
. ./path.sh
. ./cmd.sh

for dataset in train train_fluent dev dev_fluent dev_subset; do
    utils/fix_data_dir.sh $data_url/$dataset
    utils/copy_data_dir.sh $data_url/$dataset data/$dataset
done

utils/subset_data_dir_tr_cv.sh \
    --cv-spk-percent 30 \
    data/dev \
    data/dev_cv \
    data/dev_test

log "Successfully finished. [elapsed=${SECONDS}s]"

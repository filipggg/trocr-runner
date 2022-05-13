#!/bin/bash

export BSZ=16

BSZ=$(yq -r '.params."prediction-batch-size"' gonito.yaml)
BEAM=$(yq -r '.params.beam' gonito.yaml)

. common.sh

MODEL=${SAVE_PATH}/checkpoint_best.pt

if [[ "$ARCH" == "small" ]]
then
    BPE_OPTS="--bpe sentencepiece --sentencepiece-model ./unilm/trocr/unilm3-cased.model --dict-path-or-url https://layoutlm.blob.core.windows.net/trocr/dictionaries/unilm3.dict.txt"
else
    BPE_OPTS="--bpe gpt2 --decoder-pretrained roberta"
fi

DATA=$(mktemp -d -t trocrrunnerXXXXXX)

RESULT_PATH=${DATA}/results

ln -s $CHALLENGE_DIR/images $DATA/image

cat | perl -pne 'chomp; $_.="\tX\n"' > $DATA/gt_test.txt

fairseq-generate \
    --data-type STR --user-dir unilm/trocr --task text_recognition --input-size 384 \
    --beam ${BEAM} --scoring cer2 --gen-subset test --batch-size ${BSZ} \
    --path ${MODEL} --results-path ${RESULT_PATH} --preprocess DA2 \
    $BPE_OPTS \
    --fp16 \
            ${DATA}

egrep '^D' < ${RESULT_PATH}/generate-test.txt | cut -f 3

#!/bin/bash -e

: ${MODEL_CACHE=~/.cache/trocr-runner/models}

mkdir -p $MODEL_CACHE

. common.sh

MODEL_PATH=${MODEL_CACHE}/${MODEL_NAME}.pt

if [[ ! -r "$MODEL_PATH" ]]
then
    wget -O "$MODEL_PATH" https://layoutlm.blob.core.windows.net/trocr/model_zoo/fairseq/${MODEL_NAME}.pt
fi

: ${LOG_DIR=log_$MODEL_NAME}
mkdir -p ${LOG_DIR}

if [[ "$TROCR_DATA_DIR" == ""  ]]
then
    echo >&2 "TODO EXITING"
    exit 1
fi

BSZ=$(yq -r '.params."batch-size"' gonito.yaml)
valid_BSZ=$(yq -r '.params."validation-batch-size"' gonito.yaml)
MAX_EPOCHS=$(yq -r '.params."max-epochs"' gonito.yaml)
PATIENCE=$(yq -r .params.patience gonito.yaml)
LR=$(yq -r .params.lr gonito.yaml)
WEIGHT_DECAY=$(yq -r '.params."weight-decay"' gonito.yaml)
WARMUP_UPDATES=$(yq -r '.params."warmup-updates"' gonito.yaml)
WARMUP_INIT_LR=$(yq -r '.params."warmup-init-lr"' gonito.yaml)

if [[ "$ARCH" == "small" ]]
then
    BPE_OPTS="--bpe sentencepiece --sentencepiece-model ./unilm/trocr/unilm3-cased.model --decoder-pretrained unilm"
else
    BPE_OPTS="--bpe gpt2 --decoder-pretrained roberta"
fi

# it would be better to use fairseq-hydra-train, but trocr is using old legacy params...

fairseq-train \
    --data-type STR --user-dir unilm/trocr --task text_recognition \
    --arch trocr_${ARCH} \
    --no-epoch-checkpoints \
    --seed 1111 --optimizer adam --lr ${LR} --lr-scheduler inverse_sqrt \
    --warmup-init-lr ${WARMUP_INIT_LR} --warmup-updates ${WARMUP_UPDATES} --weight-decay ${WEIGHT_DECAY} --log-format tqdm \
    --log-interval 10 --batch-size ${BSZ} --batch-size-valid ${valid_BSZ} --save-dir ${SAVE_PATH} \
    --tensorboard-logdir ${LOG_DIR} --max-epoch ${MAX_EPOCHS} --patience ${PATIENCE} --ddp-backend legacy_ddp \
    --num-workers 1 --preprocess DA2 --update-freq 1 \
    $BPE_OPTS \
    --finetune-from-model ${MODEL_PATH} --fp16 \
    ${TROCR_DATA_DIR}

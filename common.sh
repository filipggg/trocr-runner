
: ${CHALLENGE_DIR=$(pwd)/../..}
SAVE_PATH=$CHALLENGE_DIR/models

GONITO_YAML=gonito.yaml

if [[ "$TROCR_DATA_DIR" == ""  ]]
then
    GONITO_YAML=$CHALLENGE_DIR/gonito.yaml
fi

MODEL_NAME=$(yq -r .params.model $GONITO_YAML)
FINE_TUNING=$(yq -r ".params.fine-tuning" $GONITO_YAML)

: ${MODEL_CACHE=~/.cache/trocr-runner/models}
mkdir -p $MODEL_CACHE

MODEL_PATH=${MODEL_CACHE}/${MODEL_NAME}.pt

ARCH=${MODEL_NAME#trocr-}
ARCH=${ARCH%-*}


if [[ "$CUDA_VISIBLE_DEVICES" == "" ]]
then
    echo >&2 "CUDA_VISIBLE_DEVICES MUST BE SET"
    exit 1
fi


MODEL_NAME=$(yq -r .params.model gonito.yaml)

ARCH=${MODEL_NAME#trocr-}
ARCH=${ARCH%-*}

: ${CHALLENGE_DIR=$(pwd)/../..}
SAVE_PATH=$CHALLENGE_DIR/models

if [[ "$CUDA_VISIBLE_DEVICES" == "" ]]
then
    echo >&2 "CUDA_VISIBLE_DEVICES MUST BE SET"
    exit 1
fi

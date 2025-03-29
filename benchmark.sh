#!/bin/bash

models=(

    # "tinyllama:1.1b"   # 0.6GB
    # "smollm:1.7b"      # 0.9GB
    # "deepscaler:1.5b"  # 3.6GB
    # "gemma3:4b"        # 3.3GB
    # "smollm2:1.7b"     # 1.7GB
    # "llama3.2:3b"      # 2.0GB
    # "llama3.1:8b"      # 4.9GB
    # "command-r7b:7b"   # 5.1GB

    "mistral-nemo:12b"

)

getOllama() {
    echo "Checking if Ollama is installed..."
    ollama --version &>/dev/null && echo "Ollama is already installed." || {
        echo "Ollama is not installed. Installing now..."
        curl -fsSL https://ollama.com/install.sh | sh
        echo "Ollama installation complete."
    }
}

getModels() {

    echo "Pulling models. This may take some time depending on the model size..."

    for model in "${models[@]}"; do
        echo "Installing model: $model"
        ollama pull "$model" && echo "Model $model installed successfully." || echo "Failed to install model $model."
    done

    echo "All model installation attempts are complete."

}

checkSpeed() {

    words=(
        "conundrum"
        "cynical"
        "satire"
        "euphism"
    )

    for model in "${models[@]}"; do
        for word in "${words[@]}"; do

            prompt="define *$word* in JSON format like this : {'word':'$word','definitions':[{'partOfSpeech':'noun/verb','definition':'definition1','example':'example1'}, ... ],'synonyms','antonyms'} without any extra info. No fields should be empty."

            start_time=$(date +%s)
            response=$(ollama run "$model" "$prompt")
            elapsed_time=$(($(date +%s) - start_time))
            echo "$model, $elapsed_time second(s), $word"

            mkdir -p "./results/$word"
            echo "$response" >"./results/$word/output_$model.md"
        done
    done

}

# getOllama
# getModels
checkSpeed

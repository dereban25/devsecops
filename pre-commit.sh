#!/bin/bash
command -v gitleaks >/dev/null 2>&1 || { 
    echo >&2 "Gitleaks not found. I will install gitleaks...";
    
    # Installed gitleaks in the operating system
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -sSfL https://github.com/zricethezav/gitleaks/releases/latest/download/gitleaks-linux-amd64.tar.gz | tar -xz
        export PATH=$(pwd):$PATH
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.16.4/gitleaks_8.16.4_darwin_arm64.tar.gz | tar -xz
        export PATH=$(pwd):$PATH
    else
        echo >&2 "Couldn't install gitleaks. The operating system is not supported."; 
        exit 1;
    fi
}


ENABLE=$(git config --bool hooks.gitleaks-enable)

# Check if the enable option is enabled
if [ "$ENABLE" != "true" ]; then
    echo "Advance: Re-verification of the visibility of secrets in the code of the code. To enable, type the command: git config hooks.gitleaks-enable true"
    exit 0
fi


gitleaks detect


if [ $? -eq 0 ]; then
    echo "Pardon: Found the secret of the code. I resigned the committee."
    exit 1
fi

exit 0


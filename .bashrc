if [ -f "${HOME}/local/bash-build/bash-4.2/bash" ] ; then
    if [ $(uname -m) = "i686" ] && [ "${0}" != "/home/takushima/local/bash-build/bash-4.2/bash" ] ; then
        exec ~/local/bash-build/bash-4.2/bash
    fi
fi
export PATH="$PYENV_ROOT/shims:$PATH"
#if [ $(uname -m) != "i686" ] ; then
#    export PATH="${HOME}/.brew/bin:${PATH}"
#fi
export HOMEBREW_MAKE_JOBS="4"
export PATH="${HOME}/local/bin:${PATH}"
export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
export LESSCHARSET=utf-8
export LANG=ja_JP.UTF-8

#alias
alias ls='ls --color -Fh'
alias ll='ls -l'
alias la='ls -a'
alias e='emacs'
alias n='nvidia-smi -l 1'
alias mtoken='~/moses/scripts/tokenizer/tokenizer.perl'
alias mlower='~/moses/scripts/tokenizer/lowercase.perl'
alias mclear=' ~/moses/scripts/training/clean-corpus-n.perl'
alias bleu='~/mosesdecoder/scripts/generic/multi-bleu.perl'
alias bleu_mde='~/mosesdecoder/scripts/generic/multi-bleu.perl ~/M1/resource/multi30k-dataset/dataset/data/task1/tok/test_2016_flickr.lc.norm.tok.de < '
alias CUDA='CUDA_VISIBLE_DEVICES='
alias grep='grep -E --color=always'
alias jsonprint='python -m json.tool'
alias meval='${HOME}/local/multeval/multeval'
alias meval_mde='${HOME}/local/multeval/multeval eval --refs ${HOME}/M1/resource/multi30k-dataset/dataset/data/task1/tok/test_2016_flickr.lc.norm.tok.de --meteor.language de'
alias meval_mfr='${HOME}/local/multeval/multeval eval --refs ${HOME}/M1/resource/multi30k-dataset/dataset/data/task1/tok/test_2016_flickr.lc.norm.tok.fr --meteor.language fr'
alias meval_mcs='${HOME}/local/multeval/multeval eval --refs ${HOME}/M1/resource/multi30k-dataset/dataset/data/task1/tok/test_2016_flickr.lc.norm.tok.cs --meteor.language cs'

#source ~/local/share/bash-completion/bash_completion

#tool
export PATH="${HOME}/local/MiniBatch/bin:${PATH}"
export PATH="${HOME}/local/fastbpe:${PATH}"
export PATH="${HOME}/local/apache-maven-3.6.3/bin:${PATH}"
#export PATH="${HOME}/local/de9uch1/fastBPE:${PATH}"
export PATH="${HOME}/github/apex:${PATH}"

#mlenv
export PATH="${HOME}/local/mlenv/bin:${PATH}"
export MLENV_ROOT="$HOME/env.d"
export MLENV_EXPDIR="$HOME/exp"
alias ml='mlenv -l'
alias me='mlenv -e'

#git
alias gita='git add'
alias gitc='git commit -m'
alias gitl='git log'
alias gits='git status'


#pycache削除
export PYTHONDONTWRITEBYTECODE=1 

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS="--height 30% --layout reverse --border --color 16"
fcd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
                         -o -type d -print 2> /dev/null | fzf +m) &&
    cd "$dir"
}
fc() {
    local dir
    cd ~
    dir=$(find ${1:-.} -path '*/\.*' -prune \
                         -o -type d -print 2> /dev/null | fzf +m) &&
    cd "$dir"
}
fe() {
    local dir
    file=$(find ${1:-.} -path '*/\.*' -prune \
                         -o -type f -print 2> /dev/null | fzf +m) &&
    emacs "$file"
}

## z
#. ~/local/z/z.sh

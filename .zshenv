# avoid calling compinit several times
# (this var here is read by /etc/zshrc on Ubuntu)
skip_global_compinit=1

if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

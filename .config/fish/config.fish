if status --is-login
	xinput set-prop 13 "Coordinate Transformation Matrix" 2.5 0 0 0 2.5 0 0 0 1 &
	primenote &
	/usr/lib/x86_64-linux-gnu/ukui-polkit/polkit-ukui-authentication-agent-1 &
	xrdb -merge ~/.Xresources &
end

starship init fish | source
set -U fish_greeting "🐟"

thefuck --alias fuck | source
# alias cat_orig="cat"
alias bcat="batcat"
alias neorgd="nvim -c 'Neorg workspace documents'"
alias neorgs="nvim -c 'Neorg workspace school'"
alias serial="sudo minicom -b 115200 -o -D"
alias ls="lsd"
alias fzfind="fzf --border=rounded --margin=1,3 --info=right --preview='batcat --color=alw
ays {} --style=plain' --preview-window=up,10"

source ~/Software/lscolors.csh

set NVM_DIR "([ -z "$XDG_CONFIG_HOME-" ] && printf %s "$HOME/.nvm" ||
printf %s "$XDG_CONFIG_HOME/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

zoxide init fish --cmd cd | source
# fzf --fish | source

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
set -gx MAMBA_EXE "/home/maxine/.micromamba/bin/micromamba"
set -gx MAMBA_ROOT_PREFIX "/home/maxine/micromamba"
$MAMBA_EXE shell hook --shell fish --root-prefix $MAMBA_ROOT_PREFIX | source
# <<< mamba initialize <<<

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/maxine/micromamba/bin/conda
	eval /home/maxine/micromamba/bin/conda "shell.fish" "hook" $argv | source
else
	if test -f "/home/maxine/micromamba/etc/fish/conf.d/conda.fish"
		. "/home/maxine/micromamba/etc/fish/conf.d/conda.fish"
	else
		set -x PATH "/home/maxine/micromamba/bin" $PATH
	end
end
# <<< conda initialize <<<



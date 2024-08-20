# ----- login shell commands -----
if status --is-login
	xinput set-prop 13 "Coordinate Transformation Matrix" 2.5 0 0 0 2.5 0 0 0 1 &
end

# ----- fish configuration -----
bind \cz 'fg 2>/dev/null; commandline -f repaint'

# ----- aliases -----

alias bcat="batcat"
alias neorgd="nvim -c 'Neorg workspace documents'"
alias neorgs="nvim -c 'Neorg workspace school'"
alias serial="sudo minicom -b 115200 -o -D"
alias ls="lsd"
alias la="lsd -a"
alias ll="lsd -l"
alias lla="lsd -la"
alias lt="lsd -t"
alias dots="dotbare fedit"
alias dot="dotbare"
alias fzfind="fzf --border=rounded --margin=1,3 --info=right --preview='batcat --color=always {} --style=plain' --preview-window=up,10 --query"
alias cam="git commit -am"

function fznvim 
	if test "$argv[1]" = "-h"
		echo (set_color -o)"fznvim" (set_color normal)(set_color -i)"[query]"(set_color normal)
		echo "Runs fzf and opens result in nvim, with optional query for fzf"
		return
	else if test "$argv[1]" != ""
		set -f fzf_result $(fzf --border=rounded --margin=1,3 --info=right --preview='batcat --color=always {} --style=plain' --preview-window=up,10 --query $argv)
	else 
		set -f fzf_result $(fzf --border=rounded --margin=1,3 --info=right --preview='batcat --color=always {} --style=plain' --preview-window=up,10)
	end
	if test "$fzf_result" != ""
		nvim $fzf_result
	else
		echo "Search Aborted"
	end
end

function fzls
	if test "$argv[1]" = "-h"
		echo (set_color -o)"fzls" (set_color normal)(set_color -i)"[directory] [query]"(set_color normal)
		echo "Runs fzf on ls's output of [directory] (defaults to cwd if not given) with optional query for fzf"
		return
	else if test "$argv[2]" != ""
		ls -1 --classic $argv[1] | fzf --query $argv[2]
	else
		ls -1 --classic $argv[1] | fzf
	end
end

function fzdot
	if test "$argv[1]" = "-h"
		echo (set_color -o)"fzdot" (set_color normal)(set_color -i)" [query]"(set_color normal)
		echo "Runs fzf on ls's output of ~/.config and opens result in nvim, with optional query for fzf"
		return
	else if test "$argv[1]" != ""
		set -f fzf_result $(find ~/.config/ | fzf --query $argv[1])
	else
		set -f fzf_result $(find ~/.config/ | fzf)
	end
	if test "$fzf_result" != ""
		nvim $fzf_result
	else
		echo "Search Aborted"
	end
end

function fzcd
	if test "$argv[1]" = "-h"
		echo (set_color -o)"fzcd" (set_color normal)(set_color -i)"[directory] "(set_color normal)
		echo "Runs fzf on ls's output of [directory] (defaults to cwd if not given) with optional query for fzf and cd's into it"
		return
	else if test "$argv[2]" != ""
		set -f fzf_result $(ls -1 --classic $argv[1] | fzf --query $argv[2])
	else
		set -f fzf_result $(ls -1 --classic $argv[1] | fzf)
	end
	cd $fzf_result
end

function lsgrep
	if test "$argv[2]" != ""
		ls -1 --classic $argv[1] | grep $argv[2]
	else
		ls $argv[1]
	end
end


# ----- program configuration loading -----

starship init fish | source
zoxide init fish --cmd cd | source
source ~/Software/lscolors.csh

set NVM_DIR "([ -z "$XDG_CONFIG_HOME-" ] && printf %s "$HOME/.nvm" ||
printf %s "$XDG_CONFIG_HOME/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

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


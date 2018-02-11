# .bashrc
#**************************************************************************************
#*
#*                            User specific aliases and functions
#*
#**************************************************************************************
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
#**************************************************************************************
#*
#*                            Source global definitions
#*
#**************************************************************************************
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
#**************************************************************************************
#*
#*                            Time Zone Setting
#*
#**************************************************************************************
TZ='Asia/Shanghai'; export TZ
#**************************************************************************************
#*
#*                            PS1 Settings
#*
#**************************************************************************************
# 0 off
# 1 highlight
# 4 underline
# 5 blink
# 7 white
# 8 invisible
#前景            背景             颜色
#---------------------------------------
#30               40              黑色
#31               41              紅色
#32               42              綠色
#33               43              黃色
#34               44              藍色
#35               45              紫紅色
#36               46              青藍色
#37               47              白色
alias myip='ifconfig | grep "inet addr:15" | sed -n "s/^\s*inet addr:\(\S*\).*$/\1/p"'
function getBranch()
{
	br=`git branch 2>/dev/null | grep "*"`
	if [ -z "$br" ]; then
		br="no branch"
	fi
	echo "${br/#\* /}"
}
if [ "$PS1" ]; then
	PS1='[\033[1;32;40m\u@\h($(myip)) `date +%Y-%m-%d\(%a\)` \t \w \033[1;37;41m<branch:$(getBranch)>\033[m]\n\\$ '
fi
#**************************************************************************************
#*
#*                            Shell Command
#*
#**************************************************************************************
alias ll='ls -al --color=auto'
alias la='ls -ah --color=auto'
alias lla='ls -alh --color=auto'
alias cgrep='grep -inr --exclude-dir=gen'
#**************************************************************************************
#*
#*                            Git Command
#*
#**************************************************************************************
alias gitlog='git log --pretty=format:"%h %ai %an<%ae>%s"'
alias gitwhat='git whatchanged --pretty=format:"%C(yellow)%h %ai %an<%ae>%s"'
alias gitdiff='git difftool -y -t vimdiff'
alias gittag='git describe --tags'
#**************************************************************************************
#*
#*                            Convenient Command
#*
#**************************************************************************************
alias delgen='[[ $(getBranch) != "no branch" ]] && rm -rf `find . -name gen`'
alias delswp='rm -f `find $1 -regex ".*\.swp$"`'
alias randomname='date +%Y_%m_%d_%H_%M_%S'
alias genctags='ctags -R --c++-kinds=+p --fields=+iaS --extra=+q'
function sslpem
{
    openssl pkcs12 -in $1 -nodes -out $2
}
function netcap
{
    local capfile=/work/temp/$$.pcapng
    sudo dumpcap -q -i $1 -w $capfile
    sudo chown baiou:users $capfile
    chmod 555 $capfile
    echo $capfile
}
function gencscope
{
    find $1 -regex ".*\.\(h\|c\|cpp\|htm\|html\|js\|css\)$"  | sed -n '/.*\/gen\/.*/d ; p' > cscope.files
    cscope -Rbkq
}
function countdiff
{
    local x = `git diff $1 $2 | grep '^-[^-\s\t]\|^-[\s\t]\s*\S\+' | wc -l`; 
    local y = `git diff $1 $2 | grep '^+[^+\s\t]\|^+[\s\t]\s*\S\+' | wc -l`;
    echo $1 -> $2
    echo $1: $x
    echo $2: $y
}

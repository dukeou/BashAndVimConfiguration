# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
#PS1="\033[0;34;40m${PS1}\033[m"
# export HTTP_PROXY=http://web-proxy.boi.hp.com:8080
# export http_proxy=http://proxy.austin.hp.com:8080
# export https_proxy=https://proxy.austin.hp.com:8080
#if [ -d /projects/phx/tools/linux ]; then
	export PATH=/work/bin:/projects/phx/tools/linux:/projects/phx/tools:/opt/repo:$PATH
#else
#	export PATH=/work/bin:/opt/repo:$PATH
#fi
alias cgrep='grep -inr --exclude-dir=gen'
alias la='ls -ah --color=auto'
alias lla='ls -alh --color=auto'
alias gitlog='git log --pretty=format:"%h %ai %an<%ae>%s"'
alias gitbranch='git branch'
alias gitcheckout='git checkout'
alias gitcommit='git commit'
alias gitstatus='git status'
alias gitadd='git add'
alias gitcherrypick='git cherry-pick'
alias gitreset='git reset'
alias gitpull='git pull'
alias gitstash='git stash'
alias repolog='repo log --pretty=" %h %ai %an<%ae>%s "'

export DBGTOOL="/work/sandbox/phx_sandbox/scm/phx/components/Print3/Copy/tools"
export PHXWK="/work/sandbox/phx_sandbox/scm/phx/components"
export APLWK="/work/sandbox/my_apollo_sandbox/apollo/scm/phx/components"
export CRS="/work/CRs"
export PJDAILY="/projects/phx/daily"
export APLTST="/work/sandbox/my_apollo_sandbox/apollotest/phx_test"
#sudo service iptables restart

alias gitwhat='git whatchanged --pretty=format:"%C(yellow)%h %ai %an<%ae>%s"'
alias gitdiff='git difftool -y -t vimdiff'
alias cdphx='cd $PHXWK'
alias enterap='cd $APLWK'
alias gittag='git describe --tags'

# compile command
alias mkas="./phxmake -j10 Product=moon TargPair=gh517-arm Flavor=debug"
alias mklp=" ./phxmake -j10 Product=lonepine TargPair=gh505-coldfire Flavor=debug"
alias mklpn=" ./phxmake -j10 Product=lonepine TargPair=gh505-coldfire Flavor=no_debug"
alias mkcgr=" ./phxmake -j10 Product=cougar TargPair=gh505-arm Flavor=debug"
alias mkcgrn=" ./phxmake -j10 Product=cougar TargPair=gh505-arm Flavor=no_debug"
alias mkcarn=" ./phxmake -j10 Product=caracal TargPair=gh505-arm Flavor=no_debug"
alias mkcar=" ./phxmake -j10 Product=caracal TargPair=gh505-arm Flavor=debug"
alias mkchn=" ./phxmake -j10 Product=cheetah TargPair=gh505-arm Flavor=no_debug"
alias mkch=" ./phxmake -j10 Product=cheetah TargPair=gh517-arm Flavor=debug"
alias mkbb=" ./phxmake -j10 Product=blackbird TargPair=gh517-arm Flavor=debug"
alias mksb=" ./phxmake -j10 Product=switchback TargPair=gh517-arm Flavor=debug"
alias mksun=" ./phxmake -j10 Product=sun TargPair=gh517-arm Flavor=debug"
alias mkhome="./phxmake -j10 Product=homer TargPair=gh517-arm Flavor=debug"
alias mkhome2="./phxmake -j10 Product=homer2.0 TargPair=gh517-arm Flavor=debug EPRINT_BIND=BIND"
alias mkepic="./phxmake -j10 Product=epic TargPair=gh517-arm Flavor=debug"
alias mkdn="./phxmake -j10 Product=dynasty TargPair=gh517-arm Flavor=debug"
alias mkcyp="./phxmake -j10 Product=cypressPro TargPair=gh517-arm Flavor=debug"
alias mksm="./phxmake -j10 Product=thunderbolt TargPair=gh517-arm Flavor=debug Simulator=true"
alias mkbuck="./phxmake -j10 Product=buck TargPair=gh517-arm Flavor=debug"
alias mktaishan="./phxmake -j10 Product=taishan TargPair=gh517-arm Flavor=debug"
alias mksanya="./phxmake -j10 Product=sanya TargPair=gh517-arm Flavor=debug"
alias mkpuma="./phxmake -j10 Product=puma TargPair=gh517-arm Flavor=debug"
alias mkaste="./phxmake -j10 Product=asteroid TargPair=gh517-arm Flavor=debug"
alias mkmoon="./phxmake -j10 Product=moon TargPair=gh517-arm Flavor=debug"
#alias mknebula="./phxmake -j10 Product=nebula TargPair=gh524-arm Flavor=debug"
alias mknebula="./phxmake -j10 Product=nebula TargPair=gh201314p-arm Flavor=debug"
alias mkorion="./phxmake -j10 Product=orion TargPair=gh201314pT2-arm Flavor=no_debug"
alias mkmarlin="./phxmake-j10 Product=marlin TargPair=gh201314pT2-arm Flavor=debug"
alias mkmarlin2="./phxmake -j10 Product=marlin TargPair=gh201514-arm Flavor=debug ENGINELESS_DEV=BIND SCANNERLESS_DEV=BIND FAXLESS_DEV=BIND"
alias mkdorado="./phxmake -j10 Product=dorado TargPair=gh201514-arm Flavor=debug"
alias mkdorado2="./phxmake -j10  Product=dorado TargPair=gh201314pT2-arm Flavor=debug"
alias mkneptune="./phxmake -j10 Product=neptune TargPair=gh201314pT2-arm Flavor=debug"
alias mkgemini="./phxmake -j10 Product=gemini TargPair=gh201314pT2-arm Flavor=debug"
alias mkgemini_lite="./phxmake -j10 Product=gemini_lite TargPair=gh201314pT2-arm Flavor=debug"
alias mkcanary="./phxmake -j10 Product=canary TargPair=gh201514-arm Flavor=debug"
alias mklark="./phxmake -j10 Product=lark TargPair=gh201514-arm Flavor=debug"
alias mklark_lite_thorm="./phxmake -j10 Product=lark_lite_thorm TargPair=gh201514-arm Flavor=debug"
alias mklark_lite_mojo="./phxmake -j10 Product=lark_lite TargPair=gh201514-arm Flavor=debug"
alias mkswan="./phxmake -j10 Product=swan TargPair=gh201514-arm Flavor=debug"
alias mkseagull="./phxmake -j10 Product=seagull TargPair=gh201514-arm Flavor=debug"
alias mkby="./phxmake -j10 Product=bigeye TargPair=gh201514-arm Flavor=debug"
alias mknile="./phxmake -j10 Product=nile TargPair=gh201514-arm Flavor=debug"
alias mksim="./phxmake -j10 Product=nebula TargPair=gh201514-arm Flavor=debug Simulator=true"
alias mkzenith="./phxmake -j10 Product=zenith TargPair=gh201514-arm Flavor=no_debug"
alias mkbigeye="./phxmake -j10 Product=bigeye TargPair=gh201314pT2-arm Flavor=debug"


#-----------------------------------------apollo-------------------------------------------------------------
#---Arthur
alias mkarthurwifi="cd $APLWK/..; ./phxmake -j10 Product=arthur_wifi TargPair=gh201514-arm Flavor=debug"
alias mkarthurwifindb="cd $APLWK/..; ./phxmake -j10 Product=arthur_wifi TargPair=gh201514-arm Flavor=no_debug"

alias mkarthurwifimojo="cd $APLWK/..; ./phxmake -j10 Product=arthur_wifi_mojo TargPair=gh201514-arm Flavor=debug"
alias mkarthurbasetiny="cd $APLWK/..; ./phxmake -j10 Product=arthur_base_tiny TargPair=gh201514-arm Flavor=debug"
alias mkarthurbasemojo="cd $APLWK/..; ./phxmake -j10 Product=arthur_base_mojo TargPair=gh201514-arm Flavor=debug"

alias mkarthurbase="cd $APLWK/..; ./phxmake -j10 Product=arthur_base TargPair=gh201514-arm Flavor=debug"
alias mkarthurbasendb="cd $APLWK/..; ./phxmake -j10 Product=arthur_base TargPair=gh201514-arm Flavor=no_debug"

#---Gawain
alias mkgw="cd $APLWK/..; ./phxmake -j10 Product=gawain TargPair=gh201514-arm Flavor=debug"
alias mkgwndb="cd $APLWK/..; ./phxmake -j10 Product=gawain TargPair=gh201514-arm Flavor=no_debug"

alias mkgwmj="cd $APLWK/..; ./phxmake -j10 Product=gawain_mojo TargPair=gh201514-arm Flavor=debug"
alias mkgwsw="cd $APLWK/..; ./phxmake -j10 Product=gawain_swan TargPair=gh201514-arm Flavor=debug"

alias mkgwmj_ndb="cd $APLWK/..; ./phxmake -j10 Product=gawain_mojo TargPair=gh201514-arm Flavor=no_debug"
alias mkgwpearl_ndb="cd $APLWK/..; ./phxmake -j10 Product=gawain TargPair=gh201514-arm Flavor=no_debug"
#---QPI_arthrur_base
alias mkqpiarthurbase="cd $APLWK/..; ./phxmake -j10 Product=QPI_arthur_base TargPair=gh201514-arm Flavor=debug"
#---QPI_arthrur_wifi
alias mkqpiarthurwifi="cd $APLWK/..; ./phxmake -j10 Product=QPI_arthur_wifi TargPair=gh201514-arm Flavor=debug"
#---QPI_gawain
alias mkqpigawain="cd $APLWK/..; ./phxmake -j10 Product=QPI_gawain TargPair=gh201514-arm Flavor=debug"
#---lark_lite
alias mkll="cd $APLWK/..; ./phxmake -j10 Product=lark_lite TargPair=gh201514-arm Flavor=debug"
#---avalon
alias mkavlon="cd $APLWK/..; ./phxmake -j10 Product=avalon TargPair=gh201514-arm Flavor=debug"
#---camelot
alias mkcamelot="cd $APLWK/..; ./phxmake -j10 Product=camelot TargPair=gh201514-arm Flavor=debug"

#download -k -ifs -b0 arthur_base.bbz -o arthur_base.rfu

enterap
#echo --------------------------------------
#echo repo branch:
#echo
#repo branch
#echo --------------------------------------
#echo git status:
#echo
#git status
#echo --------------------------------------
#echo gitlog:
#echo
#gitlog -2
#echo

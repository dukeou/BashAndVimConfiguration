# .bashrc
#**************************************************************************************
#*
#*                            Source global definitions
#*
#**************************************************************************************
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
# VIM mode
set -o vi
# export all variables and functions
set -a
#**************************************************************************************
#*
#*                            PATH Settings
#*
#**************************************************************************************
export PATH=''
export LD_LIBRARY_PATH=./
#**************************************************************************************
#*
#*                            Time Zone Setting
#*
#**************************************************************************************
TZ='Asia/Shanghai'; export TZ
#**************************************************************************************
#*
#*                            Proxy Settings
#*
#**************************************************************************************
# export http_proxy=
# export https_proxy=
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
function getBranch
{
	br=`git branch 2>/dev/null | grep "*"`
	if [ -z "$br" ]; then
		br="no branch"
	fi
	echo "${br/#\* /}"
}
function getRemoteBranch
{
    br=`git branch -a 2>/dev/null | sed -n '$p'`
    echo ${br##\*\/}
}
if [ "$PS1" ]; then
	PS1='[\033[1;32;40m\u@\h($(myip)) `date +%Y-%m-%d\(%a\)` \t \w \033[1;37;41m<branch:$(getBranch)>\033[m]\n\\$ '
fi
#**************************************************************************************
#*
#*                            User specific aliases and functions
#*
#**************************************************************************************
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias sz='sz -b'
alias vi='vim -p'
unalias ll lh la lla 2>/dev/null
function ll { ls -al --color=auto "$@"; }
function lh { ls -alh --color=auto "$@"; }
function la { ls -ah --color=auto "$@"; }
function lla { ls -alh --color=auto "$@"; }
function cgrep { grep -Einr --exclude-dir=gen "$@"; }
#function myip { ifconfig | grep "inet addr:15" | sed -n "s/^\s*inet addr:\(\S*\).*$/\1/p" $@; }
function myip { ifconfig $(cat /etc/network/interfaces|sed -n "/auto/{s/^\s*auto\s*\(\S*\)\s*$/\1/p}"|sed -n "/lo/d; p") | sed -n "/inet addr/{s/^\s*inet addr\s*:\s*\(\S*\)\s*.*$/\1/p}" "$@"; }
function nsip { nslookup $(hostname) | sed -n "/Address[^#]*$/{s/^.*:\s*\(.*\)\s*$/\1/p}" "$@"; }
function randomname { echo $(date +%Y_%m_%d_%H_%M_%S)_$(($RANDOM%1000)); }
function randomname2 { echo $(date +%Y%m%d%H%M%S)_$(($RANDOM%1000)); }
function dt { date '+%y/%m/%d %H:%M:%S'; }
ALL_IPS=$(myip)
ALL_IPS=${ALL_IPS%.*}.{1..255}
declare -A color_table=(
    ['clear']='\033[m'
    ['red']='\033[1;31;40m'
    ['green']='\033[1;32;40m'
    ['yellow']='\033[1;33;40m'
    ['blue']='\033[1;34;40m'
)
function _ip_comp
{
    COMPREPLY=()
    [ $COMP_CWORD -eq 1 ] && COMPREPLY=($(compgen -W $ALL_IPS "$2"))
}
function _table_draw
{
    # cmd <col> <data...>
    local -i _col=$1; shift
    local -i _ind _len _i=0 _j=0 _k=0
    local _w=() _tb_start _tb_mid _tb_end _tb_template
    for _d
    do
        _ind=$((_i%_col))
        _i=$_i+1
        _len=$(strlen_sh "$_d")+4
        [ -z "${_w[$_ind]}" ] && _w[$_ind]=$_len && continue
        [ $_len -gt ${_w[$_ind]} ] && _w[$_ind]=$_len
    done
    _line='x'
    _tb_template='│'
    for (( _i=0; _i<$_col; ++_i )) # Columns
    do
        _len=${_w[$_i]}
        for (( _j=0; _j<$_len; ++_j ));
        do
            _line+='─';
        done # width for each column
        _tb_template+="%-${_len}s│"
        [ $_i -lt $((_col-1)) ] && _line+='y'
    done
    _line+='z'
    _tb_start=$_line;
    _tb_start=${_tb_start//x/┌}
    _tb_start=${_tb_start//y/┬}
    _tb_start=${_tb_start//z/┐}
    _tb_mid=$_line
    _tb_mid=${_tb_mid//x/├}
    _tb_mid=${_tb_mid//y/┼}
    _tb_mid=${_tb_mid//z/┤}
    _tb_end=$_line
    _tb_end=${_tb_end//x/└}
    _tb_end=${_tb_end//y/┴}
    _tb_end=${_tb_end//z/┘}
    echo "$_tb_start"
    for(( _i=1; _i<$#; _i+=$_col))
    do
        printf "$_tb_template\n" ${@: $_i:$_col}
        [ $_i -lt $(($#-$_col)) ] && echo "$_tb_mid"
    done
    echo "$_tb_end"
}
function color_echo_sh
{
    local _color=$1; shift;
    printf "${color_table[$_color]}%s${color_table['clear']}\n" "$*"
}
function error_sh
{
    local -i _i=0
    local _func_name=''
    if [ -t 2 ]; then
        color_echo_sh red 'Error:' $@ >&2
        color_echo_sh red 'Callstacks:'
        for _func_name in ${FUNCNAME[@]}
        do
            color_echo_sh red "$(printf "    %10s -> %-15s: Line %d" "${BASH_SOURCE[$_i]}" "$_func_name" "${BASH_LINENO[$_i-1]}")" >&2
            _i+=1
        done
    else
        echo 'Error:' $@ >&2
        echo 'Callstacks:' >&2
        for _func_name in ${FUNCNAME[@]}
        do
            echo "$(printf "    %10s -> %-15s: Line %d" "${BASH_SOURCE[$_i]}" "$_func_name" "${BASH_LINENO[$_i]}")" >&2
            _i+=1
        done
    fi
    return 0
}
function prompt_sh
{
    if [ $# -gt 0 ]; then
        color_echo_sh yellow $@
    fi
    return 0
}
function strlen_sh
{
    printf %s "$1" | wc -c
}
function substr_sh
{
    local -i _len=$(strlen_sh "$1")
    local -i _start=$2
    local -i _reslen=$_len-$_start
    local -i _sublen=$3
    [ -z "$3" ] && _sublen=$_reslen
    [ $_sublen -lt 0 ] && _sublen+=$_reslen
    printf %s "$1" | tail -c $_reslen | head -c $_sublen
    printf %s " "
}
function input_sth_sh
{
    local _prompt='' _variable='' _m='' _non_empty=''
    OPTIND=1
    while getopts "p:v:n" _m;
    do
        case "$_m" in
            p) _prompt=$OPTARG ;;
            v) _variable=$OPTARG ;;
            n) _non_empty='True' ;;
            ?) ;&
            *) return 1;;
        esac
    done
    [ -z "$_variable" ] && return 0
    [ -z "$_prompt" ] && _prompt='Please input: '
    [ "$_variable" != "_input" ] && local _input=''
    ! read -e -p "`prompt_sh "$_prompt"`" _input && return 1
    until [ -z "$_non_empty" -o -n "$_input" ];
    do
        ! read -e -p "`prompt_sh "$_prompt"`" _input && return 1
    done
    [ -z "$_variable" ] && echo "$_input" && return 0;
    local -n _ref="$_variable"
    _ref=$_input
    return 0
}
function checkyesno_sh
{
    local _choice=''
    while [ "$_choice" != "yes" -a "$_choice" != "no" ];
    do
        read -e -p "`prompt_sh "$* (yes/no) "`" _choice
    done
    if [ $_choice == "no" ]; then
        return 1
    fi
    return 0
}
function select_any_sh
{
    [ $# -lt 1 ] && error_sh "No option" && return 1
    if [ $# -ge 2 ] && [ -n "${@: -1}" ]; then
        local -n _ref=${@: -1}
        [ "${@: -1}" != "_m" ] && local _m=''
        [ "${@: -1}" != "_selected" ] && local _selected=''
        [ "${@: -1}" != "_i" ] && local -i _i=1
        [ "${@: -1}" != "_results" ] && local _results=''
    else
        local _m=''
        local _selected=''
        local -i _i=1
        local _results=''
    fi
    for _m in "${@: 1:$(($#>1?($#-1):$#))}"
    do
        printf "%3s) %s\n" "$_i" "$_m" >&2
        _i+=1
    done
    if [ -n "${@: -1}" ]; then
        _ref=''
        REPLY=0
        while [ true ]
        do
            _results=''
            input_sth_sh -p "#? " -v _selected
            [ -z "$_selected" ] && _results=${@: 1:$(($#-1))} && break
            _selected=${_selected//+( )/ }
            _selected=${_selected//+( )-/-}
            _selected=${_selected//-+( )/-}
            [ "$_selected" == '*' ] && _selected=${@: 1:$(($#-1))} && break
            for _m in ${_selected}
            do
                if [[ "$_m" =~ ^[1-9][0-9]*$ ]]; then
                    [ "$_m" -ge $_i ] && continue
                    _results+=${@: $_m:1}" "
                elif [[ "$_m" =~ ^([1-9][0-9]*)-([1-9][0-9]*)$ ]]; then
                    [ ${BASH_REMATCH[1]} -ge $_i ] && continue
                    [ ${BASH_REMATCH[2]} -ge $_i ] && continue
                    [ ${BASH_REMATCH[2]} -lt ${BASH_REMATCH[1]} ] && continue
                    _results+=${@: ${BASH_REMATCH[1]}:$((${BASH_REMATCH[2]}-${BASH_REMATCH[1]}+1))}" "
                fi
            done
            [ -n "$_results" ] && break
        done
        _results=${_results//+( )/ }
        _results="${_results// /$'\n'}"
        _results=$(echo "$_results" | sort | uniq)
        if [ $# -ge 2 ]; then
            _ref="$_results"
        else
            echo "$_results"
        fi
    fi
    return 0
}
function select_one_sh
{
    [ $# -lt 1 ] && error_sh "No option" && return 1
    if [ $# -ge 2 ] && [ -n "${@: -1}" ]; then
        local -n _ref=${@: -1}
        [ "${@: -1}" != "_m" ] && local _m=''
        [ "${@: -1}" != "_selected" ] && local _selected=''
        [ "${@: -1}" != "_i" ] && local -i _i=1
    else
        local _m=''
        local _selected=''
        local -i _i=1
    fi
    for _m in "${@: 1:$(($#>1?($#-1):$#))}"
    do
        printf "%3s) %s\n" "$_i" "$_m" >&2
        _i+=1
    done
    if [ -n "${@: -1}" ]; then
        _ref=''
        REPLY=0
        while [ true ]
        do
            input_sth_sh -n -p "#? " -v _selected
            [[ ! "$_selected" =~ ^[1-9][0-9]*$ ]] &&  continue
            REPLY=$_selected
            [ $_selected -lt $(($#>1?$#:($#+1))) ] &&  break
        done
        if [ $# -ge 2 ]; then
            _ref="${@: $_selected:1}"
        else
            echo "${@: $_selected:1}"
        fi
    fi
    return 0
}
function hex2str_sh
{
    local _p
    local -i _i
    for _p
    do
        _i=0
        _len=$(strlen_sh "$_p")
        for (( _i=0; _i < _len; _i+=2 ))
        do
            printf "\\x${_p: _i:2}"
        done
        echo ''
    done
}
function str2hex_sh
{
    local _p
    for _p
    do
       printf '%s\n' $(echo $(printf %s "$_p" | od -A n -t x1) | sed 's/ //g; s/\(^.*$\)/\U\1/;')
    done
}
function is_ip_sh
{
    [[ "$1" =~ ^[0-9]{1,3}(.[0-9]{1,3}){3} ]] && return 0
    return 1
}
function xmlfmt_awk
{
#    awk "
#        function trim(str)
#        {
#            gsub(/\r/, "", str);
#            gsub(/^[ \t]+/, "", str);
#            gsub(/[ \t]+$/, "", str);
#            gsub(/[ \t]+/, " ", str);
#            return str;
#        }
#        function space(num)
#        {
#            for(i = 0; i < num * 4; i++)
#            {
#                printf " ";
#            }
#        }
#        BEGIN {
#            pattern = "</?[\\.\\:a-zA-Z0-9_-]+( +[\\:a-zA-Z_][\\.\\:a-zA-Z0-9_-]*=(('[^']+')|(\"[^\"]+\")))* */?>";
#            indent = 0;
#            tags = 0;
#        }
#        {
#            str = $0;
#            while(match(str, pattern))
#            {
#                text = trim(substr(str, 0, RSTART - 1));
#                if(substr(str, RSTART + 1, 1) == "/")
#                {
#                    --indent;
#                    if(length(text) > 0)
#                    {
#                        printf "%s%s", text, substr(str, RSTART, RLENGTH);
#                    }
#                    else
#                    {
#                        printf "\n";
#                        space(indent);
#                        printf "%s", substr(str, RSTART, RLENGTH);
#                    }
#                }
#                else
#                {
#                    ++tags;
#                    if(tags > 1)
#                    {
#                        printf "\n";
#                    }
#                    if(length(text) > 0)
#                    {
#                        space(indent);
#                        printf "%s\n", text;
#                    }
#                    space(indent);
#                    printf "%s", substr(str, RSTART, RLENGTH);
#                    if(substr(str, RSTART + RLENGTH - 2, 1) != "/")
#                    {
#                        ++indent;
#                    }
#                }
#                str=substr(str, RSTART + RLENGTH);
#            }
#            str = trim(str);
#            if(length(str) > 0)
#                printf("%s\n", str);
#        }
#        END{
#            printf "\n";
#        }'
}
function xmlfmt_sh
{ 
    sed -n '{
        H;
        ${
            x;
            s/\n/ /g;
            s/^\s*//g;
            s/\s*$//g;
            s/\(<\/[^<>]\+>\)/\1\n/g;s/>\s*</>\n</g;
            s/>\n*$/>\n/;
            p;
        };
    }' | 
    sed '{
        /^<[\x3F\x21]/b;
        /^<[^\/][^<>]\+[^\/]>$/{
            H;
            g;
            s/\n//;
            h;
            s/^\(\s*\).*$/    \1/;
            x;
        };
        /.<\/\|\/>/{
            H;
            g;
            s/\n//;
            h;
            s/^\(\s*\).*$/\1/;
            x;
        };
        /^<\//{
            x;
            s/    $//;
            G;s/\n//;
            h;
            s/^\(\s*\).*$/\1/;
            x;
        };
        /^$/d;
    }'
}
#**************************************************************************************
#*
#*                            HTTP Command
#*
#**************************************************************************************
function httpclient_sh
{
    local _http_template="\
%s %s HTTP/1.1\r\n\
Host: %s\r\n\
Connection: %s\r\n\
Content-Type: %s\r\n\
%sContent-Length: %d\r\n\r\n\
%s"
    local _auth_template="Authorization: Basic %s\r\n"
    local -u _method=''
    local _server='' _host='' _url='' _connection='Close' _payload='' _http_ticket='' _target_file=''
    local _user='' _passwd='' _auth='' _sleep='' _debug_output='/dev/null' _content_type=''
    local -i _content_len=0 _max_timeout=10
    local -A _http_header
    OPTIND=1
    while getopts "t:h:m:u:p:U:P:k" _m
    do
        case "$_m" in
            h) _server=$OPTARG;;
            m) _method=$OPTARG;;
            u) _url=$OPTARG;;
            p) _payload=$OPTARG;;
            U) _user=$OPTARG;;
            P) _passwd=$OPTARG;;
            k) _connection='keep-alive';;
            d) _debug_output='/dev/stderr' ;;
            t) _content_type=$OPTARG;;
            ?) ;&
            *)
        esac
    done
    [ "$LEDM_SH_DEBUG" == "ON" ] && _debug_output='/dev/stderr'
    [ -z "$_server" ] && input_sth_sh -n -p "IP: " -v _server
    [ -z "$_url" ] && input_sth_sh -n -p "URL: " -v _url
    [ -z "$_method" ] && select_one_sh GET PUT POST _method
    [ -z "$_server" ] && select_one_sh ledm1 ledm2 eth _server
    [ "$_server" == "eth" ] && input_sth_sh -n -p "IP: " -v _server
    [ -z "$_url" ] && input_sth_sh -n -p "URL: " -v _url
    if is_ip_sh "$_server"; then
        _target_file=/dev/tcp/$_server/80
        _host=$_server
        _sleep='.2'
        _max_timeout=100
    else
        _target_file=/dev/$_server
        [ ! -c "$_target_file" ] && error_sh "usb host $_target_file doesn't exist" && return 1
        _host=USB
        _sleep='.5'
        _max_timeout=10
    fi

    local _fd=0 _line='' _header='' _buf='' _http_body=''
    local -l _lowercase_line='' _chunk='' _ret=0
    local -i _timeout_cnt=0
    ! exec {_fd}<>$_target_file && return 1
    while [ true ]
    do
        _http_body=''
        _content_len=$(strlen_sh "$_payload")
        if [ -n "$_passwd" ]; then
            _auth=$(printf %s "$_user:$_passwd" | base64)
            _auth=$(printf "$_auth_template"Z "$_auth")
            _auth=${_auth: 0:-1}
        fi
        _http_ticket=$(printf "$_http_template" "$_method" "$_url" "$_host" "$_connection" "$_content_type" "$_auth" $_content_len "$_payload")
        [ -z "$_payload" ] && _http_ticket+=$'\n'
        printf "%s\n------------------------------------------------\n" "$_http_ticket" >$_debug_output
        ! printf %s "$_http_ticket" >&$_fd && return 1
        _content_len=0
        while [ true ]
        do
            _line=$(dd bs=1024 count=1 iflag=nonblock <&$_fd 2>/dev/null | sed -z '$az')
            [ -n "$_line" ] && _line=${_line: 0:-1}
            if [ -z "$_line" ]; then
                sleep $_sleep
                _timeout_cnt+=1 && [ $_timeout_cnt -gt $_max_timeout ] && error_sh "Time out" && break 2
                continue
            fi
            printf %s "$_line" >$_debug_output
            _buf+=$_line
            while [ true ]
            do
                [[ ! ${_buf} =~ $'\n' ]] && break;
                _line=$(printf %s "${_buf}Z" | sed -n '1{s/\r//g;p}')
                _buf=$(printf %s "${_buf}Z" | sed '1d')
                _buf=${_buf: 0:-1}
                [ -z "${_line}" ] && break 2
                if [[ "$_line" =~ ^HTTP/1\.[01][[:space:]]([1-9][0-9]{2})[[:space:]](.*)$ ]]; then
                    _http_header["Response-Code"]=${BASH_REMATCH[1]}
                    _http_header["Response-Message"]=${BASH_REMATCH[2]}
                elif [[ "$_line" =~ ^([^:]+):[[:space:]]*(.+)$ ]]; then
                    _http_header+=(["${BASH_REMATCH[1]}"]=${BASH_REMATCH[2]})
                    _lowercase_line=${BASH_REMATCH[1]}
                    [ "$_lowercase_line" == content-length ] && _content_len=${BASH_REMATCH[2]}
                    [ "$_lowercase_line" == transfer-encoding ] && _chunk=${BASH_REMATCH[2]}
                fi
            done
        done
        for _header in "${!_http_header[@]}"
        do
            printf "%-20s: \"%s\"\n" "$_header" "${_http_header["$_header"]}" >$_debug_output
        done
        _timeout_cnt=0
        if [ "${_chunk,,}" == chunked ]; then
            local -i _chunk_len=0
            local -i _rd_len=0
            local _tmp=''
            local -i _need_more_data=0
            while [ true ]
            do
                if (( $_need_more_data )); then
                    _line=''
                    while [ -z "$_line" ]
                    do
                        _line=$(dd bs=1024 count=1 iflag=nonblock <&$_fd 2>/dev/null | sed -z '$az')
                        [ -n "$_line" ] && _line=${_line: 0:-1}
                        if [ -z "$_line" ]; then
                            sleep $_sleep
                            _timeout_cnt+=1 && [ $_timeout_cnt -gt $_max_timeout ] && error_sh "Time out" && break 3
                        fi
                    done
                    _buf+=$_line
                    _need_more_data=0
                fi
                if [ $_chunk_len -eq 0 ]; then
                    _line=$(printf %s "${_buf}Z" | sed -n '1{s/^\(.*\r\)$/\1/p}')
                    [ -z "$_line" ] && _need_more_data=1 && continue
                    _buf=$(substr_sh "$_buf" $(($(strlen_sh "$_line")+1)))
                    _buf=${_buf: 0:-1}
                    _line=${_line: 0:-1}
                    _chunk_len=0x$_line
                    [ $_chunk_len -le 0 ] && break
                    _chunk_len+=2
                fi
                _rd_len=$(strlen_sh "$_buf")
                if [ $_rd_len -ge $_chunk_len ]; then
                    _tmp=$(substr_sh "$_buf" 0 $((_chunk_len-2)))
                    _tmp=${_tmp: 0:-1}
                    _buf=$(substr_sh "$_buf" $_chunk_len)
                    _buf=${_buf: 0:-1}
                    _chunk_len=0
                    #printf %s "$_tmp"
                    _http_body+=$_tmp
                elif [ $_rd_len -le $((_chunk_len-2)) ]; then
                    #printf %s "$_buf"
                    _http_body+=$_buf
                    _chunk_len=$_chunk_len-$_rd_len
                    _buf=''
                    _need_more_data=1
                else
                    #printf %s "${_buf: 0:-1}"
                    _http_body+=${_buf: 0:-1}
                    _buf=${_buf: -1}
                    _chunk_len=2
                    _need_more_data=1
                fi
            done
        elif [ $_content_len -gt 0 ]; then
            #printf %s "$_buf"
            _http_body+=$_buf
            _content_len=$_content_len-$(strlen_sh "$_buf")
            local -i _rd_len=$((_content_len>1024?1024:_content_len))
            while [ $_content_len -gt 0 ]
            do
                _line=$(dd bs=1024 count=1 iflag=nonblock <&$_fd 2>/dev/null | sed -z '$az')
                [ -n "$_line" ] && _line=${_line: 0:-1}
                if [ -z "$_line" ]; then
                    sleep $_sleep
                    _timeout_cnt+=1 && [ $_timeout_cnt -gt $_max_timeout ] && error_sh "Time out $_content_len" && break
                    continue
                fi
                #printf %s "$_line"
                _http_body+=$_line
                _content_len=$_content_len-$(strlen_sh "$_line")
                _rd_len=$((_content_len>1024?1024:_content_len))
            done
        fi
        if [ "${_http_header[Response-Code]}" == 202 ]; then
            sleep .5
            _http_header=()
        elif [ "${_http_header[Response-Code]}" == 401 ]; then
            _http_header=()
            input_sth_sh -p "User name: " -v _user
            input_sth_sh -p "Password: " -v _passwd
        elif [ "${_http_header[Response-Code]}" == 403 ]; then
            if [ "$LEDM_SH_DEBUG" == "ON" ]; then
                echo curl -v -X "$_method" -d "$_payload" -k -H "$_auth" -w "%{http_code}\n" "https://$_ip$_url"
                curl -v -X "$_method" -d "$_payload" -k -H "$_auth" -w "%{http_code}\n" "https://$_ip$_url"
            else
                echo curl -X "$_method" -d "$_payload" -k -H "$_auth" -w "%{http_code}\n" "https://$_ip$_url"
                curl -X "$_method" -d "$_payload" -k -H "$_auth" -w "%{http_code}\n" "https://$_ip$_url"
            fi
            break;
        elif [ "${_http_header[Response-Code]}" == 301 ]; then
            if [[ "${_http_header[Location]}" =~ https:// ]]; then
                if [ "$LEDM_SH_DEBUG" == "ON" ]; then
                    echo curl -v -X "$_method" -d "$_payload" -k -H "$_auth" -w "%{http_code}\n" "${_http_header[Location]}"
                    curl -v -X "$_method" -d "$_payload" -k -H "$_auth" -w "%{http_code}\n" "${_http_header[Location]}"
                else
                    echo curl -X "$_method" -d "$_payload" -k -H "$_auth" -w "%{http_code}\n" "${_http_header[Location]}"
                    curl -X "$_method" -d "$_payload" -k -H "$_auth" -w "%{http_code}\n" "${_http_header[Location]}"
                fi
                break;
            elif [ -n "${_http_header[Location]}" ]; then
                _url=${_http_header[Location]}
                _url=${_url##*\/\/}
                _url='/'${_url#*\/}
                _http_header=()
            else
                break;
            fi
        else
            if [ "${_http_header[Response-Code]}" == 200 ]; then
                _ret=0;
                if [ -n "$_http_body" ]; then
                    printf "%s\n" "$_http_body"
                else
                    printf "%s %s\n" "${_http_header[Response-Code]}" "${_http_header[Response-Message]}"
                fi
            else
                printf "%s %s\n" "${_http_header[Response-Code]}" "${_http_header[Response-Message]}" >&2
                _ret=1
            fi
            break
        fi
    done
    printf "\n" >$_debug_output
    [ $_fd -gt 0 ] && exec {_fd}>&- && exec {_fd}<&-
    return $_ret
}
#**************************************************************************************
#*
#*                            Git Command
#*
#**************************************************************************************
function gittop { git rev-parse --show-toplevel "$@"; }
function gitwhat { git whatchanged --pretty=format:"%C(yellow)%h %ai %an<%ae>%s" "$@"; }
function gitlog { git log --pretty=format:"%Cblue%h%Creset %ci %<(25)%an%<(31)%ae %s" "$@"; }
function gitalog { git log --pretty=format:"%Cblue%h%Creset %ai %<(25)%an%<(31)%ae %s" "$@"; }
function gittag { git describe --tags "$@"; }
function gitswhat
{
    gitwhat -1 "$@" |
    {
        local _line=''
        local -a _array=()
        while [ true ]
        do
            read _line
            [ -z "$_line" ] && break
            [[ ! "$_line" =~ ^: ]] && printf "%s\n\033[m" "$_line" && continue
            _array=($_line)
            _line=$(gittop)/${_array[@]: -1}
            printf "%s  " "${_array[*]: 0:5}"
            _line=$(realpath "$_line")
            #echo ${_line##$(pwd)}
            relatedpath "$_line"
        done
    }
}
function _get_cur_branch
{
    if [ -n "$1" ]; then
        [ "$1" != "_br" ] && local _br=''
        local -n _ref="$1"
        _ref=''
    fi
    _br=`git status -b | sed -n '1{s/^.*branch\s*\(.*\)\s*/\1/p}'`
    [ -z $_br ] && return 1
    [ -z "$1" ] && echo "$_br" && return 0
    _ref=$_br
    return 0
}
function _gitchanged
{
    local _list=''
    if [ $# -le 1 ]; then
        _list=$(git status -s | awk '{if($0 ~ /^'"$1"'\s*/) print $2;}')
    else
        shift;
        _list=$(git diff --name-only $@ | sed '{s/^/realpath `git rev-parse --show-toplevel`\//;e
            s/^/top=/;
            s/$/;echo ${top##`pwd`\/}/;
            e
            }')
    fi
    local _slist=''
    if [ -n "$_list" ]; then
        if [ -t 1 ]; then
            select_any_sh $_list ""
        else
            select_any_sh $_list _slist
            echo "$_slist"
        fi
    fi
}
function gitchanged { _gitchanged '.[MD?]' $@; }
function gituntracked { _gitchanged '\?\?' $@; }
function gitmodifiedandnew { _gitchanged '.[MD?]' $@; }
function gitstaged { _gitchanged '[MAD]' $@; }
function gitdiff
{
    local _newlist=''
    local _list=$(gitchanged $@)
    local l=''
    for l in $_list
    do
        [ ! -f "$l" ] && continue
        _newlist+=$l" "
    done
    if [ -t 1 ]; then
        git difftool -y -t vimdiff $@ $_newlist
    else
        git diff $@ $_newlist
    fi
}
function vigitchanged
{
    local _newlist=''
    local _list=$(gitchanged $@)
    local l=''
    for l in $_list
    do
        [ ! -f "$l" ] && [ ! -d "$l" ] && continue
        _newlist+=$l" "
    done
    [ -n "$_newlist" ] && vi $_newlist
}
function gitcheckout
{
    git checkout $(gitchanged); git status
}
function gitadd
{
   git add $(gitmodifiedandnew); git status
}
#**************************************************************************************
#*
#*                            Repo Command
#*
#**************************************************************************************
function repolog { repo log --pretty=" %h %ai %an<%ae>%s " "$@"; }
function _select_repo_branch
{
    local _branches=`repo branch | awk '{print "\""$0"\""}'`
    [ -z "$_branches" ] && return 1
    local -a _branch_array
    eval "_branch_array=($_branches)"
    if [ -n "$1" ]; then
        [ "$1" != "_branch" ] && local _branch=''
        local -n _ref="$1"
        local _p
        for _p in ${_branch_array[@]};
        do
            [ "$_p" == "$_ref" ] && return 0
        done
        _ref=''
    fi
    select_one_sh "${_branch_array[@]}" _branch
    _branch=`echo ${_branch:3} | awk '{print $1}'`
    [ -z $_branch ] && return 1
    [ -z "$1" ] && echo "$_branch" && return 0
    _ref=$_branch
    return 0
}
function repocheckout
{
    local _branch=''
    ! _select_repo_branch _branch && return 1
    _get_cur_branch _cur_branch
    [ "$_cur_branch" == "$_branch" ] && return 0
    repo checkout $_branch
    repo branch
}
function repoabandon
{
    local _branch=''
    local _cur_branch=''
    ! _select_repo_branch _branch && return 1
    _get_cur_branch _cur_branch
    while [ "$_cur_branch" == "$_branch" ];
    do
        prompt_sh "You are abandoning current branch, please checkout another branch first.\n"
        repocheckout
        _get_cur_branch _cur_branch
    done
    ! checkyesno_sh "Abandon $_branch?" && return 1
    repo abandon $_branch
    repo branch
}
#**************************************************************************************
#*
#*                            Telnet Debug Command
#*
#**************************************************************************************
function tdbg
{
    local _ip=$1 _cmd='' _fd=0 _line='' _response='' _sysname=''
    ! is_ip_sh "$_ip" && error_sh "Not an IP <$_ip>" && return 1
    _sysname=$(tdbgexec_sh "$_ip" 'systemApp/GetSystemName' 2>/dev/null)
    if ! exec {_fd}<>/dev/tcp/$_ip/2300; then
        ledm_telnet on "$_ip" >/dev/null
        ! exec {_fd}<>/dev/tcp/$_ip/2300 && error_sh "Fail to connect $_ip:2300!" && return 1
    fi
    ! read -u $_fd -d '>' _line && exit 
    printf "%s" "$_line" | sed '/telnet_debug/d'
    while input_sth_sh -p "$_ip/$_sysname telnet_debug>"  -v _cmd -n
    do
        echo "$_cmd" >&$_fd
        while true
        do
            ! read -u $_fd -t 5 -d '>' _line && break 2
            _response+=$_line
            [[ "$_response" =~ .*telnet_debug.* ]] && break
        done
        echo "$_response" | sed '${/telnet_debug/d}'
        _response=''
    done
    echo ''
    exec {_fd}>&-
    exec {_fd}<&-
    return 0
}
function tdbgexec_sh
{
    local _ip=$1; shift
    local _cmd_str=$* _cmd='' _fd=0 _line='' _response=''
    local -a _cmd_list=()
    ! is_ip_sh "$_ip" && error_sh "Not an IP <$_ip>" && return 1
    _cmd_str=${_cmd_str##*( )}
    _cmd_str=${_cmd_str%%*( )}
    [ -z "$_cmd_str" ] && return 0
    if ! exec {_fd}<>/dev/tcp/$_ip/2300; then
        ledm_telnet on "$_ip" >/dev/null
        ! exec {_fd}<>/dev/tcp/$_ip/2300 && error_sh "Fail to connect $_ip:2300!" && return 1
    fi
    ! read -u $_fd -t 5 -d '>' _line && return 1
    while [ -n "$_cmd_str" ]
    do
        _cmd=${_cmd_str%%,*}
        _cmd_str=${_cmd_str#$_cmd}
        _cmd=${_cmd##*( )}
        _cmd=${_cmd%%*( )}
        _cmd_str=${_cmd_str##*(,)}
        _cmd_str=${_cmd_str##*( )}
        _cmd_str=${_cmd_str%%*( )}
        [ -z "$_cmd" ] && continue
        echo "$_cmd" >&$_fd
        while true
        do
            ! read -u $_fd -d '>' _line && break 2
            _response+=$_line
            [[ "$_response" =~ .*telnet_debug.* ]] && break
        done
        echo "$_response" | sed '${/telnet_debug/d}'
        _response=''
    done
    exec {_fd}>&-
    exec {_fd}<&-
    return 0
}
#**************************************************************************************
#*
#*                            Trace Command
#*
#**************************************************************************************
function trace_decode
{
    [ $# -eq 0 ] && echo "$FUNCNAME <debuglist> <IP>" && return 0;
    local _df _ip _data _id _s _fd _t _lt=0
    local -A _dl _dp _pa _pc
    local -i _cnt=0 _d=0 _nt=1 _rd=0
    #full time 274877.906944
    #CKPTREG=704000c* VIDREG=7040008* VREG=7040004* NULL=00000000
    _df=$1
    _ip=$2
    [ ! -f "$_df" ] && error_sh "$_df does't exist" && return 1
    [ -z "$_ip" ] && [ -t 0 ] && error_sh "Can't read from terminal" && return 1
    ! exec {_fd}<$_df && return 1
    echo Reading debuglist $_df... >&2
    while true
    do
        ! read -r -u $_fd _id _data && break
        [ -n "${_dl["$_id"]}" ] && error_sh "Same id $_id" 2>/dev/null && continue
        _data=${_data#*components/}
        _dl[$_id]="${_data//\\/\\\\}"
        _dp[$_id]=1
        _cnt+=1
    done
    exec {_fd}<&-
    ! is_ip_sh "$_ip" && error_sh "Not an IP!!!" && return 1
    echo $_cnt lines >&2
    echo Read ${#_dl[@]} records >&2
    #! start_trace $_ip && return 1
    trap "trace_close_stream $_ip" SIGINT
    trap "trace_close_stream $_ip" SIGQUIT
    trap "trace_close_stream $_ip" SIGILL
    trap "trace_close_stream $_ip" SIGTERM
    #sleep 1
    #! open_stream $_ip && return 1
    ! exec {_fd}</dev/tcp/$_ip/1600 && error_sh "Connect $_ip:1600 failed." && return 1
    echo Decoding... >&2
    while true
    do
        _data=`dd skip=4 bs=60 count=1 iflag=skip_bytes 2>/dev/null <&$_fd | od --endian=big -A n -t x4 -v 2>/dev/null`
        [ -z "$_data" ] && break
        _t=${_data: 1:8}
        _data=${_data: 10}
        for _m in $_data
        do
            (( _d=0xffff00c0&0x$_m, _d=(_d==0x704000c0?1:(_d==0x70400080?2:(_d==0x70400040?3:0))), _d>0 )) && _nt=_d && continue
            case $_nt in
                1)
                    [ $_m == 00000000 ] && break
                    _id=$_m
                    [ -z "${_dl[$_id]}" ] && error_sh "<<< Unknown id $_m" && continue
                    [ "${_dp[$_id]}" == 1 ] && _dp[$_id]=$(printf "%s" "${_dl[$_id]}" | sed -n 's/%%//g; s/[^%]*%[0-9\.]*h*\(\w\)[^%]*/\1/gp')
                    if [ -z "${_dp[$_id]}" ]; then
                        (( 0x$_t < 0x$_lt )) && _rd+=1
                        _s=$(echo "scale=10; a=$((0x$_t)); a/=15625; a+=($_rd*274877.906944); if(a>1000) {a/=1000; print a,\" s\";}else print a,\" ms\";" | bc)
                        _lt=$_t
                        printf "%10.6f %s ${_dl[$_id]}\n" $_s
                    else
                        _pc[$_id]=0
                    fi
                ;;
                2)
                    [ $_m == 00000000 ] && break
                    _id=$_m
                ;;
                3)
                    _nt=0
                    [ -z "${_pc[$_id]}" ] && error_sh "<<< Extra Parameter $_m" && echo "${_dl[$_id]}" && continue
                    _pt=${_dp[$_id]: ${_pc[$_id]}:1}
                    case "$_pt" in
                        f)
                            _pa[$_id]+=$(printf "\x${_m: 0:2}\x${_m: 2:2}\x${_m: 4:2}\x${_m: 6:2}" | od --endian=big -A n -t fF)$'\t'
                            let _pc[$_id]+=1
                        ;;
                        s)
                            if [ $_m == 00000000 ]; then
                                _pa[$_id]+=$'\t'
                                let _pc[$_id]+=1
                            else
                                eval "_s=\$'\x${_m: 6}'"
                                [ "$_s" == $'\t' ] &&  _s=' '
                                _pa[$_id]+="$_s"
                            fi
                        ;;
                        *)
                            _d=0x$_m
                            (( _d=_d&0x80000000?(_d|0xffffffff00000000):_d ))
                            _pa[$_id]+=$_d$'\t'
                            let _pc[$_id]+=1
                        ;;
                    esac
                    if [ ${_pc[$_id]} -ge ${#_dp[$_id]} ]; then
                        (( 0x$_t < 0x$_lt )) && _rd+=1
                        _s=$(echo "scale=10; a=$((0x$_t)); a/=15625; a+=($_rd*274877.906944); if(a>1000) {a/=1000; print a,\" s\";}else print a,\" ms\";" | bc)
                        _lt=$_t
                        printf "%s" "${_pa[$_id]}" | xargs -d $'\t' printf "%10.6f %s ${_dl[$_id]}\n" $_s
                        unset _pc[$_id]
                        unset _pa[$_id]
                    fi
                ;;
                *) break ;;
            esac
        done
    done
    exec {_fd}<&-
}
#**************************************************************************************
#*
#*                            Convenient Command
#*
#**************************************************************************************
function delswp { rm -f `find $1 -regex ".*\.swp$"` "$@"; }
function genctags { ctags -R --c++-kinds=+p --fields=+iaS --extra=+q "$@"; }
function delgen
{
    local name=$1
    if [ -z "$name" ]; then
        name='gen'
        [[ $(getBranch) != "no branch" ]] && rm -rf `find . -name $name`
    else
        [[ $(getBranch) != "no branch" ]] && rm -rf `find . -name $name | sed -n '/\/gen\//p'`
    fi
}
complete -W "${!TARG_MAP[*]}" delgen
function sslpem
{
    openssl pkcs12 -in $1 -nodes -out $2
}
function netif { ifconfig | sed -n 's/^\(\w\+\) .*$/\1/; h; :loop; { n; /inet addr/{s/^\s\+//;s/inet addr/inet_addr/;H;}; /^\s*$/{z;x;/inet_addr/!b;s/\n/ /g;s/\s\+/ /g;s/ /\//g;p;b;}; bloop;}'; }
function netcap
{
    local _capfile=/work/temp/$$_$RANDOM.pcapng _intf=$1
    [ -z "$_intf" ] && select_one_sh $(netif) _intf && _intf=${_intf%%/*}
    touch $_capfile
    sudo chown $(echo $(groups $(whoami))|sed 's/\s//g') $_capfile
    sudo chmod 666 $_capfile
    sudo dumpcap -q -i "$_intf" -w $_capfile
    chmod 555 $_capfile
    echo $_capfile
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
function loccount
{
    awk 'BEGIN{FS=","}{if($1~/^c[A-Z]/){for(i=2;i<NF;i++){printf $i} print ""}}' $1 | sed 's/^\s*"//;s/"\s*$//' | wc -w
}
function relatedpath
{
    local _path=$(realpath $1) _rel_path='' _pwd_path=(${PWD//\// })
    local _array_path=(${_path//\// })
    local -i _c=0;
    while [ "${_array_path[$_c]}" == "${_pwd_path[$_c]}" ];
    do
        _c=$_c+1
    done
    if [ -z "${_pwd_path[$_c]}" ]; then
        _rel_path+=./$(echo ${_array_path[@]: $_c} | sed 's/ /\//g;')
    else
        _pwd_path=(${_pwd_path[@]: $_c})
        _rel_path+=$(echo ${_pwd_path[@]/*/..} | sed 's/ /\//g;')/
        _rel_path+=$(echo ${_array_path[@]: $_c} | sed 's/ /\//g;')
    fi
    echo $_rel_path
}
function loop
{
    local _time=$1; shift;
    local _cmd=$@
    while true
    do
        sleep $_time
        echo $(dt) $(eval $@)
    done
}
function loop_times
{
    local _time=$1; shift;
    local -i _count=$1; shift;
    local _cmd=$@
    while [ $_count -gt 0 ]
    do
        sleep $_time
        eval $@
        _count=$_count-1
    done
}
complete -acb loop loop_times
set +a

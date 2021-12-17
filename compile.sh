#!/bin/bash
basePath=${HOME}
logPath="${basePath}/log/compile"
defaultCodePath="${basePath}/gitCode/postgres"
defaultInstallPath="${basePath}/pgrelease"
codePath=
checkOrNot=0
installOrNot=0
installPath=
cFlag=
check=
help()
{   
    echo "<-i codePath> [-c <o|p|.>] [-o <installPath>] [-D]"
    echo "-i means input. -o means output. -c means check. -D means debug"
    echo "code is o, oracle-check && make oracle-check-world. check is p, make check && make check-world not. check is b, both."
    echo "if installPath, install installPath, otherwise not install"
}
#user options
if [ $# -lt 1 ];then
    help
    exit 1
fi
while [ -n "$1" ];do
    case $1 in
        -i)
            codePath=$2
            if [ -z ${codePath} ];then
                help
                exit 1
            fi
            shift 2
            ;;
         -c)
             checkOrNot=1
             check=$2
             if [ -z ${check} ];then
                 help
                 exit 1
             fi
             shift 2
             ;;
          -o)
              installOrNot=1
              installPath=$2
              if [ -z ${installPath} ];then
                  help
                  exit 1
              fi
              shift 2
              ;;
          -D)
               cFlags="enable-debug CFLAGS='-DGCC_HASCLASSVISIBILITY -o0 -Wall -W -g3 -gdwarf-2'"
               shift 1
               ;;
           *)
               help
               exit 1
               ;;
      esac
done
#param check
if [ ${codePath} == "." ];then
    codePath=${defaultCodePath}
else
    if [ ! -d ${codPath} ];then
        echo "codePath is not exist."
        exit 1
    fi
fi

if [ ${checkOrNot} -eq 1 ];then
    if [ ${check} != "p" ] && [ ${check} != "o" ] && [ ${check} != "." ];then
        echo "check options ${check} wrong."
        exit 1
    fi
fi

if [ ${installOrNot} -eq 1 ];then
    if [ ${installPath} == "." ];then
        installPath=${defaultInstallPath}
    else
        if [ ! -d ${installPath} ];then
            echo "installPath is not exist."
            exit 1
        fi
    fi
else
    # in case install somewhere you should not
    installPath=${defaultInstallPath}
fi

if [ ! -d ${logPath} ];then
    mkdir -p ${logPath}
fi

#configure
echo "#################################################configure#######################################"
cd ${codePath}
./configure --prefix=${installPath} --with-zlib --enable-nls --enable-integer-datetimes --with-openssl --enable-cassert --with-libxml --with-uuid=e2fs --enable-debug CFLAGS='-O0 -g' |tee ${logPath}/configure.out

#make
echo "#################################################make ##########################################"
make world |tee ${logPath}/compile.log
#check
echo "################################################check ##########################################"
if [ ${checkOrNot} -eq 1 ];then
    if [ ${check} == "p" ];then
        make check |tee ${logPath}/check.log
        make check-world |tee -a ${logPath}/check.log
    #elif [ ${check} == "o" ];then
    #    make oracle-check |tee ${logPath}/oracle-check.log
    #    make oracle-check-world |tee -a ${logPath}/oracle-check.log
    elif [ ${check} == "." ] ;then
        make check |tee ${logPath}/checklog
        make check-world|tee -a ${logPath}/check.log
        make oracle-check |tee ${logPath}/oracle-check.log
        make oracle-check-world |tee -a ${logPath}/oracle-check.log
    else
        echo "check options ${check} wrong."
        exit 1
    fi
fi
#install
echo "####################################################install#######################################"
if [ ${installOrNot} -eq 1 ];then
    rm -rf ${installOrNot}/data
    make install-world
fi

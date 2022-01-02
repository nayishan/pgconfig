#!/bin/bash
basePath=${HOME}
defaultCode="${basePath}/gitCode/postgres"
bash_profile="${basePath}/.bashrc"
defaultPGHome="${basePath}/pgrelease"
pgHome=
pgUser=$(whoami)
userBin="${basePath}/config"
if [ $# -eq 1 ];then
    pgHome=${1}
else
    pgHome=${defaultPGHome}
fi

pgKeyWord=("PGHOME" "PGDATA" "MANPATH" "LANG" "DATE" "PGPORT" "PGHOST" "PGUSER" "PGCODE")
osKeyWord=("LD_LIBRARY_PATH" "PATH")

#delete
for keyword1 in ${pgKeyWord[@]}
do
    sed -i "/^${keyWord1}=/d" ${bash_profile}
    sed -i "/export ${keyWord1}/d" ${bash_profile}
done

#add pgkey
echo "export PGHOME=${pgHome}" >>${bash_profile}
echo "export PGDATA=\${PGHOME}/data" >>${bash_profile}
echo "export MANPATH=\${PGHOME}/share/man" >>${bash_profile}
echo "export LANG=en_US.utf8" >>${bash_profile}
echo "export DATE=\`date +\"%Y-%m-%d%H:%M:%S\"\`" >>${bash_profile}
echo "export PGPORT=34532" >>${bash_profile}
echo "export PGHOST=localhost" >>${bash_profile}
echo "export PGUSER=${pgUser}" >>${bash_profile}
echo "export PGCODE=${defaultCode}" >>${bash_profile}
#add oskey
for keyWord2 in ${osKeyWord[@]}
do
    if ! $(grep "^${keyWord2}=" ${bash_profile}|grep "\$PGHOME") && ! $(grep " ${keyWord2}=" ${bash_profile}|grep "\$PGHOME"); then
        if [ ${keyWord2} ==  ${osKeyWord[0]} ];then
            echo "export ${osKeyWord[0]}=\$${osKeyWord[0]}:\${PGHOME}/lib" >>${bash_profile}
        elif [ ${keyWord2} == ${osKeyWord[1]} ];then
            echo "export ${osKeyWord[1]}=\$${osKeyWord[1]}:\${PGHOME}/bin:${userBin}" >>${bash_profile}
        fi  
    fi  
done

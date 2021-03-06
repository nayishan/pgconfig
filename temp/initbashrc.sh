#!/bin/bash
basePath=${HOME}
pgCode="${basePath}/gitCode/postgressql-12.2"
kbCode="${basePath}/gitCode/postgresql_master"

bashrc="${basePath}/.bashrc"

pgHome="${basePath}/pgrelease"
kbHome="${basePath}/kbrelease"

pgUser=$(whoami)
kbUser=$(whoami)

userBin="${basePath}/pgconfig"


pgKeyWord=("KBHOME" "PGHOME" "KBHOME" "PGDATA" "KBMANPATH" "PGMANPATH" "LANG" "DATE" "KBPORT" "PGPORT" "KBPORT" "PGHOST" "KBPORT" "PGUSER" "KBCODE" "PGCODE")
osKeyWord=("LD_LIBRARY_PATH" "PATH")

#delete
for keyword1 in ${pgKeyWord[@]}
do
    sed -i "/^${keyWord1}=/d" ${bashrc}
    sed -i "/export ${keyWord1}/d" ${bashrc}
done

#add pgkey
echo "export KBHOME=${kbHome}" >>${bashrc}
echo "export PGHOME=${pgHome}" >>${bashrc}

echo "export KBDATA=\${KBHOME}/data" >>${bashrc}
echo "export PGDATA=\${PGHOME}/data" >>${bashrc}

echo "export KBMANPATH=\${KBHOME}/share/man" >>${bashrc}
echo "export PGMANPATH=\${PGHOME}/share/man" >>${bashrc}

echo "export LANG=en_US.utf8" >>${bashrc}
echo "export DATE=\`date +\"%Y-%m-%d%H:%M:%S\"\`" >>${bashrc}

echo "export KBPORT=34533" >>${bashrc}
echo "export PGPORT=34532" >>${bashrc}

echo "export KBHOST=localhost" >>${bashrc}
echo "export PGHOST=localhost" >>${bashrc}

echo "export KBUSER=${kbUser}" >>${bashrc}
echo "export PGUSER=${pgUser}" >>${bashrc}

echo "export KBCODE=${kbCode}"
echo "export PGCODE=${pgCode}" >>${bashrc}
#add oskey
for keyWord2 in ${osKeyWord[@]}
do
    if ! $(grep "^${keyWord2}=" ${bashrc}|grep "\$PGHOME") && ! $(grep " ${keyWord2}=" ${bashrc}|grep "\$PGHOME"); then
        if [ ${keyWord2} ==  ${osKeyWord[0]} ];then
            echo "export ${osKeyWord[0]}=\$${osKeyWord[0]}:\${PGHOME}/lib" >>${bashrc}
        elif [ ${keyWord2} == ${osKeyWord[1]} ];then
            echo "export ${osKeyWord[1]}=\$${osKeyWord[1]}:\${PGHOME}/bin:${userBin}" >>${bashrc}
        fi  
    fi  
done

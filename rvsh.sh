#!/bin/bash
#sudo apt-get install git
#git clone https://github.com/Snowv/Sky.git
#git add rvsh.sh 
#git commit -m "Description du commit"
#git log -p HEAD..FETCH_HEAD
#git remote add bob https://github.com/Snowa/Sky-1.git
#git fetch bob
#git merge bob/master
#git pull alice master
#git push bob master

programname=$0

function usage {
    echo "usage: $programname [-option] [nom_machine] [nom_utlisateur]"
    echo "  -connect    Le mode connect permet à un utilisateur de se connecter à une machine virtuelle"
    echo "  -admin      Cette commande permet à l’administrateur de gérer la liste des machines connectées au réseau virtuel"
    echo "              et la liste des utilisateurs. Lorsque que la commande admin est saisi il n'y a pas besoin de saisir le nom d'utilisateur"
    echo "              et le nom de la machine"
    echo "  -help       affiche de l'aide"
    exit 1
}
function usage_host {
    echo "usage: >rvsh host [create|remove] [nom_machine] "
    echo "  -connect    Le mode connect permet à un utilisateur de se connecter à une machine virtuelle"
    echo "  -admin      Cette commande permet à l’administrateur de gérer la liste des machines connectées au réseau virtuel"
    echo "              et la liste des utilisateurs. Lorsque que la commande admin est saisi il n'y a pas besoin de saisir le nom d'utilisateur"
    echo "              et le nom de la machine"
    echo "  -help       affiche de l'aide"
}

function admin {
    echo "Fonction administrateur"
    while [[ true ]]; do
        read -p ">rvsh " line
        cmd=$(echo $line | cut -f1 -d" ")
        case $cmd in
            host )
                action=$(echo $line | cut -f2 -d" ")
                machineName=$(echo $line | cut -f3 -d" ")
                host $action $machineName ;;
afinger )
;;
users )
;;
* )
echo "Commande inconnue"
;;
esac
done
}
function host {
    echo $*
  if [[ $(echo $* | wc -w) = 2 && $1 == "create" ]]; then
    createVirtualMachine $machineName
elif [[ $(echo $* | wc -w) = 2 && $1 == "remove" ]]; then
    removeVirtualMachine $machineName
else
    usage_host
fi
}
function createVirtualMachine {
    if [ ! -z $1  ]; then #test si la chaine est non vide
        if [  ! -d  $1 ]; then
            mkdir $machineName 
            echo "Machine $1 créée"
        else
            echo "La machine virtuel est déjà créée"
        fi
    else 
        echo "Nom de machine incorrect"
    fi
}
function removeVirtualMachine {
    if [ ! -z $1  ]; then #test si la chaine est non vide
        if [ -d  $1 ]; then
            rm -Rf $1 
            echo "Machine $1 supprimée"
        else
            echo "La machine virtuel n'est pas encore créée"
        fi
    else 
        echo "Nom de machine incorrect"
    fi
}
function connect {
    echo "Focntion connect"
}
if [[ ! -z $1 && $1 == "-admin" ]]; then
    admin
elif [[ ! -z $1 && $1 == "-connect" ]]; then
    connect
else
    usage
fi

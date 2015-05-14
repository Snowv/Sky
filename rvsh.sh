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
function usage_users {
    echo "usage: >rvsh host [create|remove] [nom_machine] "
    echo "  -connect    Le mode connect permet à un utilisateur de se connecter à une machine virtuelle"
    echo "  -admin      Cette commande permet à l’administrateur de gérer la liste des machines connectées au réseau virtuel"
    echo "              et la liste des utilisateurs. Lorsque que la commande admin est saisi il n'y a pas besoin de saisir le nom d'utilisateur"
    echo "              et le nom de la machine"
    echo "  -help       affiche de l'aide"
}
function users { # $action $userName $machineName $password
    echo "Commande administrateur users "
    if [[ $(echo $* | wc -w) = 4 && $1 == "add" ]]; then
        addUser $2 $3 $4 
    elif [[ $(echo $* | wc -w) = 3 && $1 == "remove" ]]; then
        removeUser $2 $3
    else
        usage_users
    fi
}
function addUser { 
    if [[ ! -z $1 && ! -z $2 && ! -z $3  ]]; then #test si la chaine est non vide
        if [[ -d $2 || ! -e $2/users ]]; then
        grep -q "$1 $2" $2/users
        if [ $? -ne 0 ]; then
            echo "$1 $2 $3" >> $2/users
            echo "Utilisateur $1 ajouté à la machine $2 avec le mdp $3"
        else
            echo "Utilisateur et machine déjà renseigné !"
        fi
        else
            echo "La machine $2 n'est pas encore créer"
        fi
    else 
        echo "Une valeur n'est pas renseigné !"
    fi
}
function removeUser {
    if [[ ! -z $1 && ! -z $2 ]]; then #test si la chaine est non vide
        if [[ -d $2 && -e $2/users ]]; then
        lineNumber=$(grep -n "$1 $2" $2/users | cut -f1 -d':')
        if [ ! -z $lineNumber ]; then
            d="d"
            sed -i -e "$lineNumber$d" $2/users 
            echo "Accès de l'utilisateur $1 supprimé de la machine $2"
        else
            echo "L'utilisateur n'est pas associé à cette machine"
        fi
        else
            echo "La machine $2 n'est pas encore créer ou il n'y a pas encore d'utilisateur autorisé à l'utiliser"
        fi
    else 
        echo "Une valeur n'est pas renseigné !"
    fi
}
function admin {
    echo "Commande administrateur"
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
action=$(echo $line | cut -f2 -d" ")
userName=$(echo $line | cut -f3 -d" ")
machineName=$(echo $line | cut -f4 -d" ")
password=$(echo $line | cut -f5 -d" ")
users $action $userName $machineName $password
;;
"" ) #Juste pour un meilleur effet visuel
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
        createVirtualMachine $2
    elif [[ $(echo $* | wc -w) = 2 && $1 == "remove" ]]; then
        removeVirtualMachine $2
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

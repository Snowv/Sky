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

#Exemple pour Rob' 
# ./rvsh.sh -admin #Lance programme en mode administrateur
    #Tu peux utiliser les commandes host, users, clear, afinger
    #exemple: 
    #host create pc5
    #host remove pc6
    #users add jojo pc5 aaa #ajoute l'utilisateur jojo à la machine pc5 avec le mdp aaa
    #users remove jojo pc5 #supprime l'acces à l'utilisateur jojo sur le pc5
    #afinger jojo #commande pour ajouter une desciption à l'utilisateur jojo
    #clear #similaire au clear de linux
#./rvsh.sh -connect jojo pc1 #lance le programme en mode utilisateur 

#mot de passe
#commande su

Red='\033[1;31m'

programname=$0
acess=acess
utilisateurCourant=""
machineCourante=""

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
function ftest {
    renseignerConnection
    fichier=infoUtilisateurs.txt
    path=$(pwd)
    nomComplet=$path/$fichier
    echo $t
    if [ -f $nomComplet ]; then
        echo "Le fichier existe"
    else
        echo "Le fichier n'existe pas"
        echo $(pwd)
    fi
}

function addUser {
    if [[ ! -d $acess ]]; then
       mkdir $acess
   fi 
    if [[ ! -z $1 && ! -z $2 && ! -z $3  ]]; then #test si la chaine est non vide
        if [[ -d $2 ]]; then
            if [[ -f $acess/$1 ]]; then
                grep -q "$2" $acess/$1
            fi
            if [[ ! -f $acess/$1 || $? -ne 0 ]]; then
                echo "$2" >> $acess/$1
                if [[ ! -f shadow || $(grep $1 shadow | wc -l) -eq 0 ]]; then
                    echo "$1:$3" >> shadow
                fi
                if [ -e infoUtilisateurs.txt ]; then
                    if [[ $(grep $1 infoUtilisateurs.txt | wc -l) -ne 1 ]]; then
                        pointv=":"
                        echo "$1$pointv" >> infoUtilisateurs.txt
                    fi
                else
                    pointv=":"
                    echo "$1$pointv" >> infoUtilisateurs.txt
                    
                fi
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
        if [[ -d $2 && -e $acess/$1 ]]; then
            lineNumber=$(grep -n "$2" $acess/$1 | cut -f1 -d':')
            if [ ! -z $lineNumber ]; then
                d="d"
                sed -i -e "$lineNumber$d" $acess/$1
                if [[ ! -s $acess/$1  ]]; then
                    rm $acess/$1
                fi
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

function who {
    while read ligne  
    do  
    user=$(echo $ligne | cut -f1 -d" ")
    machine=$(echo $ligne | cut -f2 -d" ")
    if [[ $1 = $user && $2 = $machine ]]; then
      echo $ligne | cut -f1,3-7 -d" "
  fi  
done < status
}

function admin {
    echo "Commande administrateur"
    while [[ true ]]; do
        echo -e "${Red}>rvsh \c"
        tput sgr0 #  Réinitialise les couleurs à la normale."
        read line
        cmd=$(echo $line | cut -f1 -d" ")
        case $cmd in
            host )
action=$(echo $line | cut -f2 -d" ")
machineName=$(echo $line | cut -f3 -d" ")
host $action $machineName ;;
afinger )
userName=$(echo $line | cut -f2 -d" ")
afinger $userName
;;
test )
ftest
;;
clear )
clear
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

function ajouterDescription { 
read -p "Entrez la description: " description
echo $1 $description
ligne=$(grep -n ^$1: infoUtilisateurs.txt | cut -f1 -d':')
d="d"
cmd=$ligne$d
sed -i -e "$cmd" infoUtilisateurs.txt
echo "$1:$description" >> infoUtilisateurs.txt
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
function afinger {
    compteur=1
    if [[ -f infoUtilisateurs.txt ]]; then 
        echo "Liste des utilisateurs du réseaux + Description :"
        for ligne in $(cat infoUtilisateurs.txt) ; do
            user=$(echo $ligne | cut -f1 -d":")
            desciprion=$(echo $ligne | cut -f2 -d":")
            echo -e "Utilisateur: $user\tDesciption:\t$desciprion"
            compteur=$(expr $compteur + 1)
        done
        nbLigne=$(grep $1: infoUtilisateurs.txt | wc -l)
        user=$(echo $ligne | cut -f1 -d":")
        if [[ $nbLigne -eq 1 ]]; then
            if [[ $(echo $* | wc -w) = 1 ]]; then
                ajouterDescription $1
            fi
        else
            echo "L'utilisateur $1 est inconnu"
        fi
    else
        echo "Vous n'avez pas encore ajouté des utilisateurs à votre réseau !"
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
function rhost {
    echo -e "\nListe des machines connectées : "
    liste=""
    for i in $(ls); do
        if [[ -d $i && $i != "acess" ]]; then
            liste="$liste $i"
        fi
    done
    echo -e "\n$liste"
}
function finger {
    grep $1 infoUtilisateurs.txt | cut -f2 -d':'
}
function passwd {
    echo "Changing password for $1 ."
    read -s -p "Tapez votre nouveau mot de passe " passwd1
    read -s -p "Tapez une seconde fois votre mot de passe " passwd2
    if [[ $passwd1 = $passwd2 ]]; then
        grep -n "$1" shadow
        lineNumber=$(grep -n "$1" shadow | cut -f1 -d':')
        if [ ! -z $lineNumber ]; then
            d="d"
            sed -i -e "$lineNumber$d" shadow
            echo "$1:$passwd1" >> shadow
        else
            echo "erreur"
        fi
    fi
}
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
    echo "Capture du Signal CTRL+C"
    if [[ ! -z utilisateurCourant && ! -z machineCourante ]]; then
        echo "Personne à déconnecter"
        exit $?
    fi
    exit $?
}

function su {
    if [[ ! -z $(grep $2 acess/$1) ]]; then
       retourGrep=$(grep "$1" shadow)
       if [[ ! -z $retourGrep ]]; then
        password=$(echo $retourGrep | cut -f2 -d':')
        read -s -p "Entrez le mot de passe : " motDePasse
        if [[ $motDePasse = $password ]]; then
            echo "SUCESS"
            renseignerDeconnection $3 $2
            modeConnect $1 $2
        else
            echo "Mot de passe incorrect"
        fi
    fi
else
    echo "Vous ne pouvez pas vous authentifier sur cette machine !"
fi
}
function renseignerConnection {
    date=$(date | cut -f1 -d',')
    heure=$(date | cut -f5 -d' ')
    echo $1 $2 $date $heure >> status 
}
function renseignerDeconnection {
    lineNumber=$(grep -n "$1 $2" status | cut -f1 -d':')
    if [[ ! -z $lineNumber ]]; then
        d="d"
        sed -i -e "$lineNumber$d" status
    fi
}
function modeConnect {
  while [[ true ]]; do
    echo -e "${Red}$1@$2> \c"
    tput sgr0 #  Réinitialise les couleurs à la normale."
    read line
    cmd=$(echo $line | cut -f1 -d" ")
    case $cmd in
        rhost )
rhost
;;
finger )
finger $1
;;
su )
userName=$(echo $line | cut -f2 -d" ")
su $userName $2 $1
;;
test )
ftest
;;
who )
who $1 $2
;;
clear )
clear
;;
passwd )
userName=$
passwd $1
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
if [[ ! -z $1 && $1 == "-admin" ]]; then
    admin
elif [[ ! -z $1 && $1 == "-connect" ]]; then
    if [[ $(echo $* | wc -w) = 3 && -d $3 ]]; then
        retourGrep=$(grep $2 shadow)
        if [[ ! -z $retourGrep ]]; then
            password=$(echo $retourGrep | cut -f2 -d':')
            read -s -p "Entrez votre mot de passe : " motDePasse
            if [[ $motDePasse = $password ]]; then
                echo "SUCESS"
                renseignerConnection $2 $3
                modeConnect $2 $3
            else
                echo "Mot de passe incorrect"
            fi
        else
            echo "Utilisateur inconnu ou machine inconnu"
        fi
    else
        usage
    fi
else
    usage
fi

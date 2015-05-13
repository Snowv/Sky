#!/bin/bash
#sudo apt-get install git
#git clone https://github.com/Snowv/Sky.git
#git add rvsh.sh 
#git commit -m "Description du commit"
#git log -p HEAD..FETCH_HEAD
#git remote add bob https://github.com/Snowa/Sky-1.git
#git fetch bob
#git merge bob/master

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
function admin {
    echo "Fonction administrateur"
    while [[ true ]]; do
        read -p ">rvsh " cmd
        if [ $cmd == "exit" ]; then
            break;
        fi
    done
}
function createVirtualMachine {

}
function removeVirtualMachine {

}
function connect {
    echo "Focntion connect"
}

if [ $1 == "-admin" ]; then
    admin
elif [ $1 == "-connect" ]; then
    connect
else
    usage
fi
